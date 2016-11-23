//
//  SPackage.m
//  farmingFish
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "SPackage.h"

@implementation SPackage
+(void)reservePackageInfo:(NSData *)data StatusBlock:(StatusBlock)block tag:(int)tag{
    Byte* bytes=[data bytes];
    NSLog(@"package length %ld", data.length);
    
    
    NSLog(@"序号[0]帧头%02x",bytes[0]);
    NSLog(@"序号[1-2]厂家信息%02x%02x",bytes[1],bytes[2]);
    NSLog(@"序号[3]版本号%02x",bytes[3]);
    NSLog(@"序号[4-5]设备类型%02x%02x",bytes[4],bytes[5]);
    NSString *customNo=[NSString stringWithFormat:@"%02x-%02x-%02x-%02x",bytes[6],bytes[7],bytes[8],bytes[9]];

    NSLog(@"序号[6-9]设备地址%02x%02x%02x%02x  customNO:%@",bytes[6],bytes[7],bytes[8],bytes[9],customNo);
    
    NSLog(@"序号[10-17]命令流水号%02x%02x%02x%02x%02x%02x%02x%02x",bytes[10],bytes[11],bytes[12],bytes[13],bytes[14],bytes[15],bytes[16],bytes[17]);
    //0003 3--内容  19--设置信息  15--电机控制状态
    NSLog(@"序号[18-19]操作命令字%02x%02x",bytes[18],bytes[19]);
    
    int controlCMD=(bytes[18]<<8)+bytes[19];
    
    NSLog(@"序号[20]操作标志%02x",bytes[20]);
    int len=(bytes[21]<<8)+bytes[22];
    NSLog(@"序号[21-22]数据包长度%02x%02x  len:%d",bytes[21],bytes[22],len);
    
    if(controlCMD==3){
        if(len>0){
            //[23--23+40) 实时基本数据
            //[23+40]==0x1e  [23+41--23+44] 2byte 8bit 设备状态1开0关
            NSLog(@"具体数据------------start [%d-%d]",23,22+len);
            for(int i=0;i<len;i++){
                NSLog(@"序号[%d]%02x",i+23,bytes[i+23]);
            }
            Byte realData[45]={0};
            
            if(len==45){
                //tag
                if (tag==SOCKET_TAG_GET_PARAMETERS||tag==SOCKET_TAG_SET_PARAMETERS) {
                    memcpy(realData,bytes+23,45);
                    [self resolveParametersData:realData StatusBlock:block customNo:customNo];
                }else if(tag==SOCKET_TAG_GET_STATUS||tag==SOCKET_TAG_SET_STATUS){
                    memcpy(realData,bytes+23,45);
                    [self resolveStatusData:realData StatusBlock:block customNo:customNo];
                }
                
            }
            NSLog(@"具体数据------------end");
        }else{
            NSLog(@"没有具体数据");
        }
    }else if(controlCMD==15){
        if(len>0){
             //[23--23+16) 开闭状态
            NSLog(@"具体数据------------start [%d-%d]",23,22+len);
            for(int i=0;i<len;i++){
                NSLog(@"序号[%d]%02x",i+23,bytes[i+23]);
            }
            Byte statusData[16]={0};
            if(len==16){
                //01 01 02 00 03 00 ...
                //转化为10000000
                memcpy(statusData,bytes+23,16);
                [self resolveSwitchData:statusData StatusBlock:block customNo:customNo];
                
            }
        }
    }
    
    
   
    NSLog(@"序号[%d-%d]校验和%02x%02x",len+23,len+24,bytes[len+23],bytes[len+24]);
    NSLog(@"序号[%d]帧尾%02x",len+25,bytes[len+25]);
}
+(NSString *)resolveDeviceStatus:(Byte *)devstatus{
    NSMutableString *st=[NSMutableString new];
    for (int i=0;i<4;i++) {
        
        [st appendString:[NSString stringWithFormat:@"%02x",devstatus[i]]];
        
    }
    NSLog(@"电机状态 %@",st);
    return st;
}

+(void)resolveSwitchData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo{
    NSMutableString *st=[NSMutableString new];
    for (int i=1;i<16;i=i+2) {
        
        [st appendString:[NSString stringWithFormat:@"%d",status[i]]];
        
    }
    NSLog(@"电机状态 %@",st);
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:st forKey:@"status"];
    [dic setObject:customNo forKey:@"customNo"];
    block(dic);
}

