//
//  SocketService.h
//  farmingFish
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^StatusBlock)(NSDictionary *dic);
typedef void (^OnlineStatusBlock)(BOOL onlineYN,NSString *customNO);
@interface SocketService : NSObject<UIApplicationDelegate>

+(instancetype)shareInstance;

-(void)connect:(NSString *)customerNO;
-(void)disconnect;
-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId;

-(void)setStatusBlock:(StatusBlock)block;
-(void)setOnlineStatusBlock:(OnlineStatusBlock)block;
-(void)enableListenser:(BOOL)isEnable;


@end
