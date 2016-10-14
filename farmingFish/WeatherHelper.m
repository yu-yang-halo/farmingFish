//
//  WeatherHelper.m
//  farmingFish
//
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
/*
 "city_code" = 101220101;
 "city_name" = "\U5408\U80a5";
 dataUptime = 1476167765;
 date = "2016-10-11";
 moon = "\U4e5d\U6708\U5341\U4e00";
 time = "14:00:00";
 weather =     {
 humidity = 78;
 img = 2;
 info = "\U9634";
 temperature = 18;
 };
 week = 2;
 wind =     {
 direct = "\U4e1c\U5317\U98ce";
 offset = "<null>";
 power = "2\U7ea7";
 windspeed = "<null>";
 };

 
 */

#import "WeatherHelper.h"
#import "JSONKit.h"
#import "DateHelper.h"
static NSString *KEY_WEATHER_DATA=@"weather_data";
@implementation WeatherHelper
+(NSMutableArray *)loadDiskDataToObject{
    
   NSString *jsonArr=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_WEATHER_DATA];
    if(jsonArr==nil){
        return nil;
    }
    
   return [[jsonArr objectFromJSONString] mutableCopy];
    
}
+(void)addDictObject:(NSDictionary *)dict toArray:(NSMutableArray *)arr{
    if(arr==nil){
        return;
    }
    
   
    NSString *today=[DateHelper dateToString: [DateHelper localeDate] withFormat:@"yyyy-MM-dd"];
    
    int existIndex=-1;
    for (int i=0;i<[arr count];i++) {
        if([[arr[i] objectForKey:@"date"] isEqualToString:today]){
            existIndex=i;
        }
       
    }
    if(existIndex>=0){
        [arr replaceObjectAtIndex:existIndex withObject:dict];
    }else{
        if([arr count]>=3){
            [arr removeObjectAtIndex:0];
            [arr addObject:dict];
        }else{
            [arr addObject:dict];
        }
    }
   
    
    
}



+(void)cacheObjectToDisk:(NSArray *)arr{
   NSString *jsonArr=[arr JSONString];
    
   [[NSUserDefaults standardUserDefaults] setObject:jsonArr forKey:KEY_WEATHER_DATA];
    
}
@end