+(void)resolveParametersData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    int i=0;
    
    while (i<45) {
        float pMin=((status[i+1]<<8)+status[i+2])/10.0;
        float pMax=((status[i+3]<<8)+status[i+4])/10.0;
       
        NSLog(@"max:%.1f min:%.1f  type %d",pMax,pMin,status[i]);
        
        [dic setObject:[NSString stringWithFormat:@"%d,%.1f,%.1f",status[i],pMin,pMax] forKey:@(status[i])];
//        
//        switch(status[i]){
//            case 0x01://溶氧
//                
//                break;
//            case 0x02://溶氧饱和度
//               
//                break;
//            case 0x03://PH
//               
//                break;
//            case 0x04://氨氮
//                
//                break;
//            case 0x05://温度
//                
//                break;
//            case 0x06://亚硝酸盐
//               
//                break;
//            case 0x07://液位
//               
//                break;
//            case 0x08://硫化氢
//               
//                break;
//            case 0x09://浊度
//                
//                break;
//            case 0x0a://盐度
//                
//                break;
//            case 0x0b://电导率
//               
//                break;
//            case 0x0c://化学需量
//               
//                break;
//            case 0x0d://大气压
//                
//                break;
//            case 0x0e://风速
//                
//                break;
//            case 0x0f://风向
//                
//                break;
//            case 0x10://叶绿素
//                
//                break;
//            case 0x11://大气温度
//               
//                break;
//            case 0x12://大气湿度
//               
//                break;
//                
//        }
        
        i=i+5;
    }

    [dic setObject:customNo forKey:@"customNo"];
     block(dic);
    
}

+(void)resolveStatusData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo {
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
    [dic setObject:customNo forKey:@"customNo"];
    block(dic);
}

//区间参数设置
//
+(NSData *)buildSocketPackage_ParametersMSG{
    
    /*
     * 模拟构建设置参数
     *      min最小值     max最大值
     * 0x01 0x00 0x02    0x00 0x09
     */
    NSArray *needConfigParameters=@[@"1,1.2,4.5",@"3,6.0,9.2",@"4,1.5,4.5"];
    
    
    
    Byte req[45]={0};
    
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=(Byte)0xFF;
    req[11]=(Byte)0xFF;
    req[12]=(Byte)0xFF;
    req[13]=(Byte)0xFF;
    req[14]=(Byte)0xFF;
    req[15]=(Byte)0xFF;
    req[16]=(Byte)0xFF;
    req[17]=(Byte)0xFF;
    //命令操作字
    req[18]=0x00;
    req[19]=0x04;
    /*
     命令操作符
     0x00终端主动上报，数据长度N不需应答；
     0x01查询操作，数据长度0（无数据）
     0x02设置操作，数据长度N;
     0x81应答查询，数据长度N。
     0x82应答设置，数据长度0（无数据）。
     */
    req[20]=0x02;
    
    //数据包长度
    req[21]=0x00;
    req[22]=[needConfigParameters count]*5;
    
    //数据包的内容
    
    int k=0;
    for (NSString *item in needConfigParameters) {
        NSArray *arrs=[item componentsSeparatedByString:@","];
        if([arrs count]==3){
           
            req[23+k]=[arrs[0] intValue];
            
            int min=[arrs[1] floatValue]*10;
            int max=[arrs[2] floatValue]*10;
            
            req[23+k+1]=(min>>8&0xFF);
            req[23+k+2]=(min&0x00FF);
            
            req[23+k+3]=(max>>8&0xFF);
            req[23+k+4]=(max&0x00FF);
        }
        
        k=k+5;
    }
    
    
    
    
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
}

//电机远程控制方式
+(NSData *)buildSocketPackage_ControlMSG:(int)num cmd:(int)cmdStatus deviceId:(NSString *)customerNO{
    Byte req[28]={0};
    
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
   // NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=0x12;
    req[11]=0x78;
    req[12]=(Byte)0xA0;
    req[13]=(Byte)0x9C;
    req[14]=0x00;
    req[15]=0x00;
    req[16]=0x00;
    req[17]=0x00;
    
    //命令操作字
    req[18]=0x00;
    req[19]=0x10;
    
    //命令操作符
    req[20]=0x02;
    
    
    //数据包长度
    req[21]=0x00;
    req[22]=0x02;//2个字节 设备索引号+状态值
    //数据包的内容
    req[23]=num&0xFF;
    req[24]=cmdStatus&0xFF;
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
    
    
}

//水质传感器时间参数设置
+(NSData *)saveSocketPackage_Time:(NSString *)customerNO{
    //两组时段 时分秒 3个Byte
    
    //10:00:00
    //11:00:00
    
    NSString *startTime=@"10:10:10";
    NSString *endTime=@"11:10:10";
    
    Byte req[45]={0};
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    //NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=(Byte)0xFF;
    req[11]=(Byte)0xFF;
    req[12]=(Byte)0xFF;
    req[13]=(Byte)0xFF;
    req[14]=(Byte)0xFF;
    req[15]=(Byte)0xFF;
    req[16]=(Byte)0xFF;
    req[17]=(Byte)0xFF;
    //命令操作字
    req[18]=0x00;
    req[19]=0x0d;
    /*
     0x00终端主动上报，数据长度N不需应答；
     0x01查询操作，数据长度0（无数据）
     0x02设置操作，数据长度N;
     0x81应答查询，数据长度N。
     0x82应答设置，数据长度0（无数据）。
     */
    
    req[20]=0x02;
    
    NSArray *hhMMss0=[startTime componentsSeparatedByString:@":"];
    NSArray *hhMMss1=[endTime componentsSeparatedByString:@":"];
    
    NSInteger len=[hhMMss0 count]+[hhMMss1 count];
    
    //数据包长度
    req[21]=0x00;
    req[22]=len;
    //数据包的内容
    req[23]=len;
    
    for (int i=0; i<[hhMMss0 count];i++) {
        req[23+i]=[hhMMss0[i] intValue];
    }
    
    NSInteger size=[hhMMss0 count];
    
    for (int i=0; i<[hhMMss1 count];i++) {
        req[size+23+i]=[hhMMss1[i] intValue];
    }
    
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
    
}


