//
//  ICEDebugCommunication.h
//  ICEDebug
//
//  Created by wujianrong on 2018/7/26.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICEAsyncSocketManagerDelegate <NSObject>

- (NSString*)processMessage:(NSString*)message;

@end

@interface ICEDebugCommunication : NSObject
@property (nonatomic, assign) uint16_t port;

@property (nonatomic, weak) id<ICEAsyncSocketManagerDelegate> delegate;

+ (instancetype)shared;

- (BOOL)startServer;

- (void)stopServer;

- (void)removeAllClients;
@end
