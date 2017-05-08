//
//  ExpandControlView.m
//  farmingFish
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "ExpandControlView.h"

#import "ExpandRealDataView.h"
#import "YYButton.h"
#import "SocketService.h"
#import "UIView+Toast.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#define HEAD_HEIGHT 40

@interface ExpandControlView(){
   
}
@property(nonatomic,strong) RealDataLoadBlock block;

@end
@implementation ExpandControlView

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
    DeviceControlTableView *devControlView;
    YYControlDataUITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if(cell==nil){
        cell=[[YYControlDataUITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell2"];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        devControlView=[[DeviceControlTableView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width-0, 0)];
        [devControlView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

        [devControlView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.0]];
       
        [cell addSubview:devControlView];
         cell.controlDataTableView=devControlView;
    }
    devControlView=cell.controlDataTableView;
    
    if(devControlView!=nil){
        [devControlView setDeviceDatas:collectorInfo.electricsArr];
        [devControlView setRealStatus:collectorInfo.electricsStatus];
        [devControlView setCollectorInfo:collectorInfo];
        
        [devControlView reloadData];
        
        CGRect frame=devControlView.frame;
        frame.size.height=[collectorInfo.electricsArr count]*50;
        [devControlView setFrame:frame];
        CGRect frameCell=cell.frame;
        frameCell.size.height=frame.size.height+20;
        [cell setFrame:frameCell];
    }
    UIView *selectedBGView=[[UIView alloc] initWithFrame:cell.bounds];
    
    [selectedBGView setBackgroundColor:[UIColor clearColor]];
    
    [cell setSelectedBackgroundView:selectedBGView];
    

    

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

-(void)findCollector:(NSString *)DeviceId setMode:(int)mode{
    YYCollectorInfo *_temp;
    
    for (YYCollectorInfo *collectorInfo in _collectorInfos) {
        if([collectorInfo.DeviceID isEqualToString:DeviceId]){
            _temp=collectorInfo;
            break;
        }
    }
    [_temp setMode:mode];
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
    
        [[SocketService shareInstance] connect:collectorInfo.DeviceID];
        [[SocketService shareInstance] setOnlineStatusBlock:^(BOOL onlineYN,NSString *DeviceId) {
            
            if(onlineYN){
                //@"实时数据";
                NSLog(@"%@ online",DeviceId);
            }else{
                //@"实时数据(离线)";
                NSLog(@"%@ offline",DeviceId);
            }
            
        }];
        
        [[SocketService shareInstance] setStatusBlock:^(YYPacket *packet) {
            NSDictionary *dic=[packet dict];
            
            if(packet.cmdword==0x15){
                id modeObj=[dic objectForKey:@"mode"];
                
                if(modeObj!=nil){
                    [self findCollector:packet.deviceAddress setMode:[modeObj intValue]];
                }
                return ;
            }
            
            if(packet.cmdword!=0x03&&packet.cmdword!=0x0F){
                return ;
            }
            
            NSLog(@"%@",dic);
            __block NSString *mStatus=nil;
            __block NSString *deviceId=nil;
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                
                 if([key isKindOfClass:[NSString class]]){
                    if([key isEqualToString:@"status"]){
                        mStatus=obj;
                    }else if ([key isEqualToString:@"DeviceId"]){
                        deviceId=obj;
                    }
                }
                
            }];
           
            if(packet.cmdword==0x0F){
                AppDelegate *delegate=[UIApplication sharedApplication].delegate;
                
                [delegate hide];

                
            }
            
            [self findCollector:deviceId setStatus:mStatus];

            [self reloadData];
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

@implementation YYControlDataUITableViewCell


@end
