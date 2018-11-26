//
//  ICEDebugpush.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugpush.h"

@implementation ICEDebugpush
+(NSString *)processCommand:(NSArray *)args
{
    if (args.count < 2) {
        return [self defaultError];
    }
    NSString* vc = [args objectAtIndex:1];
    Class cls = NSClassFromString(vc);
    if (cls == NULL) {
        return @"error: no such viewcontroller";
    }
    UIViewController* vct = [[cls alloc]init];
    UIViewController* rootVc = [self getRootViewController];
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)rootVc pushViewController:vct animated:YES];
    }
    else
    {
         return @"root viewcontroller is not UINavigationController";
    }
    return @"success to push";
}
@end
