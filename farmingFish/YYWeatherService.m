//
//  YYWeatherService.m
//  farmingFish
//
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYWeatherService.h"
#import "JSONKit.h"
#import "WeatherHelper.h"
static YYWeatherService *instance;
static NSString *weather_api=@"http://op.juhe.cn/onebox/weather/query";
static NSString *juheKEY=@"7621836ff352deeee8c88dd07c60ca1e";
@interface YYWeatherService(){
    
}

@end

@implementation YYWeatherService
+(instancetype)defaultService{
    if(instance==nil){
        instance=[[YYWeatherService alloc] init];
    }
    return instance;
}
-(void)downloadWeatherData{
    NSString *cityName=[[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if(cityName==nil){
        cityName=@"北京";
    }
    [self downloadWeatherData:cityName];
}
-(void)downloadWeatherData:(NSString *)cityName{
    NSString *urlString=[NSString stringWithFormat:@"%@?cityname=%@&dtype=&key=%@",weather_api,[cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceAndNewlineCharacterSet]],juheKEY];
    
    NSData *data=[self sendDataRequest:urlString];
    if(data!=nil){
        
        NSDictionary *dict=[data objectFromJSONData];
        
        //NSLog(@"dict ::: %@",dict);
        
        NSDictionary *result=[dict objectForKey:@"result"];
        if(result!=nil){
            NSDictionary *realTimeData=[[result objectForKey:@"data"] objectForKey:@"realtime"];
            
            
            //NSLog(@"realTimeData ::: %@ \n",realTimeData);
            NSMutableArray *arr=[WeatherHelper loadDiskDataToObject];
            if(arr==nil){
                arr=[NSMutableArray new];
            }
            [WeatherHelper addDictObject:realTimeData toArray:arr];
            
            [WeatherHelper cacheObjectToDisk:arr];
        }
        
    }
    
}
-(NSData *)sendDataRequest:(NSString *)urlString{
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    
    NSURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
 
        return data;
        
    }else{
        NSString *errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[error] %@",errorDescription);
        });
    }
    return nil;
}

@end
