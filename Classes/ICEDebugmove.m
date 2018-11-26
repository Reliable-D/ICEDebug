//
//  ICEDebugmove.m
//  ICEDebug
//
//  Created by wujianrong on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugmove.h"
#import "ICEDebugMacro.h"

@implementation ICEDebugmove
+(NSString *)processCommand:(NSArray *)args
{
    if (args.count < 4) {
        return @"not enough parameters";
    }
    
    NSString* position = [args iceDebugSafeObjectAtIndex:1];
    id obj = [self getObjecFromStr:[args iceDebugSafeObjectAtIndex:2]];
    if (obj == nil) {
        return @"var wrong";
    }
    if ([obj isKindOfClass:[UIView class]] == NO) {
        return @"var wrong";
    }
    
    NSString* value = [args iceDebugSafeObjectAtIndex:3];
    int  realValue = [value intValue];
    if ([position isEqualToString:@"h"]) {
        ICE_DEBUG_MX((UIView*)obj, ICE_DEBUG_VL(((UIView*)obj))+realValue);
    }
    
    if ([position isEqualToString:@"v"]) {
        ICE_DEBUG_MY((UIView*)obj, ICE_DEBUG_VT(((UIView*)obj))+realValue);
    }
    
    if ([position isEqualToString:@"w"]) {
        ICE_DEBUG_MW((UIView*)obj, ICE_DEBUG_VW(((UIView*)obj))+realValue);
    }
    
    if ([position isEqualToString:@"he"]) {
        ICE_DEBUG_MH((UIView*)obj, ICE_DEBUG_VH(((UIView*)obj))+realValue);
    }
    
    return @"ok";
}
@end
