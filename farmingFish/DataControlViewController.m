//
//  DataControlViewController.m
//  farmingFish
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "DataControlViewController.h"
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
#import "ExpandControlView.h"
#import "WeatherShowManager.h"
@interface DataControlViewController ()
{
      MBProgressHUD *hud;
}

@property(nonatomic,strong) UIScrollView *globalView;
/**
 ** 设备控制
 **/
@property(nonatomic,strong) DeviceControlTableView *devControlView;
/**
 ** devArr    后台设备数据 Electrics
 **/
@property(nonatomic,strong) NSArray *devArr;
@property(nonatomic,strong) NSMutableArray *collectorInfos;
/**
 ** devStatus 设备状态值 @“10000000”
 **/
@property(nonatomic,strong) NSString *devStatus;
@end

@implementation DataControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备控制";
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
    

    
    ExpandControlView *controlView=[[ExpandControlView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-tldTabBarHeight)];
    [controlView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [controlView setCollectorInfos:_collectorInfos];
    [controlView setBackgroundColor:[UIColor clearColor]];
   
    [self.view addSubview:controlView];
    
    
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

@end

