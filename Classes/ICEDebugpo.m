//
//  ICEDebugpo.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugpo.h"

@implementation ICEDebugpo

+(NSString *)processCommand:(NSArray *)args
{
    NSString* result = [self poMessage:args];
    return result;
}

+(NSString*)poMessage:(NSArray*)array
{
    if (array.count <= 1) {
        return @"do nothing";
    }
    NSMutableString* selector = [NSMutableString new];
    NSString* instance = [(NSString*)[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""];
    NSMutableArray* params = [NSMutableArray new];
    for (int i=2; i <= array.count-1; i++) {
        NSString* str = [array objectAtIndex:i];
        if (i == array.count-1) {
            str=[str stringByReplacingOccurrencesOfString:@"]" withString:@""];
        }
        NSArray* tmpArray = [str componentsSeparatedByString:@":"];
        if (tmpArray.count <=1) {
            [selector appendFormat:@"%@",tmpArray[0]];
            break;
        }
        [selector appendFormat:@"%@:",tmpArray[0]];
        NSString* tmpPar = tmpArray[1];
        if ([tmpPar hasPrefix:@"@\""]) {
            tmpPar = [tmpPar stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
            tmpPar = [[tmpPar stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
            [params addObject:tmpPar];
        }
        else if ([tmpPar hasPrefix:@"@"]) {
            tmpPar = [tmpPar stringByReplacingOccurrencesOfString:@"@" withString:@""];
            NSNumber* number = [[NSNumber alloc]initWithInt:[tmpPar intValue]];
            [params addObject:number];
        }
        else if([tmpPar isEqualToString:@"YES"])
        {
            NSNumber* number = [[NSNumber alloc]initWithBool:YES];
            [params addObject:number];
        }
        else if([tmpPar isEqualToString:@"NO"])
        {
            NSNumber* number = [[NSNumber alloc]initWithBool:NO];
            [params addObject:number];
        }
        else
        {
            id reOb = [self getObjecFromStr:instance];
            if (selector.length <= 0) {
                // [self sendMessage:[NSString stringWithFormat:@"%@", reOb]];
                return [NSString stringWithFormat:@"%@", reOb];
            }
            return nil;
        }
        
        
    }
    id reOb = [self getObjecFromStr:instance];
    if (selector.length <= 0) {
        // [self sendMessage:[NSString stringWithFormat:@"%@", reOb]];
        return [NSString stringWithFormat:@"%@", reOb];
        // return nil;
    }
    SEL myMethod = NSSelectorFromString(selector);
    NSMethodSignature * sig  = [[reOb class] instanceMethodSignatureForSelector:myMethod];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:reOb];
    [invocatin setSelector:myMethod];
    for (int i=0; i < params.count; i++) {
        NSString* str = params[i];
        [invocatin setArgument:&str atIndex:i+2];
    }
    
    [invocatin invoke];
    
    id retVu = nil;
    [invocatin getReturnValue:&retVu];
    if (retVu != nil) {
        NSString* str = [NSString stringWithFormat:@"%@", retVu];
        // [self sendMessage:str];
        return str;
    }
    
    return nil;
}

+(NSString *)comment
{
    return @"po [id method]";
}

@end
