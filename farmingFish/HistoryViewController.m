//
//  HistoryViewController.m
//  farmingFish
//
//  Created by apple on 16/10/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "HistoryViewController.h"
#import "UIViewController+Extension.h"
#import "ExpandHistoryView.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "BeanObjectHelper.h"
#import "FService.h"
@interface HistoryViewController ()
@property(nonatomic,strong) NSDictionary *deviceData;
@property(nonatomic,strong) NSMutableArray *collectorInfos;

@property(nonatomic,strong) NSMutableArray *currentHistoryArrs;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"历史数据";
    [self viewControllerBGInit];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
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
    
    
    
    ExpandHistoryView *controlView=[[ExpandHistoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [controlView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [controlView setCollectorInfos:_collectorInfos];
    [controlView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:controlView];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
  
}

/*

 GetCollectorData::: {
 GetCollectorDataResult = "[{\"F_ReceivedTime\":0,\"F_Param1\":6.59,\"F_Param3\":7.99,\"F_Param4\":0.28,\"F_Param5\":15.30,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":1,\"F_Param1\":6.46,\"F_Param3\":7.96,\"F_Param4\":0.26,\"F_Param5\":15.25,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":2,\"F_Param1\":6.47,\"F_Param3\":7.96,\"F_Param4\":0.28,\"F_Param5\":15.24,\"F_Param6\":0.07,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":3,\"F_Param1\":6.99,\"F_Param3\":7.96,\"F_Param4\":0.28,\"F_Param5\":14.90,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":4,\"F_Param1\":7.27,\"F_Param3\":7.97,\"F_Param4\":0.28,\"F_Param5\":14.72,\"F_Param6\":0.07,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":5,\"F_Param1\":7.32,\"F_Param3\":7.92,\"F_Param4\":0.25,\"F_Param5\":14.56,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":6,\"F_Param1\":7.26,\"F_Param3\":7.90,\"F_Param4\":0.27,\"F_Param5\":14.48,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":7,\"F_Param1\":6.79,\"F_Param3\":7.92,\"F_Param4\":0.28,\"F_Param5\":14.57,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":8,\"F_Param1\":6.93,\"F_Param3\":7.86,\"F_Param4\":0.28,\"F_Param5\":14.42,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":9,\"F_Param1\":6.89,\"F_Param3\":7.87,\"F_Param4\":0.27,\"F_Param5\":14.40,\"F_Param6\":0.07,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":10,\"F_Param1\":7.12,\"F_Param3\":7.92,\"F_Param4\":0.30,\"F_Param5\":14.31,\"F_Param6\":0.07,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":11,\"F_Param1\":7.31,\"F_Param3\":7.91,\"F_Param4\":0.26,\"F_Param5\":14.30,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":12,\"F_Param1\":7.15,\"F_Param3\":7.88,\"F_Param4\":0.27,\"F_Param5\":14.31,\"F_Param6\":0.08,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null},{\"F_ReceivedTime\":13,\"F_Param1\":7.28,\"F_Param3\":7.82,\"F_Param4\":0.26,\"F_Param5\":14.29,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null}]";
 }

 
*/

@end
