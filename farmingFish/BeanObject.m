//
//  BeanObject.m
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "BeanObject.h"

@implementation BeanObject

@end

@implementation YYCollectorInfo
-(instancetype)init{
    self=[super init];
    if(self){
        self.upperValue=-1;
        self.lowerValue=-1;
        self.time=-1;
        
        self.upperValueChange=-1;
        self.lowerValueChange=-1;
        self.timeChange=-1;

        
        
        
    }
    return self;
}
-(void)setUpperValue:(int)upperValue{
    _upperValue=upperValue;
    _upperValueChange=upperValue;
}
-(void)setLowerValue:(int)lowerValue{
    _lowerValue=lowerValue;
    _lowerValueChange=lowerValue;
}

@end

@implementation YYNews

@end

@implementation YYHistoryData


@end

@implementation HistoryWantData

@end

@implementation YYVideoInfo

@end
@implementation YYUserInfo


@end
@implementation YYCollectorSensor

-(void)setF_Lower:(NSNumber *)F_Lower{
    _F_Lower=F_Lower;
    _F_LowerChange=F_Lower;
}
-(void)setF_Upper:(NSNumber *)F_Upper{
    _F_Upper=F_Upper;
    _F_UpperChange=F_Upper;
}

@end




@implementation YYPacket

-(instancetype)initWithByteArray:(Byte *)bytes{
    self=[super init];
    if(self){
        NSLog(@"序号[0]帧头%02x",bytes[0]);
        self.frameHeader=bytes[0];
        NSLog(@"序号[1-2]厂家信息%02x%02x",bytes[1],bytes[2]);
        self.productInfo=(bytes[1]<<8)|(bytes[2]&0xFF);
        NSLog(@"序号[3]版本号%02x",bytes[3]);
        self.version=bytes[3];
        NSLog(@"序号[4-5]设备类型%02x%02x",bytes[4],bytes[5]);
        self.deviceType=(bytes[4]<<8)|(bytes[5]&0xFF);
        
        NSString *customNo=[NSString stringWithFormat:@"%02x-%02x-%02x-%02x",bytes[6],bytes[7],bytes[8],bytes[9]];
        
        NSLog(@"序号[6-9]设备地址%02x%02x%02x%02x  customNO:%@",bytes[6],bytes[7],bytes[8],bytes[9],customNo);
        self.deviceAddress=customNo;
        
        
        NSLog(@"序号[10-17]命令流水号%02x%02x%02x%02x%02x%02x%02x%02x",bytes[10],bytes[11],bytes[12],bytes[13],bytes[14],bytes[15],bytes[16],bytes[17]);
        
        Byte* tmp=(Byte*)malloc(8);
        memcpy(tmp,bytes+10,8);
        self.cmdSerialNumber=tmp;
        self.cmdword=(bytes[18]<<8)|(bytes[19]&0xFF);
        NSLog(@"序号[18-19]操作命令字%02x%02x -- %d",bytes[18],bytes[19],_cmdword);
        self.flag=bytes[20];
         NSLog(@"序号[20]操作标志%02x",bytes[20]);
        self.length=(bytes[21]<<8)|(bytes[22]&0xFF);
        NSLog(@"序号[21-22]数据包长度%02x%02x  len:%d",bytes[21],bytes[22],_length);

        Byte* tmp2 = (Byte*)malloc(_length);
        memcpy(tmp2,bytes+23,_length);
        self.contents=tmp2;
        
        NSLog(@"内容：：：%@",[NSData dataWithBytes:tmp2 length:_length]);
        self.checkCode=(bytes[23+_length]<<8)|(bytes[24+_length]&0xFF);
        self.frameFooter=bytes[25+_length];
        NSLog(@"序号[%d-%d]校验和%02x %02x---%d",_length+23,_length+24,bytes[_length+23],bytes[_length+24],_checkCode);
        NSLog(@"序号[%d]帧尾%02x",_length+25,_frameFooter);
        
    }
    return self;
}
-(NSData *)toNSData{
    
    Byte* req=malloc(26+_length);
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=3;
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    
    NSArray *arr=[_deviceAddress componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    
    
    
    
    //命令操作字
    req[18]=(_cmdword>>8)&0xFF;
    req[19]=(_cmdword)&0xFF;
    
    //命令流水号 暂时无使用
    
    Byte serias[8]={0x12,0x78,0xA0,0x9C,0x00,0x00,0x00,0x00};
    
    if(_cmdword==0x10){
        for(int i=0;i<8;i++){
            req[10+i]=serias[i];
        }
    }else{
        for(int i=0;i<8;i++){
            req[10+i]=0xFF;
        }
    }
    
    
    /*
     命令操作符
     0x00终端主动上报，数据长度N不需应答；
     0x01查询操作，数据长度0（无数据）
     0x02设置操作，数据长度N;
     0x81应答查询，数据长度N。
     0x82应答设置，数据长度0（无数据）。
     AA 55 X Y
     */
    //命令操作符
    req[20]=_flag;
    
    //数据包长度
    req[21]=(_length>>8)&0xFF;
    req[22]=(_length)&0xFF;
   
    if(_length>0){
        memcpy(req+23,_contents,_length);
    }
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+_length;i++){
        sum+=req[i]&0xFF;
        
    }
    req[23+_length]=(sum>>8)&0xFF;
    req[24+_length]=sum&0xFF;
    
    req[25+_length]='#';
    
    return [[NSData alloc] initWithBytes:req length:(26+_length)];
}

