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
#import "ExpandRealDataView.h"
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
    
    ExpandRealDataView *expandTableView=[[ExpandRealDataView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weatherView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(weatherView.frame)-tldTabBarHeight)];
    [expandTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [expandTableView setCollectorInfos:_collectorInfos];
    
    [expandTableView setBackgroundColor:[UIColor clearColor]];


    [self.view addSubview:expandTableView];
    

}
-(void)dealloc{
     [[SocketService shareInstance] enableListenser:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [[SocketService shareInstance] reconnect];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
    //[[SocketService shareInstance] setStatusBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
