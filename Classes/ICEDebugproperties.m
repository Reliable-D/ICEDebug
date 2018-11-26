//
//  ICEDebugproperties.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugproperties.h"

@implementation ICEDebugproperties
+(NSString *)processCommand:(NSArray *)args
{
    if (args.count < 2) {
        return [self defaultError];
    }
    NSString* object = args[1];
    NSString* superLevers = [args iceDebugSafeObjectAtIndex:2];
    

    int superL = 0;
    if (object.length <= 0) {
        return @"param error";
    }
    if (superLevers.length > 0) {
        superL = [superLevers intValue];
    }
    NSObject* reOb = [self getObjecFromStr:object];
    NSDictionary* allKey = [reOb iceDebugGetAllValuesWithSuber:superL];
    NSString* stt = [NSString stringWithFormat:@"%@", [self descriptionOfDictionary:allKey]];
    
    return stt;
}
@end
