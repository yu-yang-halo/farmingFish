//
//  FService.h
//  farmingFish
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, CATEGORYID) {
    CATEGORYID_NEWS        = 0x0001,
    CATEGORYID_KNOWLEDGE   = 0x0002
};

@interface FService : NSObject
+(instancetype)shareInstance;

-(NSString *)loginName:(NSString *)name password:(NSString *)pass;

//采集设备信息
-(id)GetCollectorInfo:(NSString *)customerNo userAccount:(NSString *)ua;
//用户视频信息
-(id)GetUserVideoInfo:(NSString *)userAccount;
-(id)GetVideoInfo:(NSString *)fieldId;


-(id)GetCollectorData:(NSString *)customerNo dateTime:(NSString *)date;
//day : 0--今天 1--昨天  2--前天
-(id)GetCollectorData:(NSString *)customerNo day:(int)day;


//新闻数据 categoryId 1:新闻 2:知识库
-(id)GetNewsList:(CATEGORYID)categoryId number:(int)num;



@end
