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
@interface RealDataViewController (){
    MBProgressHUD *hud;
}
@property(nonatomic,strong) UIScrollView *globalView;
/**
 ** 实时数据 + 设备控制
 **/
@property(nonatomic,strong) RealDataTableView *realDataView;
@property(nonatomic,strong) DeviceControlTableView *devControlView;
/**
 ** statusArr 实时数据值集合
 ** devArr    后台设备数据 Electrics
 **/
@property(nonatomic,strong) NSMutableArray *statusArr;
@property(nonatomic,strong) NSArray *devArr;
/**
 ** devStatus 设备状态值 @“10000000”
 **/
@property(nonatomic,strong) NSString *devStatus;
@end

@implementation RealDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"实时数据";
    
    self.automaticallyAdjustsScrollViewInsets = NO; 
    
    [self navigationBarInit];
    [self viewControllerBGInit];
    
  
    [[SocketService shareInstance] enableListenser:YES];
    
    
    if(_deviceData!=nil){
        NSArray *arr=[[_deviceData objectForKey:@"GetCollectorInfoResult"] objectFromJSONString];
        
        if(arr!=nil&&[arr count]>0){
            NSString *electrics=[arr[0] objectForKey:@"Electrics"];
            if(electrics!=nil){
               self.devArr=[electrics componentsSeparatedByString:@","];
                
            }
        }
        
    }
    
      [self viewInit];
    
}
-(void)dealloc{
     [[SocketService shareInstance] enableListenser:NO];
}
/*
 *代码布局view
 */
-(void)viewInit{
    self.globalView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];

    
    self.realDataView=[[RealDataTableView alloc] initWithFrame:CGRectMake(10,10, _globalView.frame.size.width-20, 0)];
    
    _realDataView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.1] CGColor];
    _realDataView.separatorColor=[UIColor colorWithWhite:1 alpha:0.3];

    _realDataView.layer.borderWidth=1;
    _realDataView.layer.cornerRadius=2;
    [_realDataView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.1]];
    
    self.devControlView=[[DeviceControlTableView alloc] initWithFrame:CGRectMake(10,10, _globalView.frame.size.width-20, 0)];
    
    _devControlView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.1] CGColor];
    _devControlView.separatorColor=[UIColor colorWithWhite:1 alpha:0.3];
    _devControlView.separatorColor=[UIColor colorWithWhite:1 alpha:0.3];
    
    _devControlView.layer.borderWidth=1;
    _devControlView.layer.cornerRadius=2;
    [_devControlView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.1]];
    
    [_devControlView setDeviceDatas:_devArr];
    
    
    CGRect frame2=_devControlView.frame;
    frame2.size.height=[_devArr count]*50;
    [_devControlView setFrame:frame2];

    
    [self.globalView addSubview:_realDataView];
    [self.globalView addSubview:_devControlView];
    
    [self.view addSubview:_globalView];
    
    [_devControlView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"获取实时数据...";
    
    [hud showAnimated:YES];
    
    [[SocketService shareInstance] connect];
    
    [[SocketService shareInstance] setOnlineStatusBlock:^(BOOL onlineYN) {
       
        if(onlineYN){
             self.title=@"实时数据";
        }else{
             self.title=@"实时数据(离线)";
        }
        
    }];
    
    [[SocketService shareInstance] setStatusBlock:^(NSDictionary *dic) {
        if(hud!=nil){
            [hud hideAnimated:YES];
        }
        NSLog(@"%@",dic);
        self.statusArr=[NSMutableArray new];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if([key isKindOfClass:[NSNumber class]]){
                /*
                 * 属性名称 当前值 最大值 单位 filter
                 */
                NSArray* contents=[obj componentsSeparatedByString:@"|"];
                if(contents!=nil&&[contents count]==4){
                    [_statusArr addObject:obj];
                }
            }else if([key isKindOfClass:[NSString class]]){
                if([key isEqualToString:@"status"]){
                    NSLog(@"status %@",obj);
                    self.devStatus=obj;
                }
            }

            
        }];
        
        if(_statusArr!=nil&&[_statusArr count]>0){
            [_realDataView setRealDatas:_statusArr];
            [_realDataView reloadData];
            CGRect frame=_realDataView.frame;
            frame.size.height=[_statusArr count]*50;
            
            [_realDataView setFrame:frame];
        }
        
        [_devControlView setRealStatus:_devStatus];
        [_devControlView setDeviceDatas:_devArr];
        [_devControlView reloadData];
        
        CGRect frame2=_devControlView.frame;
        frame2.origin.y=_realDataView.frame.origin.y+_realDataView.frame.size.height+10;
        frame2.size.height=[_devArr count]*50;
        
        [_devControlView setFrame:frame2];
        
        
        float totalHeight=_realDataView.frame.origin.x+_realDataView.frame.size.height+_devControlView.frame.origin.x+_devControlView.frame.size.height;
        
        
        [_globalView setContentSize:CGSizeMake(self.view.bounds.size.width, totalHeight+10)];
        
    }];
}
/*
 status = 10000000;
 3 = "PH|7.300000";
 6 = "\U4e9a\U785d\U9178\U76d0|0.030000";
 5 = "\U6e29\U5ea6|24.450001";
 1 = "\U6eb6\U6c27|4.090000";
 4 = "\U6c28\U6c2e|0.140000";
 */
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
