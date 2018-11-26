//
//  ICEDebugvctree.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugvctree.h"

@implementation ICEDebugvctree

+(NSString*)processCommand:(NSArray*)args
{
    UIViewController* rootVc = [self getRootViewController];
    
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        return [NSString stringWithFormat:@"%@", [(UINavigationController*)rootVc viewControllers]];
    }
    
    if ([rootVc isKindOfClass:[UIViewController class]]) {
        return [NSString stringWithFormat:@"%@", rootVc];
    }
    

    
    return @"something is wrong";
}
@end
