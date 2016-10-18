//
//  ExpandHistoryView.m
//  farmingFish
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "ExpandHistoryView.h"

#import "UIButton+BGColor.h"
#import "SocketService.h"
#import <MBProgressHUD/MBProgressHUD.h>
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
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     * 显示子节点数据
     */
    YYCollectorInfo *collectorInfo=[self findSelectedCollectorInfo];
    
    return nil;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    /*
     *显示父节点数据
     */
    
    
    UIButton *backgroundView=[[UIButton alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width, HEAD_HEIGHT)];
    
    [backgroundView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backgroundView setTag:section];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2] forState:(UIControlStateNormal)];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1] forState:(UIControlStateHighlighted)];
    [backgroundView addTarget:self action:@selector(groupExpand:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,(HEAD_HEIGHT-9)/2,16,9)];
    
    
    
    if(![[_collectorInfos objectAtIndex:section] expandYN]){
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
    }else{
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
    }
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70,0,250,HEAD_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor colorWithWhite:0 alpha:0.5]];
    label.text=[[_collectorInfos objectAtIndex:section] CustomerNo];
    
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


@implementation YYHistoryTableViewCell


@end

