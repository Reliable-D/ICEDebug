//
//  ICEDebugCommunication.m
//  ICEDebug
//
//  Created by wujianrong on 2018/7/26.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugCommunication.h"
#import <GCDAsyncSocket.h>

@interface ICEDebugCommunication ()<GCDAsyncSocketDelegate>

@property (strong,nonatomic) NSMutableArray *clientSocket;

@property (strong,nonatomic) GCDAsyncSocket *socketServer;

@end

@implementation ICEDebugCommunication

static ICEDebugCommunication* __instance = nil;

-(NSMutableArray *)clientSocket{
    if (_clientSocket == nil) {
        _clientSocket = [NSMutableArray array];
    }
    return _clientSocket;
}

- (GCDAsyncSocket *)socketServer {
    if (!_socketServer) {
        _socketServer = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socketServer;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ICEDebugCommunication alloc] init];
        __instance.port = 10086;
    });
    return __instance;
}


#pragma mark- Action
- (BOOL)startServer {
    [self.socketServer setDelegate:self];
    
    NSError *error = nil;
    [self.socketServer acceptOnPort:self.port error:&error];
    
    if (!error) {
        return YES;
    }else{
        return NO;
    }
}

- (void)stopServer {
    [self removeAllClients];
    [self.socketServer setDelegate:nil];
    self.socketServer = nil;
}

- (void)removeAllClients {
    
    if (self.clientSocket.count < 1) {
        return;
    }
    
    [self.clientSocket enumerateObjectsUsingBlock:^(GCDAsyncSocket* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setDelegate:nil];
        [obj disconnect];
    }];
    
    [self.clientSocket removeAllObjects];
}

#pragma mark- GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    [self.clientSocket addObject:newSocket];
    
    [newSocket readDataWithTimeout:-1 tag:100];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // 把回车和换行字符去掉  \r 回车 \n 换行
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //判断指令
    if ([receiverStr isEqualToString:@"quit"]) {
        [self.clientSocket removeObject:sock];
        [sock setDelegate:nil];
        [sock disconnect];
        return;
    }
    
    NSString* logMsg = @"";
    if ([self.delegate respondsToSelector:@selector(processMessage:)]) {
        logMsg = [self.delegate processMessage:receiverStr];
    }
    [sock writeData:[[NSString stringWithFormat:@"******\n[you]: %@\n",receiverStr] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [sock writeData:[[NSString stringWithFormat:@"\n[phone]:\n%@\n***********\n\n",logMsg] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark- dealloc
- (void)dealloc {
    [self stopServer];
    self.clientSocket = nil;
}
@end