-(NSDictionary *)dict{
    switch (_cmdword) {
        case 0x03:
            if(_length==45){
                self.dict=[self resolveStatusData:_contents];
            }
            break;
        case 0x0F:
            if(_length==16){
                 self.dict=[self resolveSwitchData:_contents];
            }
            break;
        case 0x13:
            if(_length==4){
                 self.dict=[self resolveRangeData:_contents];
            }
            break;
        case 0x15:
            if(_length==2){
                 self.dict=[self resolveModeData:_contents];
            }
            break;
        case 0x18:
            if(_length==3){
                 self.dict=[self resolveTimeData:_contents];
            }

            break;
    }
    return _dict;
}


-(NSDictionary *)resolveStatusData:(Byte *)status{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    int i=0;
    while (i<40) {
        unsigned char pmem[]={status[i+4],status[i+3],status[i+2],status[i+1]};
        
        float *p=(float *)pmem;
        if(*p<=0){
            i=i+5;
            continue;
        }
        
        switch(status[i]){
            case 0x01://溶氧
                // NSLog(@"溶氧 %f",*p); 属性名 当前值 最大值 单位
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|0",@"溶氧",*p,20.0,@"mg/L"] forKey:@(status[i])];
                
                break;
            case 0x02://溶氧饱和度
                // NSLog(@"溶氧饱和度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|6",@"溶氧饱和度",*p,1.0,@"%"] forKey:@(status[i])];
                break;
            case 0x03://PH
                //NSLog(@"PH %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|2",@"PH",*p,14.0,@""] forKey:@(status[i])];
                break;
            case 0x04://氨氮
                //NSLog(@"氨氮 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|3",@"氨氮",*p,1.0,@"mg/L"] forKey:@(status[i])];
                break;
            case 0x05://温度
                //NSLog(@"温度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|1",@"水温",*p,50.0,@"℃"] forKey:@(status[i])];
                break;
            case 0x06://亚硝酸盐
                //NSLog(@"亚硝酸盐 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|4",@"亚硝酸盐",*p,1.0,@"mg/L"] forKey:@(status[i])];
                break;
            case 0x07://液位
                //NSLog(@"液位 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"液位",*p] forKey:@(status[i])];
                break;
            case 0x08://硫化氢
                //NSLog(@"硫化氢 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"硫化氢",*p] forKey:@(status[i])];
                break;
            case 0x09://浊度
                // NSLog(@"浊度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f|%f|%@|5",@"浊度",*p,1.0,@""] forKey:@(status[i])];
                break;
            case 0x0a://盐度
                //NSLog(@"盐度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"盐度",*p] forKey:@(status[i])];
                break;
            case 0x0b://电导率
                // NSLog(@"电导率 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"电导率",*p] forKey:@(status[i])];
                break;
            case 0x0c://化学需量
                NSLog(@"化学需量%f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"化学需量",*p] forKey:@(status[i])];
                break;
            case 0x0d://大气压
                NSLog(@"大气压 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"大气压",*p] forKey:@(status[i])];
                break;
            case 0x0e://风速
                NSLog(@"风速 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"风速",*p] forKey:@(status[i])];
                break;
            case 0x0f://风向
                NSLog(@"风向 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"风向",*p] forKey:@(status[i])];
                break;
            case 0x10://叶绿素
                NSLog(@"叶绿素 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"叶绿素",*p] forKey:@(status[i])];
                break;
            case 0x11://大气温度
                NSLog(@"大气温度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"大气温度",*p] forKey:@(status[i])];
                break;
            case 0x12://大气湿度
                NSLog(@"大气湿度 %f",*p);
                [dic setObject:[NSString stringWithFormat:@"%@|%f",@"大气湿度",*p] forKey:@(status[i])];
                break;
                
        }
        
        i=i+5;
    }
    Byte realData2[4]={0};
    if(status[40]==0x1e){
        memcpy(realData2,status+41,4);
        NSString *devOnOffStatus=[self resolveDeviceStatus:realData2];
        [dic setObject:devOnOffStatus forKey:@"status"];
        
    }
    [dic setObject:_deviceAddress forKey:@"customNo"];
    return dic;
}
-(NSDictionary *)resolveSwitchData:(Byte *)status{
    NSMutableString *st=[NSMutableString new];
    for (int i=1;i<16;i=i+2) {
        
        [st appendString:[NSString stringWithFormat:@"%d",status[i]]];
        
    }
    NSLog(@"电机状态 %@",st);
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:st forKey:@"status"];
    [dic setObject:_deviceAddress forKey:@"customNo"];
    return dic;
}

-(NSDictionary *)resolveRangeData:(Byte *)status{
    NSMutableString *st=[NSMutableString new];
    
    int max=status[2];
    int min=status[3];
    
    NSLog(@"max %d  min %d",max,min);
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:[NSNumber numberWithInt:max] forKey:@"max"];
    [dic setObject:[NSNumber numberWithInt:min] forKey:@"min"];
    return dic;
}
-(NSDictionary *)resolveModeData:(Byte *)status{
    NSLog(@"mode %d",status[1]);
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:[NSNumber numberWithInt:status[1]] forKey:@"mode"];
    
    return dic;
}
-(NSDictionary *)resolveTimeData:(Byte *)status{
    NSLog(@"time %d",status[2]);
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:[NSNumber numberWithInt:status[2]] forKey:@"time"];
    
    return dic;
}

-(NSString *)resolveDeviceStatus:(Byte *)devstatus{
    NSMutableString *st=[NSMutableString new];
    for (int i=0;i<4;i++) {
        
        [st appendString:[NSString stringWithFormat:@"%02x",devstatus[i]]];
        
    }
    NSLog(@"电机状态 %@",st);
    return st;
}

@end
