//
//  ICEDebugopenurl.m
//  ICEDebug
//
//  Created by apple on 2018/11/24.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugopenurl.h"

@implementation ICEDebugopenurl
+(NSString *)processCommand:(NSArray *)args
    {
        NSString* url = [args iceDebugSafeObjectAtIndex:1];
        if (url.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        return @"OK";
    }
    
@end
