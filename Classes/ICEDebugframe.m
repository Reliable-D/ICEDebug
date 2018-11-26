//
//  ICEDebugframe.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugframe.h"
#import "ICEDebugMacro.h"

@implementation ICEDebugframe
+(NSString *)processCommand:(NSArray *)args
{
    if (args.count < 4) {
        return @"not enough parameters";
    }
    
    id obj = [self getObjecFromStr:[args iceDebugSafeObjectAtIndex:1]];
    if (obj == nil) {
        return @"var wrong";
    }
    
    if ([obj isKindOfClass:[UIView class]] == NO) {
        return [NSString stringWithFormat:@"%@ is not kind of UIView class", [args iceDebugSafeObjectAtIndex:1]];
    }
    NSString* subCmd = [args iceDebugSafeObjectAtIndex:2];
    NSString* value = [args iceDebugSafeObjectAtIndex:3];
    CGFloat realValue = [value floatValue];
    UIView* view = obj;
    [UIView animateWithDuration:0.5 animations:^{
        if ([subCmd isEqualToString:@"x"]) {
            ICE_DEBUG_MX(view, realValue);
        }
        
        if ([subCmd isEqualToString:@"y"]) {
            ICE_DEBUG_MY(view, realValue);
        }
        
        if ([subCmd isEqualToString:@"w"]) {
            ICE_DEBUG_MW(view, realValue);
        }
        
        if ([subCmd isEqualToString:@"h"]) {
            ICE_DEBUG_MH(view, realValue);
        }
        if ([subCmd isEqualToString:@"f"]) {
            if (args.count == 7) {
                CGFloat x = [args[3] floatValue];
                CGFloat y = [args[4] floatValue];
                CGFloat w = [args[5] floatValue];
                CGFloat h = [args[6] floatValue];
                view.frame = CGRectMake(x, y, w, h);
            }
        }
    }];
   
    
    return @"ok";
}

+(NSString *)comment
{
    return @"frame [view point] [x y w h f] [m]  [optional1--y] [optiona2--w] [optiona3--h] ";
}
@end
