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
#import "UIView+Toast.h"

const  uint16_t socket_port= 9101;
const  NSString *socket_ip  = @"183.78.182.98";
static SocketService *instance;
@interface SocketService()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
    BOOL enableListenserBackground;
    BOOL systemForceDisconnectYN;//区分系统导致的断开
}
@property (readwrite, nonatomic, copy) StatusBlock mblock;
@property (readwrite, nonatomic, copy) OnlineStatusBlock onlineBlock;
@property(nonatomic,strong) NSString *DeviceId;
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
    [asyncSocket writeData:[SPackage buildSocketPackage_ControlMSG:num cmd:cmdval deviceId:devId] withTimeout:-1 tag:SOCKET_TAG_SET_STATUS];
    [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_SET_STATUS];
}

-(void)autoStartTime:(int)methodType time:(int)time devId:(NSString *)devId{
    
    if(methodType==MethodType_GET){
        
        [asyncSocket writeData:[SPackage buildSocketPackage_time:time deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS];
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS];
        
    }else{
        [asyncSocket writeData:[SPackage buildSocketPackage_time:time deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_SET_THRESHOLDS];
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_SET_THRESHOLDS];
        
    }
}

-(void)modeSwith:(int)methodType mode:(int)modeType devId:(NSString *)devId{
    if(methodType==MethodType_GET){
        
        [asyncSocket writeData:[SPackage buildSocketPackage_mode:modeType deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS] ;
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS];
        
    }else{
        [asyncSocket writeData:[SPackage buildSocketPackage_mode:modeType deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS] ;
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_SET_THRESHOLDS];
        
    }
}

-(void)rangSetOrGet:(int)methodType max:(int)max min:(int)min devId:(NSString *)devId{
    if(methodType==MethodType_GET){
        
        [asyncSocket writeData:[SPackage buildSocketPackage_range:max min:min deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS] ;
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_GET_THRESHOLDS];
        
    }else{
        [asyncSocket writeData:[SPackage buildSocketPackage_range:max min:min deviceId:devId methodType:methodType] withTimeout:-1 tag:SOCKET_TAG_SET_THRESHOLDS];
        [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_SET_THRESHOLDS];

    }
}


-(void)reconnect{
    if(asyncSocket==nil){
        return;
    }
    if(_DeviceId==nil){
        return;
    }
    [self connect:_DeviceId];
    NSLog(@"重新连接。。。");
}
-(void)disconnect{
    systemForceDisconnectYN=NO;
    if(asyncSocket!=nil&&asyncSocket.isConnected){
        [asyncSocket disconnect];
        
    }
    asyncSocket=nil;
}
-(void)disconnectAndClear{
    systemForceDisconnectYN=NO;
    if(asyncSocket!=nil&&asyncSocket.isConnected){
        [asyncSocket disconnect];
        
    }
    asyncSocket=nil;
}


-(void)connect:(NSString *)DeviceId{
    if(asyncSocket!=nil&&asyncSocket.isConnected){
        [asyncSocket disconnect];
    }
    [self disconnect];
    self.DeviceId=DeviceId;
    systemForceDisconnectYN=YES;
  // [[[UIApplication sharedApplication] keyWindow] makeToast:@"数据连接中..."];
   dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if(asyncSocket==nil){
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
    }
    
    if(![asyncSocket isConnected]){
        
        NSLog(@"Connecting to \"%@\" on port %hu...", socket_ip, socket_port);
        
        NSError *error = nil;
        
        if (![asyncSocket connectToHost:socket_ip
                                 onPort:socket_port
                            withTimeout:6
                                  error:&error])
        {
            NSLog(@"Error connecting: %@", error);
        }
    }


}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%@ didConnectToHost:%@ port:%hu", sock, host, port);
    
    if(_onlineBlock!=nil){
        _onlineBlock(YES,_DeviceId);
    }
    
    
//    
//    [asyncSocket writeData:[SPackage buildSocketPackage_mobile_client:_DeviceId] withTimeout:-1 tag:SOCKET_TAG_CLIENT_REGISTER];
//    [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_CLIENT_REGISTER];
    
    
    [asyncSocket writeData:[SPackage buildSocketPackage_WATER:_DeviceId] withTimeout:-1 tag:SOCKET_TAG_GET_STATUS];
    [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_GET_STATUS];

    [self keepLive];
    
    
    [self rangSetOrGet:MethodType_GET max:-1 min:-1 devId:_DeviceId];
    
    [self modeSwith:MethodType_GET mode:0 devId:_DeviceId];
    
    [self autoStartTime:MethodType_GET time:0 devId:_DeviceId];
    
    
    

}


-(void)keepLive{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(asyncSocket!=nil&&asyncSocket.isConnected){
            NSLog(@"保持心跳....");
            
            [asyncSocket writeData:[SPackage buildSocketPackage_WATER:_DeviceId]withTimeout:-1 tag:SOCKET_TAG_GET_STATUS];
            [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_GET_STATUS];
//            
//            [asyncSocket writeData:[SPackage buildSocketPackage_mobile_client:_DeviceId] withTimeout:-1 tag:SOCKET_TAG_CLIENT_REGISTER];
//            [asyncSocket readDataWithTimeout:-1 tag:SOCKET_TAG_CLIENT_REGISTER];
//           
            
            
            [NSThread sleepForTimeInterval:6];
            
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
        
        int totalLength=data.length;
        
        int pos=0;
        while (pos!=totalLength) {
            
            if(pos>totalLength){
                NSLog(@"读取超过包长 pos %d totalLength %d",pos,totalLength);
                break;
            }
            
         
            Byte* len = (Byte*)malloc(2);
            
            [data getBytes:len range:NSMakeRange(pos+21, 2)];
            NSLog(@"%02x %02x",len[0],len[1]);
            
            
            int plen=(len[0]<<8)|(len[1]&0xFF);
            
            Byte* packet=(Byte*)malloc(26+plen);
            
            
            [data getBytes:packet range:NSMakeRange(pos, 26+plen)];
            
            NSLog(@"pos %d 读取了一个完整包 内容长度：%d %@",pos,plen,[NSData dataWithBytes:packet length:26+plen]);
            
        
            
            [SPackage reservePackageInfo:packet StatusBlock:_mblock tag:tag];
            
            pos=pos+26+plen;
            
        }
        
        
        
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
       
        
        if(systemForceDisconnectYN&&_DeviceId!=nil){
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"重连中..."];
            [self reconnect];
        }else{
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"连接已断开"];
        }
    }
    if(_onlineBlock!=nil){
         _onlineBlock(NO,_DeviceId);
    }
   
   
}

- (void)applicationWillResignActive:(UIApplication *)application{
    if(enableListenserBackground){
        [self disconnect];
        //NSLog(@"断开连接。。。");
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
