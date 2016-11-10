//
//  ExpandHistoryView.m
//  farmingFish
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "ExpandHistoryView.h"
#import "YYButton.h"
#import "SocketService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import "FService.h"
#define HEAD_HEIGHT 40



@interface ExpandHistoryView(){
    
}
@property(nonatomic,strong) RealDataLoadBlock block;

@end
@implementation ExpandHistoryView

-(instancetype)init{
    self=[super init];
    if(self){
        [self setUpViews];
        
    }
    NSLog(@"init...");
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setUpViews];
    }
    NSLog(@"initWithFrame...");
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        [self setUpViews];
    }
    NSLog(@"initWithFrame...style ...");
    return self;
    
}
-(void)setUpViews{
    self.dataSource=self;
    self.delegate=self;
    
    
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}


#pragma mark datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_collectorInfos count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*
     *  state expand 展开状态显示正常数据
     *        关闭状态显示0
     */
    if(![[_collectorInfos objectAtIndex:section] expandYN]){
        return 0;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     * 显示子节点数据
     */
    YYCollectorInfo *collectorInfo=[self findSelectedCollectorInfo];
    
    YYHistoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yyHistoryCell"];
    UIView *headerView;
    HistoryTableView *tbView;
    
    if(cell==nil){
        cell=[[YYHistoryTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"yyHistoryCell"];
        
        
        headerView=[self historyHeaderView:cell collectorInfo:collectorInfo];
        
         cell.headerView=headerView;
        
        [cell addSubview:headerView];
        
        tbView=[[HistoryTableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(headerView.frame),[UIScreen mainScreen].bounds.size.width,0) style:(UITableViewStylePlain)];
        
        
        [tbView setBackgroundColor:[UIColor clearColor]];
        [tbView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        
         cell.historyTableView=tbView;
        [cell addSubview:tbView];
    }
    tbView=cell.historyTableView;
    headerView=cell.headerView;
    [cell.segmentedControl setSelectedSegmentIndex:(2-collectorInfo.day)];
     cell.segmentedControl.tag=indexPath.section;
    
    [cell.viewManager refreshDataAndShow:(2-collectorInfo.day)];
    UIView *_view=cell.viewManager.weatherView;
    _view.frame=cell.weatherView.frame;
    [cell.weatherView removeFromSuperview];
    [cell addSubview:_view];
    
    if(collectorInfo.historyDict!=nil){
    
        [tbView setHistoryDataDict:collectorInfo.historyDict];
        [tbView reloadData];
        NSInteger size=[collectorInfo.historyDict count];
        CGFloat tableViewTotalHeight=0.0;
        for (int i=0;i<size;i++) {
            
            CGFloat height=[tbView tableView:tbView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            tableViewTotalHeight+=height;
        }
        
        CGRect tableFrame=tbView.frame;
        tableFrame.size.height=tableViewTotalHeight;
        tbView.frame=tableFrame;
        
        NSLog(@"tableViewTotalHeight %f",tableViewTotalHeight);
        
        CGRect cellFrame=cell.frame;
        
        cellFrame.size.height=tableViewTotalHeight+CGRectGetHeight(headerView.frame);
        
        cell.frame=cellFrame;
        
        
    }
    
    [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
     UIView *selectBGView=[[UIView alloc] initWithFrame:CGRectZero];
    
    [cell setSelectedBackgroundView:selectBGView];
    
    return cell;
}
-(UIView *)historyHeaderView:(YYHistoryTableViewCell *)cell collectorInfo:(YYCollectorInfo *)collectorInfo{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectZero];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"前天", @"昨天", @"今天"]];
    segmentedControl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [segmentedControl setSelectionStyle:(HMSegmentedControlSelectionStyleFullWidthStripe)];
    [segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjects:@[[UIColor whiteColor]] forKeys:@[NSForegroundColorAttributeName]]];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.1]];
    
    cell.segmentedControl=segmentedControl;
    
    WeatherShowManager *viewManager =[[WeatherShowManager alloc] init];
    [viewManager refreshDataAndShow:(2-collectorInfo.day)];
    UIView *weatherView=viewManager.weatherView;
    [weatherView setBackgroundColor:[UIColor clearColor]];
   
     weatherView.frame=CGRectMake(0,CGRectGetMaxY(segmentedControl.frame),[UIScreen mainScreen].bounds.size.width,CGRectGetHeight(weatherView.frame));//94
    
    [headerView addSubview:segmentedControl];
    [headerView addSubview:weatherView];
    
    headerView.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,CGRectGetMaxY(weatherView.frame));
    
    cell.viewManager=viewManager;
    cell.weatherView=weatherView;
    
    return headerView;
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)sender{
    //NSLog(@"segmentedControlChangedValue %@",sender);
    int idx=2-sender.selectedSegmentIndex;
    YYCollectorInfo *collectorInfo=[self findSelectedCollectorInfo];
    [self reloadHistoryData:collectorInfo idx:idx selectIndex:sender.tag switchYN:NO];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    /*
     *显示父节点数据
     */
    YYButton *backgroundView=[[YYButton alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width, HEAD_HEIGHT)];
    
    [backgroundView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundView setTag:section];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1] forState:(UIControlStateNormal)];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2] forState:(UIControlStateHighlighted)];
    [backgroundView addTarget:self action:@selector(groupExpand:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,(HEAD_HEIGHT-9)/2,16,9)];
    
    
    
    if(![[_collectorInfos objectAtIndex:section] expandYN]){
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
    }else{
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
    }
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(36,0,250,HEAD_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:tldCellFontSize]];
    
    [label setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    label.text=[[_collectorInfos objectAtIndex:section] PondName];
    
    
    [backgroundView addSubview:arrowImageView];
    [backgroundView addSubview:label];
    return backgroundView;

}


