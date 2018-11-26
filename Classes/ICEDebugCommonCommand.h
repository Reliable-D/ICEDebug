//
//  ICEDebugCommonCommand.h
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEDebugCommonCommand : NSObject
+(BOOL)containSimpleCommand:(NSString*)command;

+(NSArray*)getAllCommand;
@end
