//
//  SocketService.h
//  farmingFish
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BeanObject.h"


typedef NS_OPTIONS(NSUInteger,SOCKET_TAG){
    SOCKET_TAG_CLIENT_REGISTER  = 999,
    
    SOCKET_TAG_GET_STATUS       = 1001,
    SOCKET_TAG_SET_STATUS       = 1002,
    
    SOCKET_TAG_GET_THRESHOLDS   = 2001,
    SOCKET_TAG_SET_THRESHOLDS   = 2002,
   
    
    
    MethodType_GET              =3000,
    MethodType_POST             =3001,
    
    MODE_TYPE_AUTO              =0xAC,//自动
    MODE_TYPE_MENUAL            =0xDC,//手动
   
};


typedef void (^StatusBlock)(YYPacket *packet);
typedef void (^OnlineStatusBlock)(BOOL onlineYN,NSString *customNO);
@interface SocketService : NSObject<UIApplicationDelegate>

+(instancetype)shareInstance;

-(void)reconnect;
-(void)connect:(NSString *)customerNO;


-(void)disconnect;
-(void)disconnectAndClear;


-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId;


-(void)rangSetOrGet:(int)methodType max:(int)max min:(int)min devId:(NSString *)devId;
-(void)modeSwith:(int)methodType mode:(int)modeType devId:(NSString *)devId;

-(void)autoStartTime:(int)methodType time:(int)time devId:(NSString *)devId;






-(void)setStatusBlock:(StatusBlock)block;
-(void)setOnlineStatusBlock:(OnlineStatusBlock)block;


-(void)enableListenser:(BOOL)isEnable;


@end
