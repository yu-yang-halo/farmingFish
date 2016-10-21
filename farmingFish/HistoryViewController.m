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
@interface HistoryViewController ()
@property(nonatomic,strong) NSDictionary *deviceData;
@property(nonatomic,strong) NSMutableArray *collectorInfos;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"历史数据";
    [self viewControllerBGInit];
    
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
    
    
    
    ExpandHistoryView *controlView=[[ExpandHistoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-30)];
    [controlView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [controlView setCollectorInfos:_collectorInfos];
    [controlView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:controlView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
