//
//  ICEDebughelp.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebughelp.h"
#import "ICEDebugCommonCommand.h"

#ifdef DEBUG
@implementation ICEDebughelp

+(NSString *)processCommand:(NSArray *)args
{
    NSArray* array = [NSObject iceDebugAllClassesOfKind:[ICEDebugBaseCommand class]];
    NSMutableArray* retArray = [[NSMutableArray alloc]init];
    for (int i=0; i < array.count; i++) {
        NSString* tmp = NSStringFromClass(array[i]);
        if ([tmp isEqualToString:@"ICEDebugBaseCommand"]) {
            continue;
        }
        NSString* realCommand = [tmp stringByReplacingOccurrencesOfString:@"ICEDebug" withString:@" "];
        Class class = array[i];
        NSString* comment = @"";
        if (class != NULL) {
            comment = [class comment];
        }
        NSString* plusComment = [NSString stringWithFormat:@"%@  :  %@", realCommand, comment];
        [retArray addObject:plusComment];
    }
    
    [retArray addObject:[NSString stringWithFormat:@"    "]];
    [retArray addObjectsFromArray:[ICEDebugCommonCommand getAllCommand]];
    return [NSString stringWithFormat:@"%@", retArray];
}
@end
#endif
