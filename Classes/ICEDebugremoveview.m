//
//  ICEDebugremoveview.m
//  ICEDebug
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugremoveview.h"
#import "ICEDebugMacro.h"

@implementation ICEDebugremoveview
    
+(NSMutableDictionary*)getPublicViewMapping
    {
        static NSMutableDictionary* _static_view_Dic = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _static_view_Dic = [NSMutableDictionary new];
        });
        return _static_view_Dic;
    }
    
    static UIView* _static_lastView = nil;
    
+(UIView*)lastView{
    return _static_lastView;
}

    +(void)setLastView:(UIView*)view
    {
        _static_lastView = view;
    }
    
+(NSString *)processCommand:(NSArray *)args{

    NSString* viewAddr = [args iceDebugSafeObjectAtIndex:1];
    UIView* view = nil;
    if (viewAddr.length > 0) {

            NSInteger level = [viewAddr intValue];
            [self removeWithLevel:level];
        
    }
    else
    {
        [self removeView:[self getTopView]];
    }
    
    return @"ok";
}
+(UIView*)getRootView
    {
        UIViewController* vc = [self getRootViewController];
        UIViewController* topVc = nil;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            topVc = [(UINavigationController*)vc topViewController];
        }
        else if ([vc isKindOfClass:[UIViewController class]]) {
            topVc = vc;
        }
        else{
            return nil;
        }
        return topVc.view;
    }
    
    +(UIView*)getTopView
    {
        
        UIView* tmpView = [self getRootView];
        NSMutableArray* allSubViews = [self getAllSubViewsWithView:tmpView level:0 mainArray:nil];
        tmpView = [[allSubViews iceDebugSafeObjectAtIndex:allSubViews.count-1] iceDebugSafeObjectAtIndex:0];
        return tmpView;
    }
    
    +(NSMutableArray*)getAllSubViewsWithView:(UIView*)view level:(NSInteger)level mainArray:(NSMutableArray*)mainArray
    {
        if (level == 0) {
            mainArray = [NSMutableArray new];
        }
        if (view.subviews.count == 0) {
            return nil;
        }
        NSMutableArray* array = [mainArray iceDebugSafeObjectAtIndex:level];
        if (array == nil) {
            array = [NSMutableArray new];
            [mainArray addObject:array];
        }
        [array addObjectsFromArray:view.subviews];
        for (UIView* subView in view.subviews) {
            [self getAllSubViewsWithView:subView level:(level+1) mainArray:mainArray];
        }
        return mainArray;
    }
    
    +(void)removeWithLevel:(int)level{
        
        if (level < 0) {
            level = 0;
        }
        NSMutableArray* array = [self getAllSubViewsWithView:[self getRootView] level:0 mainArray:nil];
        
        NSArray* levelArray = [array iceDebugSafeObjectAtIndex:(array.count-1-level)];
        if (levelArray != nil) {
            for (UIView* view in levelArray) {
                [self removeView:view];
            }
        }
    }
    
    +(void)removeView:(UIView*)view
    {
        if (view.superview != nil) {
            NSMutableDictionary* dit = [self getPublicViewMapping];
            _ICEDebugRemoveViewStructs* obj = [_ICEDebugRemoveViewStructs new];
            obj.view = view;
            obj.frame = view.frame;
            obj.alpha = view.alpha;
            obj.superView = [view superview];
            obj.lastView = [self lastView];
            [self setLastView:view];
            [dit setObject:obj forKey:[NSString stringWithFormat:@"%lu", (unsigned long)[view hash]]];
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(ICE_DEBUG_VL(view) + (ICE_DEBUG_VW(view)/2.0), ICE_DEBUG_VT(view)+(ICE_DEBUG_VH(view)/2.0), 0, 0);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
            
        }
    }
    
@end

@implementation _ICEDebugRemoveViewStructs

@end
