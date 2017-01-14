//
//  SocketService.h
//  farmingFish
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger,ACCEPT_DATA_TYPE){
    ACCEPT_DATA_TYPE_STATUS     = 1<<0,
    ACCEPT_DATA_TYPE_THRESHOLD  = 1<<1,
};

typedef NS_OPTIONS(NSUInteger,SOCKET_TAG){
    SOCKET_TAG_CLIENT_REGISTER  = 999,
    
    SOCKET_TAG_GET_STATUS       = 1001,
    SOCKET_TAG_SET_STATUS       = 1002,
    
    SOCKET_TAG_GET_THRESHOLDS   = 2001,
    SOCKET_TAG_SET_THRESHOLDS   = 2002,

   
};

typedef void (^StatusBlock)(NSDictionary *dic);
typedef void (^OnlineStatusBlock)(BOOL onlineYN,NSString *customNO);
@interface SocketService : NSObject<UIApplicationDelegate>

+(instancetype)shareInstance;
@property(nonatomic,assign) ACCEPT_DATA_TYPE acceptType;
-(void)reconnect;
-(void)connect:(NSString *)customerNO;


-(void)disconnect;
-(void)disconnectAndClear;


-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId;

-(void)saveThresoldsCmd;



-(void)setStatusBlock:(StatusBlock)block;
-(void)setOnlineStatusBlock:(OnlineStatusBlock)block;
-(void)enableListenser:(BOOL)isEnable;


@end
