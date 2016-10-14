//
//  WeatherHelper.h
//  farmingFish
//
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherHelper : NSObject
+(NSMutableArray *)loadDiskDataToObject;
+(void)cacheObjectToDisk:(NSArray *)arr;


+(void)addDictObject:(NSDictionary *)dict toArray:(NSMutableArray *)arr;

@end
