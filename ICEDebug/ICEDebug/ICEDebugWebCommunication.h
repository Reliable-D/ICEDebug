//
//  ICEDebugWebCommunication.h
//  ICEDebug
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ICEWebAsyncSocketManagerDelegate <NSObject>
    
- (NSString*)processWebMessage:(NSString*)message;
    
    @end

@interface ICEDebugWebCommunication : NSObject
    @property (nonatomic, assign) uint16_t port;
    
    @property (nonatomic, weak) id<ICEWebAsyncSocketManagerDelegate> delegate;
    
+ (instancetype)shared;
    
- (BOOL)startServer;
    
- (void)stopServer;
    
- (void)removeAllClients;
@end

NS_ASSUME_NONNULL_END
