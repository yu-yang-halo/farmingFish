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

const  uint16_t socket_port= 9101;
const  NSString *socket_ip  = @"183.78.182.98";
static SocketService *instance;
@interface SocketService()<GCDAsyncSocketDelegate>
{
    
}
@end
@implementation SocketService
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[SocketService alloc] init];
    }
    return instance;
}

-(void)connect{
   dispatch_queue_t mainQueue = dispatch_get_main_queue();
   GCDAsyncSocket *asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];


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
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);

    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure:%p", sock);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}



@end
