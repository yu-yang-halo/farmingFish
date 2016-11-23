//
//  AppDelegate.h
//  farmingFish
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 * CustomerNo
 */
@property(nonatomic,strong) NSString *customerNo;
@property(nonatomic,strong) NSString *userAccount;

//视频数据
@property(nonatomic,strong) NSArray *videoInfoArrs;
//设备数据
@property(nonatomic,strong) NSDictionary *deviceData;



@property(nonatomic,assign) BOOL isReachableWiFi;

@end

