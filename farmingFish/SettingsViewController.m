//
//  SettingsViewController.m
//  farmingFish
//
//  Created by apple on 16/10/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+Extension.h"
#import "ParamsTableViewCell.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ExpandSettingsView.h"
#import "ExpandSetRangeView.h"
#import "FService.h"
#import "BeanObjectHelper.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SocketService.h"
@interface SettingsViewController ()

@property(nonatomic,strong) NSArray *contents;
@property(nonatomic,strong) ExpandSettingsView *tableView;
@property(nonatomic,strong) ExpandSetRangeView *setRangeView;

@property(nonatomic,strong) NSMutableArray *collectorInfos;
@property(nonatomic,strong) NSDictionary *deviceData;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerBGInitWhite];
    self.title=@"个人中心";
    
   
    
    
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

    self.contents=@[@"预警设置",@"阈值设置"];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_contents];
    
    segmentedControl.frame = CGRectMake(0, 64, self.view.bounds.size.width, 50);
    
    self.tableView=[[ExpandSettingsView alloc] initWithFrame:CGRectZero];
    _tableView.frame=CGRectMake(0, 64+50,self.view.bounds.size.width, self.view.bounds.size.height-64-50);
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setCollectorInfos:_collectorInfos];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    self.setRangeView=[[ExpandSetRangeView alloc] initWithFrame:CGRectZero];
    _setRangeView.frame=CGRectMake(0, 64+50,self.view.bounds.size.width, self.view.bounds.size.height-64-50);
    
    
    
    [_setRangeView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_setRangeView setCollectorInfos:_collectorInfos];
    [_setRangeView setBackgroundColor:[UIColor clearColor]];

    
    
    
    

    
    
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorHeight = 1.5f;
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:1];
    segmentedControl.verticalDividerWidth=1.0f;
    segmentedControl.verticalDividerColor=[UIColor colorWithWhite:0 alpha:0.1];
    segmentedControl.verticalDividerEnabled=YES;
    
    
    segmentedControl.selectionIndicatorBoxOpacity = 0.0;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.shouldAnimateUserSelection = NO;
    segmentedControl.tag = 2;
    [self.view addSubview:segmentedControl];
    [self.view addSubview:_tableView];
    [self.view addSubview:_setRangeView];
    
    [_setRangeView setHidden:YES];
    
    
    [self.view setUserInteractionEnabled:YES];
    
    

}
-(void)segmentedControlChangedValue:(HMSegmentedControl *)sender{
    
    if(sender.selectedSegmentIndex==0){
        [_setRangeView setHidden:YES];
        [_tableView setHidden:NO];
    }else{
        [_setRangeView setHidden:NO];
        [_tableView setHidden:YES];
        
    }
    
}


-(void)dealloc{
    [[SocketService shareInstance] enableListenser:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[SocketService shareInstance] reconnect];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