-(void)reloadTableViewUI:(int)selectCourseIndex{
    
    for(int i=0;i<[_collectorInfos count];i++){
        YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:i];
        if(i==selectCourseIndex){
            if([collectorInfo expandYN]){
                [collectorInfo setExpandYN:NO];
            }else{
                [collectorInfo setExpandYN:YES];
            }
        }else{
            [collectorInfo setExpandYN:NO];
        }
    }
    [self reloadData];
    
}

-(void)findCollector:(NSString *)CustomerNo setStatus:(NSString *)status{
    YYCollectorInfo *_temp;
    
    for (YYCollectorInfo *collectorInfo in _collectorInfos) {
        if([collectorInfo.CustomerNo isEqualToString:CustomerNo]){
            _temp=collectorInfo;
            break;
        }
    }
    [_temp setElectricsStatus:status];
}

-(YYCollectorInfo *)findSelectedCollectorInfo{
    YYCollectorInfo *_temp;
    
    for (YYCollectorInfo *collectorInfo in _collectorInfos) {
        if(collectorInfo.expandYN==YES){
            _temp=collectorInfo;
            break;
        }
    }
    return _temp;
}



-(void)groupExpand:(UIButton *)sender{
    [self reloadChildData:sender.tag];
}


-(void)reloadChildData:(int)selectCourseIndex{
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:selectCourseIndex];
   
    if([[_collectorInfos objectAtIndex:selectCourseIndex] expandYN]){
        [self reloadTableViewUI:selectCourseIndex];
        
    }else{
        [self reloadHistoryData:collectorInfo idx:collectorInfo.day selectIndex:selectCourseIndex switchYN:YES];
    }
    
}

-(void)reloadHistoryData:(YYCollectorInfo *)collectorInfo idx:(int)idx selectIndex:(int)selectCourseIndex switchYN:(BOOL)isSwitchYN{
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    [_hud.bezelView setColor:[UIColor clearColor]];
    [_hud.bezelView setStyle:MBProgressHUDBackgroundStyleSolidColor];
    [_hud showAnimated:YES];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //collectorInfo.historyDict=[[FService shareInstance] GetCollectorData:@"00-00-04-01" dateTime:@"2016-10-29"];
        collectorInfo.day=idx;
        
        collectorInfo.historyDict=[[FService shareInstance] GetCollectorData:collectorInfo.CustomerNo day:collectorInfo.day];
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_hud!=nil){
                 [_hud hideAnimated:YES];
            }
            if(isSwitchYN){
                [self reloadTableViewUI:selectCourseIndex];
            }else{
                [self reloadData];
            }
            
            if(collectorInfo.historyDict==nil||[collectorInfo.historyDict count]<=0){
                [[[UIApplication sharedApplication] keyWindow] makeToast:@"暂无历史数据"];
            }
            
            
        });
    });
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEAD_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

@end



@interface YYHistoryTableViewCell(){
    
}
@property(nonatomic,strong) MBProgressHUD *hud;
@end
@implementation YYHistoryTableViewCell



@end

