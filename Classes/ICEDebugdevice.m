//
//  ICEDebugdevice.m
//  ICEDebug
//
//  Created by wujianrong on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugdevice.h"

#import<SystemConfiguration/CaptiveNetwork.h>
#import<SystemConfiguration/SystemConfiguration.h>
#import<CoreFoundation/CoreFoundation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#include <sys/mount.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
@implementation ICEDebugdevice
+(NSString *)processCommand:(NSArray *)args{
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    NSDictionary *screenSizeDict = (__bridge_transfer NSDictionary*)CGSizeCreateDictionaryRepresentation(screenSize);
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          device.localizedModel, @"localizedModel",
                          [NSNumber numberWithBool:device.multitaskingSupported], @"multitaskingSupported",
                          device.name, @"name",
                          (UIDeviceOrientationIsLandscape(device.orientation) ? @"landscape" : @"portrait"), @"orientation",
                          device.systemName, @"systemName",
                          device.systemVersion, @"systemVersion",
                          screenSizeDict, @"screenSize",
                          [NSNumber numberWithDouble:screen.scale], @"screenScale",
                          nil];
    return [NSString stringWithFormat:@"%@,%@", info, [self getDeviceInfo]];
}

#define ICE_DEBUG_SAFE_STRING(S) [self safeString:S]
+(NSString*)safeString:(NSString*)string
{
    if (string == nil) {
        return @"";
    }
    if (![string isKindOfClass:[NSString class]]) {
        return  @"";
    }
    return string;
}
+ (NSString*)getDeviceInfo {

    NSString* result = nil;
    NSString *OSVersion;
    UIDevice *device = [UIDevice currentDevice];
    OSVersion = [device systemVersion];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString* proxyIpStr = [self proxyUrl];
   
    CGRect screenRect = [UIScreen mainScreen ].bounds;
    //剩余电量
    NSString* batteryLevelStr = [NSString stringWithFormat:@"%0f",[UIDevice currentDevice].batteryLevel*100.0];
    
    //idfa idfv
    NSString *idfvStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];;
    
    
    //wifi name、mac
    NSString *wifiName = @"NotFound";
    NSString *wifiMac = @"NotFound";
    NSDictionary* wifiDict = [self checkWifiInfo];
    if (wifiDict) {
        wifiName = [wifiDict valueForKey:@"SSID"];
        wifiMac = [wifiDict valueForKey:@"BSSID"];
    }
    
    //开机时间
    NSString* deviceLaunchTime = [self getLaunchSystemTime];
   
    
    //网络制式
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    NSString* simTechnologyInfo = [self checkNetworkTypeWithNetworkInfo:info];
    NSString* cellularProviderInfo = [self checkCarrierWithNetworkInfo:info];
    NSString* mncStr = [self mncInCarrier:[info subscriberCellularProvider]];
    NSString* mccStr = [self mccInCarrier:[info subscriberCellularProvider]];
  
    
   
    
    
    
    NSDictionary* dict = @{
                           @"osName": @"iOS",
                           @"osVersion": ICE_DEBUG_SAFE_STRING(OSVersion),

                           @"appVersion": ICE_DEBUG_SAFE_STRING(appVersion),
                           @"cpu":ICE_DEBUG_SAFE_STRING([self getCPUType]),
                           @"memory":ICE_DEBUG_SAFE_STRING([self getTotalMemorySize]),
                           @"cellularProvider":cellularProviderInfo,
                           @"simTechnology":simTechnologyInfo,
                    
                           @"capacity":ICE_DEBUG_SAFE_STRING([self getTotalDiskSize]),
                           @"availableCapacity":ICE_DEBUG_SAFE_STRING([self getAvailableDiskSize]),
                           @"wifiName":ICE_DEBUG_SAFE_STRING(wifiName),
                           @"wifiMac":ICE_DEBUG_SAFE_STRING(wifiMac),
                           @"manfacture":@"Apple",
                           @"proxyIp":ICE_DEBUG_SAFE_STRING(proxyIpStr),
                           @"battery":ICE_DEBUG_SAFE_STRING(batteryLevelStr),
                    
                           @"idfv":ICE_DEBUG_SAFE_STRING(idfvStr),
                           @"appUtm":@"AppStore",
                           @"mnc":ICE_DEBUG_SAFE_STRING(mncStr),
                           @"mcc":ICE_DEBUG_SAFE_STRING(mccStr),
                           @"deviceLaunchTime":ICE_DEBUG_SAFE_STRING(deviceLaunchTime),
                           
                           };
    result = [NSString stringWithFormat:@"%@", dict];

    return result;
}



