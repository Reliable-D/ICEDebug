//
//  ICEDebugaddview.m
//  ICEDebug
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugaddview.h"
#import "ICEDebugremoveview.h"

@implementation ICEDebugaddview
+(NSString *)processCommand:(NSArray *)args{
    NSString* cmd = [args iceDebugSafeObjectAtIndex:1];
    
    if ([cmd isEqualToString:@"all"]) {
        while (1) {
            UIView* view = [ICEDebugremoveview lastView];
            if (view == nil) {
                break;
            }
            [self addview:view];
        }
    }
    else
    {
        UIView* view = [ICEDebugremoveview lastView];
        [self addview:view];
    }
    
    return @"OK";
}

+(void)addview:(UIView*)view{
    
    if (view == nil) {
        return ;
    }
    
    NSString* key = [NSString stringWithFormat:@"%lu", (unsigned long)[view hash]];
    _ICEDebugRemoveViewStructs* obj = [[ICEDebugremoveview getPublicViewMapping] objectForKey:key];
    [ICEDebugremoveview setLastView:obj.lastView];
    [[ICEDebugremoveview getPublicViewMapping] removeObjectForKey:key];
    if (obj.superView != nil) {
        [obj.superView addSubview:view];
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = obj.frame;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
@end
