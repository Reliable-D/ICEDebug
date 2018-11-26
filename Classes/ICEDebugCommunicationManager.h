//
//  ICEDebugCommunicationManager.h
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* (^ICEDebugResponseBlock)(NSString*);

@protocol ICEDebugCommunicationManagerDelegate <NSObject>

@end

@interface ICEDebugCommunicationManager : NSObject

@property(nonatomic, weak) id<ICEDebugCommunicationManagerDelegate> delegate;

+(instancetype)defaultManager;

-(NSString*)sendCmd:(NSString*)remoteCmd;

@end
