//
//  ICEDebugCommunicationManager.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugCommunicationManager.h"
#import "ICEDebugBaseCommand.h"
#import "ICEDebugCommonCommand.h"

static ICEDebugCommunicationManager* _static_ICEDebugCommunicationManager_instance = nil;
@implementation ICEDebugCommunicationManager
+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _static_ICEDebugCommunicationManager_instance = [[ICEDebugCommunicationManager alloc]init];
    });
    return _static_ICEDebugCommunicationManager_instance;
}


-(NSArray*)removeAllInvalideElementWithArray:(NSArray*)array
{
    NSMutableArray* ret = [[NSMutableArray alloc]init];
    for (NSString* str in array) {
        if (str == nil) {
            continue;
        }
        if (str.length == 0) {
            continue;
        }
        if ([str isEqualToString:@" "]) {
            continue;
        }
        [ret addObject:str];
    }
    return  ret;
}

-(NSString *)sendCmd:(NSString *)remoteCmd
{
    NSArray* command = [remoteCmd componentsSeparatedByString:@" "];
    
    command = [self removeAllInvalideElementWithArray:command];
    if (command.count <= 0) {
        return @"param error:No any parameters";
    }
    
    if ([ICEDebugCommonCommand containSimpleCommand:command[0]] == YES) {
        SEL sel = NSSelectorFromString(command[0]);
        if (sel == NULL) {
            return @"do not support such command";
        }
        id ret = [ICEDebugCommonCommand performSelector:sel];
        return [NSString stringWithFormat:@"%@", ret];
    }
    
    NSString* className = [NSString stringWithFormat:@"ICEDebug%@", command[0]];
    Class cls = NSClassFromString(className);
    if (cls == NULL) {
        className = command[0];
        cls = NSClassFromString(className);
        if (cls == nil) {
            return @"param error:no such command";
        }
    }
    if ([cls respondsToSelector:@selector(processCommand:)] == YES) {
        NSString* result = [cls processCommand:command];
        return result;
    }
    
    return @"good";
}
@end
