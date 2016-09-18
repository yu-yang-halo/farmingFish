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
    
    NSData *data=[self dataPackage];

    [sock writeData:data withTimeout:3 tag:1];
    
    [self keepLive];
    
}
-(NSData *)dataPackage{
    Byte req[25]={0};
    req[0]="*";
    req[1]="T";
    req[2]="Z";
    req[3]=3;//version
    
    //    //水产
    //    req[4]=0x00;
    //    req[5]=0xFE;
    //
    //    //蔬菜大棚
    //    req[4]=0x00;
    //    req[5]=0x02;
    //
    //    //畜牧
    //    req[4]=0x00;
    //    req[5]=0x03;
    //
    //Android设备
    req[4]=0x00;
    req[5]=0xFE;
    NSString *customerNO=@"00-00-05-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        NSLog(@"result %d",result);
        req[5+(++index)]=result;
        
    }
    //命令流水号
    for(int i=0;i<8;i++){
        req[10+i]=0x00;
    }
    
    //命令操作字
    req[18]=0x00;
    req[19]=0x01;
    
    //命令操作符
    req[20]=0x00;
    //数据包长度
    req[21]=0x00;
    req[22]=0x00;
    
    int val=(req[21]<<8)+req[22];
    NSLog(@"val %d",val);
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]="#";
    NSData *data=[[NSData alloc] initWithBytes:req length:(25+val)];
    
    return data;
}

-(NSData *)dataPackage2{
    Byte req[25]={0};

    req[0]="*";
    req[1]="T";
    req[2]="Z";
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=0xFE;
    NSString *customerNO=@"00-00-05-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        NSLog(@"result %d",result);
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=0x12;
    req[11]=0x78;
    req[12]=0xA0;
    req[13]=0x9C;
    req[14]=0x00;
    req[15]=0x00;
    req[16]=0x00;
    req[17]=0x00;
    //命令操作字
    req[18]=0x00;
    req[19]=0x02;
    
    //命令操作符
    req[20]=0x00;
    
    //数据包长度
    req[21]=0x00;
    req[22]=0x00;
    
    int val=(req[21]<<8)+req[22];
    NSLog(@"val %d",val);
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]="#";
    
    NSData *data=[[NSData alloc] initWithBytes:req length:(25+val)];
    
    return data;

}


-(void)keepLive{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(asyncSocket.isConnected){
            
            NSData *data=[self dataPackage];
            NSData *data2=[self dataPackage2];
            
            [asyncSocket writeData:data2 withTimeout:3 tag:2];
            [asyncSocket writeData:data withTimeout:3 tag:3];
            
            [NSThread sleepForTimeInterval:15];
            
            NSLog(@"....keep live");
            
        }
    });
    
   
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
