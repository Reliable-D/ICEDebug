//
//  ICEDebugscreeninfo.m
//  ICEDebug
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugscreeninfo.h"
#include <sys/mount.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
@implementation ICEDebugscreeninfo
    +(NSString*)convert:(UIViewController *)vc
    {
        NSMutableString* str = [NSMutableString new];
        [str appendString:@"<!DOCTYPE html>\r\n"];
        [str appendString:@"<html lang=\"en\">\r\n"];
        [str appendString:@"<head>\r\n"];
        [str appendString:@"<meta charset=\"UTF-8\">\r\n"];
        [str appendString:@"<meta http-equiv=\"refresh\" content=\"5\">\r\n"];
        [str appendString:@"<title>screeninfo</title>\r\n"];
        [str appendString:@"</head><body>\r\n"];
        [str appendString:@"<h2>No Host: header received</h2>\r\n"];
        UIApplication* app = [UIApplication sharedApplication];
        [str appendString:[self addsubViews:app.delegate.window]];
        [str appendString:@"</body></html>"];
        
        return str;
    }
    
    +(NSString*)colorToHexString:(UIColor*)color
    {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        if (color != nil) {
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        return [NSString stringWithFormat:@"%02x%02x%02x", (int)(red*255), (int)(green*255), (int)(blue*255)];
    }
    
    +(NSString*)colorToString:(UIColor*)color
    {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        if (color != nil) {
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", (int)(red*255), (int)(green*255), (int)(blue*255), alpha];
    }
    

    
    +(NSString*)addsubViews:(UIView*)view
    {
        NSMutableString* str = [NSMutableString new];
        [str appendFormat:@"<div style=\"%@%@%@%@", [self makeBackGroundColor:view], [self makePosition:view], [self makeRadius:view], [self makeBorder:view]];
        if ([view isKindOfClass:[UILabel class]]) {
            
            [str appendString:[self makeLabelValue:view]];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            [str appendString:[self makeImageView:view]];
        }

        [str appendFormat:@"\">"];
        if ([view isKindOfClass:[UILabel class]]) {
            if ([(UILabel*)view text].length > 0) {
                [str appendString:[(UILabel*)view text]];
            }
            
        }
        [str appendFormat:@"</div>"];
        for (UIView* subView in view.subviews) {
            [str appendString:[self addsubViews:subView]];
        }
        
        return str;
    }
    
    +(NSString*)makeBackGroundColor:(UIView*)view
    {
        if (view.hidden == YES) {
            return @"opacity: 0.0;";
        }
        return [NSString stringWithFormat:@"background: %@;", [self colorToString:[view backgroundColor]]];
    }
    
    +(NSString*)makePosition:(UIView*)view
    {
        CGRect realFrame = [view convertRect:view.bounds toView:[UIApplication sharedApplication].delegate.window];
        return [NSString stringWithFormat:@"position: absolute; width: %dpx; height: %dpx; left: %dpx; top: %dpx;",(int)realFrame.size.width, (int)realFrame.size.height, (int)realFrame.origin.x, (int)realFrame.origin.y];
    }
    
    +(NSString*)makeRadius:(UIView*)view
    {
        if (view.layer.cornerRadius < 0.5) {
            return @"";
        }
        return [NSString stringWithFormat:@"border-radius:%dpx;",(int)view.layer.cornerRadius];
    }
    
    +(NSString*)makeBorder:(UIView*)view
    {
        if (view.layer.borderWidth < 0.5) {
            return @"";
        }
        
        return [NSString stringWithFormat:@"border: %dpx solid #%@;", (int)view.layer.borderWidth, [self colorToHexString:[UIColor colorWithCGColor:view.layer.borderColor]]];
    }
    
    +(NSString*)makeLabelValue:(UILabel*)label
    {
        //text-align:center; line-height:30px; height:30px;
        if (label.textAlignment == NSTextAlignmentCenter) {
            return [NSString stringWithFormat:@"color: #%@; font-size: %dpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align:center; line-height:30px; height:30px", [self colorToHexString:label.textColor], (int)label.font.pointSize];
        }
        else
        {
            return [NSString stringWithFormat:@"color: #%@; font-size: %dpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; line-height:30px; height:30px;", [self colorToHexString:label.textColor], (int)label.font.pointSize];
        }
        
    }
    
    +(NSString*)makeImageView:(UIImageView*)imageView
    {
        [self addImageView:imageView];
        return [NSString stringWithFormat:@"background-image: url('http://%@:10087/%@.png'); background-size: contain;",[self getIPAddress:YES], [NSString stringWithFormat:@"%lx", (long)imageView]];
    }
    
   
    
    static NSMutableDictionary* _static_ice_debugImageViewList = nil;
    
    +(void)addImageView:(UIImageView*)view
    {
        if (_static_ice_debugImageViewList == nil) {
            _static_ice_debugImageViewList = [NSMutableDictionary new];
        }
        [_static_ice_debugImageViewList setObject:view forKey:[NSString stringWithFormat:@"%lx", (long)view]];
    }
    
    +(UIImage*)getImageWithKey:(NSString*)key
    {
        UIImageView* view = [_static_ice_debugImageViewList objectForKey:key];
        //   [_static_ice_debugImageViewList removeObjectForKey:key];
        return view.image;
    }
    
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

    + (NSString *)getIPAddress:(BOOL)preferIPv4
    {
        NSString* result = nil;
        if (result.length > 0) {
            return result;
        }
        NSArray *searchArray = preferIPv4 ?
        @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
        @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
        
        NSDictionary *addresses = [self getIPAddresses];
        //DebugLog(@"addresses: %@", addresses);
        
        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
             address = addresses[key];
             //筛选出IP地址格式
             if([self isValidatIP:address]) *stop = YES;
         } ];
        result = address ? address : @"0.0.0.0";
        return result;
    }
    
    
+ (NSDictionary *)getIPAddresses
    {
        NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
        
        // retrieve the current interfaces - returns 0 on success
        struct ifaddrs *interfaces;
        if(!getifaddrs(&interfaces)) {
            // Loop through linked list of interfaces
            struct ifaddrs *interface;
            for(interface=interfaces; interface; interface=interface->ifa_next) {
                if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                    continue; // deeply nested code harder to read
                }
                const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
                char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                    NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                    NSString *type;
                    if(addr->sin_family == AF_INET) {
                        if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv4;
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv6;
                        }
                    }
                    if(type) {
                        NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                        addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    }
                }
            }
            // Free memory
            freeifaddrs(interfaces);
        }
        return [addresses count] ? addresses : nil;
    }
    
    + (BOOL)isValidatIP:(NSString *)ipAddress {
        if (ipAddress.length == 0) {
            return NO;
        }
        NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
        "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
        "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
        "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
        
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
        
        if (regex != nil) {
            NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
            
            if (firstMatch) {
                //NSRange resultRange = [firstMatch rangeAtIndex:0];
                //NSString *result=[ipAddress substringWithRange:resultRange];
                //输出结果
                //DebugLog(@"%@",result);
                return YES;
            }
        }
        return NO;
    }
@end
