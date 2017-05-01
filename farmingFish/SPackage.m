//
//  SPackage.m
//  farmingFish
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "SPackage.h"
#import "BeanObject.h"

@implementation SPackage
+(void)reservePackageInfo:(Byte *)bytes StatusBlock:(StatusBlock)block tag:(int)tag{
    
    YYPacket *packet=[[YYPacket alloc] initWithByteArray:bytes];
    
    block(packet);
}

//时间
+(NSData *)buildSocketPackage_time:(int)time deviceId:(NSString *)customerNO methodType:(int)type{
    
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x18];
    if(type==MethodType_GET){
        [packet setFlag:0x01];
        [packet setLength:0x00];
    }else{
        [packet setFlag:0x02];
        [packet setLength:0x03];
        
        Byte* bytes=(Byte *)malloc(3);
        //数据包的内容
        bytes[0]=0xA5;
        bytes[1]=0x5A;
        bytes[2]=time;

        [packet setContents:bytes];
        
    }
    return [packet toNSData];
}
//模式设置
+(NSData *)buildSocketPackage_mode:(int)mode deviceId:(NSString *)customerNO methodType:(int)type{
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x15];
    if(type==MethodType_GET){
        [packet setFlag:0x01];
        [packet setLength:0x00];
    }else{
        [packet setFlag:0x02];
        [packet setLength:0x02];
        
        Byte* bytes=(Byte *)malloc(2);
        //数据包的内容
        bytes[0]=0x05;
        bytes[1]=mode;
        [packet setContents:bytes];
        
    }
    return [packet toNSData];
}
//阈值参数设置
+(NSData *)buildSocketPackage_range:(int)max min:(int)min deviceId:(NSString *)customerNO methodType:(int)type{
    
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x13];
    if(type==MethodType_GET){
        [packet setFlag:0x01];
        [packet setLength:0x00];
    }else{
        [packet setFlag:0x02];
        [packet setLength:0x04];
        
        Byte* bytes=(Byte *)malloc(4);
        //数据包的内容
        bytes[0]=0xAA;
        bytes[1]=0x55;
        bytes[2]=max&0xFF;
        bytes[3]=min&0xFF;
        [packet setContents:bytes];
        
    }
    
    return [packet toNSData];
}

//电机远程控制方式
+(NSData *)buildSocketPackage_ControlMSG:(int)num cmd:(int)cmdStatus deviceId:(NSString *)customerNO{
    
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x10];
    [packet setFlag:0x02];
    [packet setLength:0x02];
    Byte* bytes=(Byte *)malloc(2);
    //数据包的内容
    bytes[0]=num&0xFF;
    bytes[1]=cmdStatus&0xFF;

    [packet setContents:bytes];
    return [packet toNSData];
}

//终端心跳信息
+(NSData *)buildSocketPackage_WATER:(NSString *)customerNO{
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x0002];
    [packet setFlag:0x00];
    [packet setLength:0x00];
    Byte* bytes=(Byte *)malloc(1);
    bytes[0]=0xFF;
    [packet setContents:bytes];
    return [packet toNSData];
    
}

//终端ID注册信息
+(NSData *)buildSocketPackage_mobile_client:(NSString *)customerNO{
    
    YYPacket *packet=[[YYPacket alloc] init];
    
    [packet setDeviceAddress:customerNO];
    
    [packet setCmdword:0x0001];
    [packet setFlag:0x00];
    [packet setLength:0x00];
    
    return [packet toNSData];
}
@end
