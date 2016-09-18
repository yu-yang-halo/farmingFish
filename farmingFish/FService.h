//
//  FService.h
//  farmingFish
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FService : NSObject
+(instancetype)shareInstance;

-(NSString *)loginName:(NSString *)name password:(NSString *)pass;

//采集设备信息
-(id)GetCollectorInfo:(NSString *)customerNo userAccount:(NSString *)ua;
//用户视频信息
-(id)GetUserVideoInfo:(NSString *)userAccount;
-(id)GetVideoInfo:(NSString *)fieldId;


-(id)GetCollectorData:(NSString *)customerNo dateTime:(NSString *)date;


@end
