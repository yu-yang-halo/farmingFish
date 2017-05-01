//
//  AlertViewController.m
//  farmingFish
//
//  Created by apple on 2016/11/6.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYAlertViewController.h"
#import "UIViewController+Extension.h"
#import "SocketService.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "BeanObject.h"
#import "BeanObjectHelper.h"
#import "FService.h"
@interface YYAlertViewController ()
@property(nonatomic,strong) NSMutableArray<YYCollectorInfo *> *collectorInfos;
@property(nonatomic,strong) NSDictionary *deviceData;
@end

@implementation YYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self viewControllerBGInitWhite];
    
    
    
}
-(void)loadData{
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
    
    if(_collectorInfos!=nil&&[_collectorInfos count]>0){
        
        YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            id obj=[[FService shareInstance] GetCollectorSensorList:collectorInfo.CollectorID sensorId:@"1" collectType:@"1"];
            
            id _sensors=[obj objectForKey:@"SensorList"];
            
            NSArray<YYCollectorSensor *> *sensorList=[BeanObjectHelper parseYYCollectorSensorList:_sensors];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
            });
            
        });
        
        
        
        [[SocketService shareInstance] connect:collectorInfo.CustomerNo];
        
        [[SocketService shareInstance] setOnlineStatusBlock:^(BOOL onlineYN,NSString *customerNO) {
            
            if(onlineYN){
                //@"实时数据";
                NSLog(@"%@ online",customerNO);
                //[self.window makeToast:@"数据在线"];
            }else{
                //@"实时数据(离线)";
                NSLog(@"%@ offline",customerNO);
                //[self.window makeToast:@"数据离线"];
            }
            
        }];
        
        [[SocketService shareInstance] setStatusBlock:^(YYPacket *packet) {
            NSDictionary *dic=[packet dict];
            
            NSLog(@"%@",dic);
            NSMutableArray *realDataArr=[NSMutableArray new];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                
                if([key isKindOfClass:[NSNumber class]]){
                    /*
                     * 属性名称 当前值 最大值 单位 filter
                     */
                    NSArray* contents=[obj componentsSeparatedByString:@"|"];
                    if(contents!=nil&&[contents count]==5){
                        [realDataArr addObject:obj];
                        
                    }
                }else if([key isKindOfClass:[NSString class]]){
                    
                }
                
            }];
            
            
            realDataArr=[realDataArr sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
                int value1=[[[obj1 componentsSeparatedByString:@"|"] lastObject] intValue];
                
                int value2=[[[obj2 componentsSeparatedByString:@"|"] lastObject] intValue];
                
                
                return (value1-value2)<0?NSOrderedAscending:NSOrderedDescending;
                
            }];
            
            if(realDataArr!=nil&&[realDataArr count]>0){
                
                
            }
            
            
            
        }];
        
    }
    
    
    

}
-(void)dealloc{
    [[SocketService shareInstance] enableListenser:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    //[self loadData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
    //[[SocketService shareInstance] setStatusBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