//水质传感器时间参数获取
+(NSData *)buildSocketPackage_Time:(NSString *)customerNO{
    Byte req[27]={0};
    
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    //NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=(Byte)0xFF;
    req[11]=(Byte)0xFF;
    req[12]=(Byte)0xFF;
    req[13]=(Byte)0xFF;
    req[14]=(Byte)0xFF;
    req[15]=(Byte)0xFF;
    req[16]=(Byte)0xFF;
    req[17]=(Byte)0xFF;
    //命令操作字
    req[18]=0x00;
    req[19]=0x0d;
    /*
     0x00终端主动上报，数据长度N不需应答；
     0x01查询操作，数据长度0（无数据）
     0x02设置操作，数据长度N;
     0x81应答查询，数据长度N。
     0x82应答设置，数据长度0（无数据）。
     */
    
    req[20]=0x01;
    
    //数据包长度
    req[21]=0x00;
    req[22]=0x00;
    //数据包的内容
    req[23]=0x00;
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
    
}


//水质传感器区间参数
+(NSData *)buildSocketPackage_Parameters:(NSString *)customerNO{
    Byte req[27]={0};
    
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    //NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=(Byte)0xFF;
    req[11]=(Byte)0xFF;
    req[12]=(Byte)0xFF;
    req[13]=(Byte)0xFF;
    req[14]=(Byte)0xFF;
    req[15]=(Byte)0xFF;
    req[16]=(Byte)0xFF;
    req[17]=(Byte)0xFF;
    //命令操作字
    req[18]=0x00;
    req[19]=0x04;
    /*
     命令操作符
     0x00终端主动上报，数据长度N不需应答；
     0x01查询操作，数据长度0（无数据）
     0x02设置操作，数据长度N;
     0x81应答查询，数据长度N。
     0x82应答设置，数据长度0（无数据）。
     */
   
    req[20]=0x01;
    
    //数据包长度
    req[21]=0x00;
    req[22]=0x00;
    //数据包的内容
    req[23]=0x00;
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
    
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
    
}
//终端心跳信息
+(NSData *)buildSocketPackage_WATER:(NSString *)customerNO{
    Byte req[27]={0};
    
    req[0]='*';
    req[1]='T';
    req[2]='Z';
    req[3]=2;//version
    //水产
    req[4]=0x00;
    req[5]=(Byte)0xFE;
    //NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
        req[5+(++index)]=result;
        
    }
    //命令流水号
    req[10]=0x12;
    req[11]=0x78;
    req[12]=(Byte)0xA0;
    req[13]=(Byte)0x9C;
    req[14]=0x00;
    req[15]=0x00;
    req[16]=0x00;
    req[17]=0x00;
    //命令操作字
    req[18]=0x00;
    req[19]=0x02;//心跳
    
    //命令操作符
    req[20]=0x00;
    
    //数据包长度
    req[21]=0x00;
    req[22]=0x01;
    //数据包的内容
    req[23]=0xff;
    
    int val=(req[21]<<8)+req[22];
    
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        sum+=req[i]&0xFF;
    }
   
    
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
    
}

//终端ID注册信息
+(NSData *)buildSocketPackage_mobile_client:(NSString *)customerNO{
    Byte req[26]={0};
    req[0]='*';
    req[1]='T';
    req[2]='Z';
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
    req[5]=(Byte)0xFE;
    //NSString *customerNO=@"00-00-04-01";
    NSArray *arr=[customerNO componentsSeparatedByString:@"-"];
    int index=0;
    for(NSString *str in arr){
        unsigned int result=0;
        NSScanner *scanner=[NSScanner scannerWithString:str];
        [scanner scanHexInt:&result];
        
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
    //具体数据长度
    int sum=0;
    for(int i=0;i<23+val;i++){
        
        sum+=req[i]&0xFF;
        
    }
    req[23+val]=(sum>>8)&0xFF;
    req[24+val]=sum&0xFF;
    
    req[25+val]='#';
    
    return [[NSData alloc] initWithBytes:req length:(25+val+1)];
}
@end
