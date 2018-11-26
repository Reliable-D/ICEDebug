//
//  ICEDebugBaseCommand.h
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject(ICEDebug)
-(NSDictionary*)iceDebugGetAllValuesWithSuber:(int)superLever;
+ (NSArray*) iceDebugAllClassesOfKind:(Class) aClass;
@end

@interface NSArray(ICEDebug)
-(id)iceDebugSafeObjectAtIndex:(NSUInteger)index;
@end

@interface ICEDebugBaseCommand : NSObject
+(NSString*)processCommand:(NSArray*)args;

+ (NSString*)descriptionOfDictionary:(id)object;

+(NSObject*)getObjecFromStr:(NSString*)str;

+(UIViewController*)getRootViewController;

+(NSString*)defaultError;

+(NSString*)comment;

@end
