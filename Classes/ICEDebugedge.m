//
//  ICEDebugedge.m
//  ICEDebug
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugedge.h"

@implementation ICEDebugedge
    
+ (NSInteger)getRandomDataWithNumber:(NSInteger)number{
        srand(100000);
        int a = arc4random() % number;
        return a;
}
    
+ (void)uiViewBorderDebug:(UIView*)view{
    
    if (view.subviews.count <= 0) {
        return;
    }
    for (UIView* subview in [view subviews]) {
       
        UIColor* viewcolor =  [UIColor colorWithRed:[self getRandomDataWithNumber:256]/255.0 green:[self getRandomDataWithNumber:256]/255.0 blue:[self getRandomDataWithNumber:256]/255.0 alpha:1.0f];
        subview.layer.borderColor = viewcolor.CGColor;
        subview.layer.borderWidth = 1.0f;
        [self uiViewBorderDebug:subview];
    }
}

+(NSString *)processCommand:(NSArray *)args{
    UIApplication* app = [UIApplication sharedApplication];
    [self uiViewBorderDebug:app.delegate.window];
    return @"ok";
}

@end
