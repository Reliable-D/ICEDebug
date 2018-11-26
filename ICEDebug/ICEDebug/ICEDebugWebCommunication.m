
//
//  ICEDebugWebCommunication.m
//  ICEDebug
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugWebCommunication.h"
#import <GCDAsyncSocket.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "ICEDebugMacro.h"
#import "ICEDebugBaseCommand.h"
#import "ICEDebugscreeninfo.h"

@interface ICEDebugWebCommunication ()<GCDAsyncSocketDelegate>
    
    @property (strong,nonatomic) NSMutableArray *clientSocket;
    
    @property (strong,nonatomic) GCDAsyncSocket *socketServer;
    
    @end

@implementation ICEDebugWebCommunication
    
    static ICEDebugWebCommunication* __web_instance = nil;
    
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
        __web_instance = [[ICEDebugWebCommunication alloc] init];
        __web_instance.port = 10087;
    });
    return __web_instance;
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
    
    -(NSString*)getImageKey:(NSString*)url
    {
        NSArray* set = [url componentsSeparatedByString:@" "];
        NSString* resource = [set iceDebugSafeObjectAtIndex:1];
        if (resource.length <= 0) {
            return nil;
        }
        if ([resource containsString:@"png"] == NO) {
            return nil;
        }
        resource = [resource stringByReplacingOccurrencesOfString:@"/" withString:@""];
        resource = [resource stringByReplacingOccurrencesOfString:@".png" withString:@""];
        return resource;
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
    
    NSString* imageKey = [self getImageKey:receiverStr];
    if (imageKey.length > 0) {
        UIImage* image = [ICEDebugscreeninfo getImageWithKey:imageKey];
        if (image != nil) {
            NSData* data = UIImagePNGRepresentation(image);
            if (data.length > 0) {
                NSMutableData* tmpData = [NSMutableData new];
                /*
                 Content-Type: image/png
                 Content-Length: 19256
                 */
                NSString* header = [NSString  stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: image/png\nContent-Length: %lu\n\r\n", (unsigned long)data.length];
                [tmpData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
                [tmpData appendData:data];
                [sock writeData:tmpData withTimeout:-1 tag:0];
                
            }
        }
        [sock disconnect];
        return;
    }
    
    NSString* logMsg = @"";
    if ([self.delegate respondsToSelector:@selector(processWebMessage:)]) {
        logMsg = [self.delegate processWebMessage:receiverStr];
    }
    
    static int i=0;
    i++;
    [sock writeData:[[NSString stringWithFormat:@"HTTP/1.1 200 OK\r\n\r\n%@\r\n", logMsg] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];

    [sock disconnect];
    [self startServer];
}
   
    -(UIImage*)getImageFromView:(UIView*)view
    {
        UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return image;
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
