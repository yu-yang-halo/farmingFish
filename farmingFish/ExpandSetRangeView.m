//
//  ExpandSetRangeView.m
//  farmingFish
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import "ExpandSetRangeView.h"
#import "YYButton.h"
#import "SocketService.h"
#import "UIView+Toast.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RangeTableViewCell.h"
#import "AppDelegate.h"
#define HEAD_HEIGHT 60


@implementation ExpandSetRangeView

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
    static NSString *identifier=@"rangeCell";
    
    RangeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RangeTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelected:NO];
    
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:indexPath.row] ;
    
    [cell setCollectorInfo:collectorInfo];

    [cell.upperTF setText:[NSString stringWithFormat:@"%d",[collectorInfo upperValue]]];
    [cell.lowerTF setText:[NSString stringWithFormat:@"%d",[collectorInfo lowerValue]]];
    
    [cell.timeTF setText:[NSString stringWithFormat:@"%d",[collectorInfo time]]];
    
    if(collectorInfo.mode==MODE_TYPE_AUTO){
        [cell.modeText setText:@"自动"];
         [cell.modeSwitch setOn:YES];
    }else{
        [cell.modeText setText:@"手动"];
        [cell.modeSwitch setOn:NO];
    }
    

    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    
    
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    /*
     *显示父节点数据
     */
    
    
    YYButton *backgroundView=[[YYButton alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width, HEAD_HEIGHT)];
    
    [backgroundView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundView setTag:section];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.1] forState:(UIControlStateNormal)];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.2] forState:(UIControlStateHighlighted)];
    
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
    
    [label setTextColor:[UIColor colorWithWhite:0 alpha:0.5]];
    label.text=[[_collectorInfos objectAtIndex:section] PondName];
    
    
    [backgroundView addSubview:arrowImageView];
    [backgroundView addSubview:label];
    
    UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-75,(HEAD_HEIGHT-35)/2,70, 35)];
    [saveBtn setTag:section];
  
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
     [saveBtn setTitleColor:[UIColor colorWithRed:0 green:138/255.0 blue:214/255.0 alpha:0.9] forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:[UIColor colorWithRed:0 green:138/255.0 blue:214/255.0 alpha:0.1] forState:(UIControlStateHighlighted)];
    
    [saveBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [saveBtn addTarget:self action:@selector(saveData:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [backgroundView addSubview:saveBtn];
    
    
    
    return backgroundView;
}
-(void)saveData:(UIButton *)sender{
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:sender.tag];
    
    BOOL rangeChange=NO;
    BOOL timeChange=NO;
    
    if(collectorInfo.upperValueChange<collectorInfo.lowerValueChange){
        [self.window makeToast:@"设置的上限值必须大于下限值"];
    }else{
        
        if(collectorInfo.upperValueChange!=-1||collectorInfo.lowerValueChange!=-1){
            
            if(collectorInfo.upperValueChange!=collectorInfo.upperValue||
               collectorInfo.lowerValueChange!=collectorInfo.lowerValue){
                
                collectorInfo.upperValue=collectorInfo.upperValueChange;
                collectorInfo.lowerValue=collectorInfo.lowerValueChange;
                
                rangeChange=YES;
                
                
                
            }

        }
        
        if(collectorInfo.timeChange!=-1){
            if(collectorInfo.time!=collectorInfo.timeChange){
                collectorInfo.time=collectorInfo.timeChange;
                timeChange=YES;
               
            }

        }
        
        if(timeChange||rangeChange){
            AppDelegate *delegate=[UIApplication sharedApplication].delegate;
            [delegate setOnlyFirst:YES];
            [delegate showLoading:@"保存中..."];
            if(timeChange){
                [[SocketService shareInstance] autoStartTime:MethodType_POST time:collectorInfo.time devId:collectorInfo.CustomerNo];
            }
            if(rangeChange){
                 [[SocketService shareInstance] rangSetOrGet:MethodType_POST max:collectorInfo.upperValue min:collectorInfo.lowerValue devId:collectorInfo.CustomerNo];
            }
            
        }else{
             [self.window makeToast:@"暂无修改,无需保存"];
        }
        
       
        
    }
    
    
    
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


-(void)reloadChildData:(int)selectCourseIndex{
    
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:selectCourseIndex];
    
    if([[_collectorInfos objectAtIndex:selectCourseIndex] expandYN]){
        [[SocketService shareInstance] disconnectAndClear];
    }else{
        
        [[SocketService shareInstance] connect:[[_collectorInfos objectAtIndex:selectCourseIndex] CustomerNo]];
        
        [[SocketService shareInstance] setStatusBlock:^(YYPacket *packet) {
              NSDictionary *dic=[packet dict];
              id maxObj=[dic objectForKey:@"max"];
              id minObj=[dic objectForKey:@"min"];
              id modeObj=[dic objectForKey:@"mode"];
              id timeObj=[dic objectForKey:@"time"];
              AppDelegate *delegate=[UIApplication sharedApplication].delegate;
              if(maxObj!=nil&&minObj!=nil){
                
                  [[_collectorInfos objectAtIndex:selectCourseIndex] setUpperValue:[maxObj intValue]];
                  [[_collectorInfos objectAtIndex:selectCourseIndex] setLowerValue:[minObj intValue]];
                 [self reloadData];
                  if(packet.flag==0x82){
                      [delegate hideNoMessage];
                      [self.window makeToast:@"阈值保存成功"];
                  }
                  
              }
            
            if(modeObj!=nil){
                [[_collectorInfos objectAtIndex:selectCourseIndex] setMode:[modeObj intValue]];
                [self reloadData];
                
                if(packet.flag==0x82){
                    [delegate hideNoMessage];
                    [self.window makeToast:@"模式设置成功"];
                }
                
            }
            if (timeObj!=nil) {
                [[_collectorInfos objectAtIndex:selectCourseIndex] setTime:[timeObj intValue]];
                [self reloadData];
                if(packet.flag==0x82){
                     [delegate hideNoMessage];
                    [self.window makeToast:@"时间保存成功"];
                }
            }
        }];
        
    }
    
    
    [self reloadTableViewUI:selectCourseIndex];
    
    
    
}




-(void)groupExpand:(UIButton *)sender{
    [self reloadChildData:sender.tag];
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


