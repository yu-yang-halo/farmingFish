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

const  uint16_t socket_port= 9101;
const  NSString *socket_ip  = @"183.78.182.98";
static SocketService *instance;
@interface SocketService()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
}

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
-(void)connect{
   dispatch_queue_t mainQueue = dispatch_get_main_queue();
   asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];


    NSLog(@"Connecting to \"%@\" on port %hu...", socket_ip, socket_port);
    
    NSError *error = nil;
    if (![asyncSocket connectToHost:socket_ip onPort:socket_port error:&error])
    {
        NSLog(@"Error connecting: %@", error);
    }
    
    

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%@ didConnectToHost:%@ port:%hu", sock, host, port);
    

    
    [sock writeData:[SPackage buildSocketPackage_mobile_client] withTimeout:-1 tag:0];
 
    [sock readDataWithTimeout:-1 tag:0];
    
    [self keepLive];
    
}


-(void)keepLive{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(asyncSocket.isConnected){
           
            [asyncSocket writeData:[SPackage buildSocketPackage_WATER]withTimeout:-1 tag:2];
            [asyncSocket readDataWithTimeout:-1 tag:2];
            
            [asyncSocket writeData:[SPackage buildSocketPackage_mobile_client] withTimeout:-1 tag:3];
            [asyncSocket readDataWithTimeout:-1 tag:3];
            
            [NSThread sleepForTimeInterval:15];
            
            NSLog(@"....keep live tag[1,3] [2]");
            
        }
    });
    
   
}


- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure:%p", sock);
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
   
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld %@", sock, tag,data);
    
    [SPackage reservePackageInfo:data];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}



@end
