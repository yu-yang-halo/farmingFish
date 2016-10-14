//
//  SocketService.m
//  farmingFish
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "SocketService.h"

#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP
#import "SPackage.h"
#import <UIView+Toast.h>

const  uint16_t socket_port= 9101;
const  NSString *socket_ip  = @"183.78.182.98";
static SocketService *instance;
@interface SocketService()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
    BOOL enableListenserBackground;
}
@property (readwrite, nonatomic, copy) StatusBlock mblock;
@property (readwrite, nonatomic, copy) OnlineStatusBlock onlineBlock;
@property(nonatomic,strong) NSString *customerNO;
@property(nonatomic,strong) NSString *tmpCNO;
@end

@implementation SocketService
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[SocketService alloc] init];
    }
    return instance;
}
-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId{
    [asyncSocket writeData:[SPackage buildSocketPackage_ControlMSG:num cmd:cmdval deviceId:devId] withTimeout:-1 tag:1000];
    [asyncSocket readDataWithTimeout:-1 tag:1000];
    
}
-(void)reconnect{
    if(asyncSocket==nil){
        return;
    }
    [self connect:_customerNO];
    NSLog(@"重新连接。。。");
}

-(void)connect:(NSString *)customerNO{
    self.tmpCNO=customerNO;
    [self disconnect];
  // [[[UIApplication sharedApplication] keyWindow] makeToast:@"数据连接中..."];
   dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if(asyncSocket==nil){
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];

    }
    
    if(![asyncSocket isConnected]){
        
        NSLog(@"Connecting to \"%@\" on port %hu...", socket_ip, socket_port);
        
        NSError *error = nil;
        if (![asyncSocket connectToHost:socket_ip onPort:socket_port error:&error])
        {
            NSLog(@"Error connecting: %@", error);
        }
    }


}

-(void)disconnect{
    if(asyncSocket!=nil&&asyncSocket.isConnected){
        [asyncSocket disconnect];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%@ didConnectToHost:%@ port:%hu", sock, host, port);
    
    self.customerNO=_tmpCNO;
     _onlineBlock(YES,_customerNO);
    
    [asyncSocket writeData:[SPackage buildSocketPackage_mobile_client:_customerNO] withTimeout:-1 tag:3];
    [asyncSocket readDataWithTimeout:-1 tag:3];
    
    
    [self keepLive];
    
}


-(void)keepLive{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(asyncSocket!=nil&&asyncSocket.isConnected){
            NSLog(@"保持心跳....");
            [asyncSocket writeData:[SPackage buildSocketPackage_WATER:_customerNO]withTimeout:-1 tag:2];
            [asyncSocket readDataWithTimeout:-1 tag:2];
            
            [asyncSocket writeData:[SPackage buildSocketPackage_mobile_client:_customerNO] withTimeout:-1 tag:3];
            [asyncSocket readDataWithTimeout:-1 tag:3];
            
            [NSThread sleepForTimeInterval:15];
            
        }
    });
    
   
}


- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure:%p", sock);
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
  
    //NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld %@", sock, tag,data);
    if(_mblock!=nil){
        [SPackage reservePackageInfo:data StatusBlock:_mblock];
    }
    
}
-(void)setStatusBlock:(StatusBlock)block{
    self.mblock=block;
}

-(void)setOnlineStatusBlock:(OnlineStatusBlock)block{
    self.onlineBlock=block;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
     NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    if(err!=nil){
        [[[UIApplication sharedApplication] keyWindow] makeToast:@"连接已断开"];
    }
    
    _onlineBlock(NO,_customerNO);
   
}

- (void)applicationWillResignActive:(UIApplication *)application{
    if(enableListenserBackground){
        [self disconnect];
        NSLog(@"断开连接。。。");
    }
  
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    if(enableListenserBackground){
        [self reconnect];
    }

   
    
}
-(void)enableListenser:(BOOL)isEnable{
    enableListenserBackground=isEnable;
}
@end
