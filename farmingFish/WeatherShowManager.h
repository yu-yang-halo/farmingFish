//
//  WeatherShowManager.h
//  farmingFish
//
//  Created by admin on 16/10/11.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WEATHER_DAY) {
    WEATHER_DAY_BEFOR_YESTERDAY=0,
    WEATHER_DAY_YESTERDAY=1,
    WEATHER_DAY_TODAY=2
 
};
@interface WeatherShowManager : NSObject
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)refreshDataAndShow:(WEATHER_DAY)_day;

@end
