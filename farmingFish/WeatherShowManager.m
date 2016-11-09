//
//  WeatherShowManager.m
//  farmingFish
//
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "WeatherShowManager.h"
#import "YYWeatherService.h"
#import "WeatherHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface WeatherShowManager(){
    
}
@property(nonatomic,strong) NSArray *weeks;
@end

@implementation WeatherShowManager

-(instancetype)init{
    self=[super init];
    if(self){
        
        [[NSBundle mainBundle] loadNibNamed:@"weatherView" owner:self options:nil];
        self.weeks=@[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        
    }
    return self;
}
-(void)refreshDataAndShow:(WEATHER_DAY)_day{
     __block NSDictionary *dict=nil;
    if(_day!=WEATHER_DAY_TODAY){
        
        NSMutableArray *arrays=[WeatherHelper loadDiskDataToObject];
        if([arrays count]>=2){
            if([arrays count]==2&&_day==WEATHER_DAY_YESTERDAY){
                dict=arrays[0];
            }else{
                dict=arrays[_day];
            }
            [self layoutWeatherUI:dict];
        }else{
            [self layoutWeatherUI:nil];
        }
        
    }else{
       
        NSString *cityName=[[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
        if(cityName==nil){
            cityName=@"北京";
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            [[YYWeatherService defaultService] downloadWeatherData:cityName];
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *arrays=[WeatherHelper loadDiskDataToObject];
                
                dict=[arrays lastObject];
                [self layoutWeatherUI:dict];
               
            });
            
        });

        
    }
    
    
}
-(void)layoutWeatherUI:(NSDictionary *)dict{
    if(dict==nil){
        _weatherView.frame=CGRectZero;
        return;
    }
    [_cityLabel setText:[dict objectForKey:@"city_name"]];
    int week=[[dict objectForKey:@"week"] intValue];
    [_timeLabel setText:[NSString stringWithFormat:@"%@     %@",[dict objectForKey:@"date"],_weeks[week]]];
    NSDictionary *weather=[dict objectForKey:@"weather"];
    [_tempLabel setText:[NSString stringWithFormat:@"%@℃ %@ ",[weather objectForKey:@"temperature"],[weather objectForKey:@"info"]]];
    int imageId=[[weather objectForKey:@"img"] intValue];
    
    
    NSString *imagePath=[self prefixZero:imageId];
    [_weatherImage setImage:[UIImage imageNamed:imagePath]];
     _weatherView.alpha=0;
    CGRect frame=_weatherView.frame;
    frame.size.height=94;
    
    _weatherView.frame=frame;
    
    
    [UIView animateWithDuration:1 animations:^{
        _weatherView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(NSString *)prefixZero:(int)imageId{
    if(imageId<10){
        return [NSString stringWithFormat:@"0%d",imageId];
    }else{
        return [NSString stringWithFormat:@"%d",imageId];
    }
}
@end
