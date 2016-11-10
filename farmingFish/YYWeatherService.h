//
//  YYWeatherService.h
//  farmingFish
//  *************************
//  ****采用的聚合天气服务接口***
//  *************************
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYWeatherService : NSObject
+(instancetype)defaultService;
//-(void)downloadWeatherData:(NSString *)cityName;
-(void)downloadWeatherData;
@end