+ (NSString *)proxyUrl
{
    static NSString* result = nil;
    if (ICE_DEBUG_SAFE_STRING(result).length > 0) {
        return result;
    }
    NSDictionary* proxyDict = (NSDictionary *)CFBridgingRelease(CFNetworkCopySystemProxySettings());
    
    if (proxyDict) {
        NSNumber* isHTTPEnable = [proxyDict objectForKey:(NSString *)CFBridgingRelease(kCFNetworkProxiesHTTPEnable)];
        NSNumber* isAutoConfigEnable = [proxyDict objectForKey:(NSString *)CFBridgingRelease(kCFNetworkProxiesProxyAutoConfigEnable)];
        
        if (isHTTPEnable.boolValue) {
            NSString* httpServer = [proxyDict objectForKey:(NSString *)CFBridgingRelease(kCFNetworkProxiesHTTPProxy)];
            NSNumber* httpPort = [proxyDict objectForKey:(NSString *)CFBridgingRelease(kCFNetworkProxiesHTTPPort)];
            result = [NSString stringWithFormat:@"%@:%zd",httpServer,httpPort.integerValue];
            return result;
        }
        
        if (isAutoConfigEnable.boolValue) {
            NSString* autoConfigUrl = [proxyDict objectForKey:(NSString *)CFBridgingRelease(kCFNetworkProxiesProxyAutoConfigURLString)];
            result = autoConfigUrl;
            return autoConfigUrl;
        }
    }
    return @"";
}


#pragma mark- get info
+ (NSDictionary*)checkWifiInfo {
    static NSDictionary *dict = nil;
    if (dict != nil) {
        return dict;
    }
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != NULL) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != NULL) {
            dict = (NSDictionary*)CFBridgingRelease(myDict);
        }
        CFRelease(myArray);
    }
    return dict;
}

+ (NSString*)mncInCarrier:(CTCarrier *)carrier {
    NSString *ret = @"UNKNOWN";
    if (carrier == nil) {
        return ret;
    }
    
    return [carrier mobileNetworkCode];
}

+ (NSString*)mccInCarrier:(CTCarrier *)carrier {
    NSString *ret = @"UNKNOWN";
    if (carrier == nil) {
        return ret;
    }
    
    return [carrier mobileCountryCode];
}

+ (NSString*)isoInCarrier:(CTCarrier *)carrier {
    NSString *ret = @"UNKNOWN";
    if (carrier == nil) {
        return ret;
    }
    
    return [carrier isoCountryCode];
}

+ (NSString*)carrierNameInCarrier:(CTCarrier *)carrier {
    NSString *ret = @"UNKNOWN";
    if (carrier == nil) {
        return ret;
    }
    
    return [carrier carrierName];
}

/**
 设备所使用网络的运营商
 参考network code wiki:https://en.wikipedia.org/wiki/Mobile_country_code#China_-_CN
 @return name
 */
+ (NSString *)checkCarrierWithNetworkInfo:(CTTelephonyNetworkInfo*)info
{
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *ret = @"UNKNOWN";
    if (carrier == nil) {
        return ret;
    }
    NSString *code = [carrier mobileNetworkCode];
    if ([code isEqual:@""]) {
        return ret;
    } else if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"] || [code isEqualToString:@"08"]) {
        ret = @"China Mobile";
    } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"] || [code isEqualToString:@"09"] ) {
        ret = @"China Unicom";
    } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"] || [code isEqualToString:@"11"] ) {
        ret = @"China Telecom";
    } else if ([code isEqualToString:@"20"]) {
        ret = @"China Tietong";
    }
    return ret;
}


/**
 获取网络制式
 
 @param info <#info description#>
 @return <#return value description#>
 */
+ (NSString*)checkNetworkTypeWithNetworkInfo:(CTTelephonyNetworkInfo*)info {
    
    NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    NSString *strNetworkType = @"UNKNOWN";
    if (currentRadioAccessTechnology)
    {
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
            strNetworkType = @"GPRS";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
            strNetworkType = @"Edge";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            strNetworkType = @"WCDMA";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            strNetworkType = @"HSDPA";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            strNetworkType = @"HSUPA";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            strNetworkType = @"CDMA1x";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            strNetworkType = @"CDMAEVDORev0";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            strNetworkType = @"CDMAEVDORevA";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            strNetworkType = @"CDMAEVDORevB";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            strNetworkType = @"eHRPD";
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            strNetworkType = @"LTE";
        }
    }
    return strNetworkType;
}

+ (NSString*)getCPUType
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_I386) {
        [cpu appendString:@"i386"];
    } else if (type == CPU_TYPE_X86_64) {
        [cpu appendString:@"x86_64"];
    } else if (type == CPU_TYPE_X86) {
        [cpu appendString:@"x86"];
    } else if (type == CPU_TYPE_ARM) {
        [cpu appendString:@"arm"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"v6"];
                break;
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"v7"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"v7s"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"V8"];
                break;
            default:
                [cpu appendFormat:@",subtype:%d",subtype];
                break;
        }
    } else if (type == CPU_TYPE_ARM64) {
        [cpu appendString:@"arm64"];
    } else {
        [cpu appendFormat:@"cputype:%d,subtype:%d",type,subtype];
    }
    
    return cpu;
}



+ (NSString*)getLaunchSystemTime {
    NSString* result = nil;
    int mib[2];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        // successful call
        NSDate* bootDate = [NSDate dateWithTimeIntervalSince1970:boottime.tv_sec];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        result = [format stringFromDate:bootDate];
    }
    
    return result;
}



//磁盘大小
+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}

//获取总内存大小
+ (NSString*)getTotalMemorySize
{
    return [self fileSizeToString:[NSProcessInfo processInfo].physicalMemory];
}

//磁盘总量
+ (NSString*)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return [self fileSizeToString:freeSpace];
}

//获取可用磁盘容量
+ (NSString*)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return [self fileSizeToString:freeSpace];
}

@end
