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
    ACCEPT_DATA_TYPE_PARAMETERS = 1<<1,
    ACCEPT_DATA_TYPE_TIME       = 1<<2,
};

typedef NS_OPTIONS(NSUInteger,SOCKET_TAG){
    SOCKET_TAG_CLIENT_REGISTER  = 999,
    
    SOCKET_TAG_GET_STATUS       = 1001,
    SOCKET_TAG_SET_STATUS       = 1002,
    
    SOCKET_TAG_GET_PARAMETERS   = 2001,
    SOCKET_TAG_SET_PARAMETERS   = 2002,
    
    SOCKET_TAG_GET_TIME     = 3001,
    SOCKET_TAG_SET_TIME     = 3002,
   
};

typedef void (^StatusBlock)(NSDictionary *dic);
typedef void (^OnlineStatusBlock)(BOOL onlineYN,NSString *customNO);
@interface SocketService : NSObject<UIApplicationDelegate>

+(instancetype)shareInstance;
@property(nonatomic,assign) ACCEPT_DATA_TYPE acceptType;

-(void)connect:(NSString *)customerNO;
-(void)disconnect;


-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId;
-(void)saveParametersCmd;
-(void)saveTimeCmd;



-(void)setStatusBlock:(StatusBlock)block;
-(void)setOnlineStatusBlock:(OnlineStatusBlock)block;
-(void)enableListenser:(BOOL)isEnable;


@end
