//
//  ICEDebugsubviews.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugsubviews.h"
#import "ICEDebugMacro.h"

@implementation ICEDebugsubviews
+(NSString *)processCommand:(NSArray *)args
{
    return [self getAllSubvews:[args iceDebugSafeObjectAtIndex:1]];
}


+(NSString*)getAllSubvews:(NSString*)viewsCommand
{
    NSObject* reOb = [self getObjecFromStr:viewsCommand];
    UIView* view = nil;
    if ([reOb isKindOfClass:[UIViewController class]]) {
        view = [(UIViewController*)reOb view];
    }
    if ([reOb isKindOfClass:[UIView class]]) {
        view = reOb;
    }
    
    if (view == nil) {
        return @"not view class";
    }
    return [self allSubvews:view];
}

+(NSString*)allSubvews:(UIView*)view
{

    
    NSString* str = [NSString stringWithFormat:@"\n%@\n",[self subViews:view level:0]];
    return str;
}

+(NSString*)subViews:(UIView*)view level:(int)level
{
    NSMutableString* str = [[NSMutableString alloc]init];
    NSArray* array = [view subviews];
    if (array.count == 0) {
        return @"";
    }
    for (int i=0; i < array.count; i++) {
        UIView* tmpView = [array objectAtIndex:i];
        NSMutableString* tmpStr = [NSMutableString new];
        for (int j=0; j < (level*4); j++) {
            [tmpStr appendString:@" "];
        }
        [str appendFormat:@"%@%@:0x%lx  [%.1f,  %.1f,  %.1f, %.1f]\n", tmpStr, [tmpView class], (long)tmpView, ICE_DEBUG_VL(tmpView), ICE_DEBUG_VT(tmpView), ICE_DEBUG_VW(tmpView), ICE_DEBUG_VH(tmpView)];
        if (tmpView.subviews.count > 0) {
            [str appendFormat:@"%@", [self subViews:tmpView level:level+1]];
        }
        
    }
    
    return str;
}

+(NSString *)comment
{
    return @" subviews [view point]";
}
@end
