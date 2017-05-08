//
//  ExpandSettingsView.m
//  farmingFish
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import "ExpandSettingsView.h"


#import "ExpandRealDataView.h"
#import "YYButton.h"
#import "SocketService.h"
#import "UIView+Toast.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ParamsTableViewCell.h"
#import "FService.h"
#import "BeanObjectHelper.h"
#import "FService.h"
#define HEAD_HEIGHT 60
@interface ExpandSettingsView(){
//    NSArray<YYCollectorSensor *>* sensorList;
}
@end

@implementation ExpandSettingsView

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
        NSArray *sensorList=[[_collectorInfos objectAtIndex:section] sensorList];
        
        if(sensorList!=nil){
            return [sensorList count];
        }
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"paramsCell";
    
    ParamsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ParamsTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelected:NO];
    NSArray *sensorList=[[_collectorInfos objectAtIndex:indexPath.section] sensorList];
    YYCollectorSensor *senor=[sensorList objectAtIndex:indexPath.row];
    [cell setSensor:senor];
    

    
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    
    [cell.upperValueTF setText:[NSString stringWithFormat:@"%.1f",senor.F_Upper.floatValue]];
    
    [cell.lowerValueTF setText:[NSString stringWithFormat:@"%.1f",senor.F_Lower.floatValue]];
    
    [cell.nameLabel setText:senor.F_ParamText];
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
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:sender.tag] ;
    NSArray *sensorList=[collectorInfo sensorList];
    __block int flag=0;
    __block BOOL valueErr=NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.label.text =@"保存中...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (YYCollectorSensor *sensor in sensorList) {
            if(sensor.F_Upper!=nil&&sensor.F_UpperChange!=nil
               &&sensor.F_Lower!=nil&&sensor.F_LowerChange!=nil){
                
                
                
                if((sensor.F_Upper.floatValue!=sensor.F_UpperChange.floatValue)||(sensor.F_Lower.floatValue!=sensor.F_LowerChange.floatValue)){
                    
                    sensor.F_Upper=sensor.F_UpperChange;
                    sensor.F_Lower=sensor.F_LowerChange;
                    
                    
                    if(sensor.F_Upper.floatValue<sensor.F_Lower.floatValue){
                        
                        valueErr=YES;
                        
                        break;
                    }
                    
                    
                    flag++;
                    
                    [[FService shareInstance] SetCollectorSensor:collectorInfo.CollectorID sensorId:@"1" paramId:sensor.F_ID.intValue LowerValue:sensor.F_Lower.floatValue UpperValue:sensor.F_UpperChange.floatValue IsWarning:0];
                    
                    
                }
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if(valueErr){
                 [self.window makeToast:@"发现上限值小于下限值，请修改保存"];
                 return;
            }
            if(flag>0){
                [self.window makeToast:@"保存完成"];
            }else{
                [self.window makeToast:@"暂无修改，无需保存"];
            }
        });
        
    });
    
  
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

-(void)findCollector:(NSString *)DeviceId setStatus:(NSString *)status{
    YYCollectorInfo *_temp;
    
    for (YYCollectorInfo *collectorInfo in _collectorInfos) {
        if([collectorInfo.DeviceID isEqualToString:DeviceId]){
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
    
       
    [self reloadTableViewUI:selectCourseIndex];
    
    
}




-(void)groupExpand:(UIButton *)sender{
    if(![[_collectorInfos objectAtIndex:sender.tag] expandYN]){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:sender.tag];
            
            id obj=[[FService shareInstance] GetCollectorSensorList:collectorInfo.CollectorID sensorId:@"1" collectType:@"1"];
            
            id _sensors=[obj objectForKey:@"SensorList"];
            
            NSArray *sensorList=[BeanObjectHelper parseYYCollectorSensorList:_sensors];
            [collectorInfo setSensorList:sensorList];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //NSLog(@"%@",sensorList);
                
                [self reloadData];
                
                
            });
            
        });

    }
    
    
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

