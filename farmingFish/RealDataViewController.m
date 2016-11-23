//
//  RealDataViewController.m
//  farmingFish
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "RealDataViewController.h"
#import "UIViewController+Extension.h"
#import "SocketService.h"
#import "YYStatusView.h"
#import "RealDataTableView.h"
#import "DeviceControlTableView.h"
#import "JSONKit.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "FService.h"
#import "BeanObjectHelper.h"
#import "MyExpandTableView.h"
#import "WeatherShowManager.h"
@interface RealDataViewController (){
    MBProgressHUD *hud;
}
@property(nonatomic,strong) UIScrollView *globalView;
/**
 ** 实时数据
 **/
@property(nonatomic,strong) RealDataTableView *realDataView;
@property(nonatomic,strong) NSMutableArray<YYCollectorInfo *> *collectorInfos;

@end

@implementation RealDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerBGInitWhite];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[SocketService shareInstance] enableListenser:YES];
    
   
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    self.deviceData=delegate.deviceData;
    

    if(_deviceData!=nil){
        NSArray *arr=[[_deviceData objectForKey:@"GetCollectorInfoResult"] objectFromJSONString];
        self.collectorInfos=[NSMutableArray new];
        if(arr!=nil&&[arr count]>0){
            
            for(NSDictionary *dict in arr){
                YYCollectorInfo *info=[[YYCollectorInfo alloc] init];
                [BeanObjectHelper dictionaryToBeanObject:dict beanObj:info];
                
                NSString *electrics=[dict objectForKey:@"Electrics"];
                if(electrics!=nil){
                    info.electricsArr=[electrics componentsSeparatedByString:@","];
                    
                }
                [_collectorInfos addObject:info];
              
            }
            
        }
        
    }
    
    WeatherShowManager *viewManager =[[WeatherShowManager alloc] init];
    UIView *weatherView=viewManager.weatherView;
    [viewManager refreshDataAndShow:WEATHER_DAY_TODAY];
    weatherView.frame=CGRectMake(0, 64, self.view.frame.size.width,CGRectGetHeight(weatherView.frame));//94
    [self.view addSubview:weatherView];
    
    MyExpandTableView *expandTableView=[[MyExpandTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weatherView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(weatherView.frame)-tldTabBarHeight)];
    [expandTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [expandTableView setCollectorInfos:_collectorInfos];
    
    [expandTableView setBackgroundColor:[UIColor clearColor]];


    [self.view addSubview:expandTableView];
    

}
-(void)dealloc{
     [[SocketService shareInstance] enableListenser:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
    [[SocketService shareInstance] setStatusBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
                                               溶氧 4.050000
 2016-09-23 17:22:56.400 farmingFish[3710:60b] 温度 23.820000
 2016-09-23 17:22:56.408 farmingFish[3710:60b] PH 7.300000
 2016-09-23 17:22:56.409 farmingFish[3710:60b] 氨氮 0.120000
 2016-09-23 17:22:56.411 farmingFish[3710:60b] 亚硝酸盐 0.020000
 2016-09-23 17:22:56.412 farmingFish[3710:60b] 液位 0.000000
 2016-09-23 17:22:56.413 farmingFish[3710:60b] 硫化氢 0.000000
 2016-09-23 17:22:56.415 farmingFish[3710:60b] 浊度 0.000000
 2016-09-23 17:22:56.416 farmingFish[3710:60b] 电机状态 10000000
 {
 GetCollectorInfoResult = "[{\"CustomerNo\":\"00-00-04-01\",\"UserType\":1,\"CollectorID\":\"68eeffe7-9561-4a0f-9a7d-751c4cca98fe\",\"DeviceID\":\"00-00-04-01\",\"ProvinceName\":\"\",\"CityName\":\"\",\"OrgName\":\"\",\"FiledID\":\"4f2ca14a-5a15-47f0-95e2-52746c4abeb7\",\"PondName\":\"\U80a5\U4e1c\U53bf\U7a0b\U7ee7\U6765\U5bb6\U5ead\U519c\U573a\U573a\U5730\",\"Electrics\":\"1-\U589e\U6c27\U673a,2-\U589e\U6c27\U673a\"}]";
 }
 */

@end
