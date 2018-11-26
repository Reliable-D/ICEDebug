//
//  ICEDebugCommonCommand.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugCommonCommand.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/objc.h>
#import <objc/message.h>
#import "ICEDebugBaseCommand.h"
#import "ICEDebugUIRuler.h"
#import "ICEDebugMacro.h"
#import "ICEDebugsubviews.h"

@implementation ICEDebugCommonCommand


+(NSArray*)getPropertiesAndMethods
{
    u_int count = -1;
    
    Class clazz = [self class];
    //Describes the instance variables declared by a class.
    Ivar* ivars = class_copyIvarList(clazz, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        //Returns the name of an instance variable.
        const char* ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    //Describes the properties declared by a class.
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        //A C string containing the property's name
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    //Describes the instance methods implemented by a class.
    Method* methods = class_copyMethodList(clazz, &count);
    NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        //Returns the name of a method.
        SEL selector = method_getName(methods[i]);
        //Returns the name of the method specified by a given selector.
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    
    //get meta class
    NSMutableArray* classMethodArray = [[NSMutableArray alloc]init];
    Class metaClass = objc_getMetaClass([NSStringFromClass(clazz)UTF8String]);
    
    Method* metaMethods = class_copyMethodList(metaClass, &count);
    
    for (int i = 0; i < count ; i++)
    {
        //Returns the name of a method.
        SEL selector = method_getName(metaMethods[i]);
        //Returns the name of the method specified by a given selector.
        const char* methodName = sel_getName(selector);
        [classMethodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    
//    NSString* className = NSStringFromClass([self class]);
//    NSMutableDictionary* dumpClass = [[NSMutableDictionary alloc]init];
//    [dumpClass setValue:classMethodArray forKey:@"metaMethods(+)"];

    return classMethodArray;
}

+(BOOL)containSimpleCommand:(NSString*)command
{
    if (command.length <= 0) {
        return NO;
    }
    
    SEL sel = NSSelectorFromString(command);
    if (sel == NULL) {
        return NO;
    }
    
    if ([self respondsToSelector:sel] == NO) {
        return NO;
    }
    return YES;
}

+(NSArray*)getAllCommand
{
    NSArray* array = [self getPropertiesAndMethods];
 
    NSMutableArray* realArray = [NSMutableArray new];
    NSDictionary* exceptDit = @{
                                @"getAllCommand":@"value",
                                @"containSimpleCommand:":@"value",
                                @"getPropertiesAndMethods":@"value",
                                };
    for (NSString* ele in array) {
        id value = [exceptDit objectForKey:ele];
        if (value == nil) {
            [realArray addObject:ele];
        }
    }
    return realArray;
}

+(NSString*)keywindow
{
    NSString* stt = [NSString stringWithFormat:@"%@", [UIApplication sharedApplication].keyWindow];
    // [self sendMessage:stt];
    return stt;
}

+(NSString*)config
{
    NSString* compileTime = [NSString stringWithFormat:@"Date:%s  Time:%s", __DATE__, __TIME__];
    NSString* bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* bundleShordVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString* version = [NSString stringWithFormat:@"BundleId:%@ \r\nVersion:%@(%@) \r\nBuildTime:%@", bundleId, bundleShordVersion, bundleVersion, compileTime];
    
    return version;
}

+(NSString*)poproot
{
    UIViewController* vc = [ICEDebugBaseCommand getRootViewController];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)vc popToRootViewControllerAnimated:YES];
        return @"pop success";
    }
    return @"pop failed";
}

+(NSString *)rule1
{
    ICEDebugUIRuler* ruler = [[ICEDebugUIRuler alloc]initWithFrame:CGRectMake(0, 0, ICE_DEBUG_SCREEN_WIDTH, ICE_DEBUG_SCREEN_HEIGHT)];
    ruler.isMovedInMiddle = YES;
    [[[UIApplication sharedApplication]keyWindow] addSubview:ruler];
    return @"ok";
}

+(NSString *)rule2
{
    ICEDebugUIRuler* ruler = [[ICEDebugUIRuler alloc]initWithFrame:CGRectMake(0, 0, ICE_DEBUG_SCREEN_WIDTH, ICE_DEBUG_SCREEN_HEIGHT)];
    ruler.isMovedInMiddle = NO;
    [[[UIApplication sharedApplication]keyWindow] addSubview:ruler];
    return @"ok";
}

+(NSString*)topvc
{
    UIViewController* vc = [ICEDebugBaseCommand getRootViewController];
    UIViewController* topVc = nil;
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        topVc = [(UINavigationController*)vc topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        topVc = vc;
    }
    
    if (topVc != nil) {
        return [ICEDebugsubviews allSubvews:topVc.view];
    }
    
    return @"something is wrong";
}


@end
