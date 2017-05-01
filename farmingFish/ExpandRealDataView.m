//
//  MyExpandTableView.m
//  Openlab
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ExpandRealDataView.h"

#import "YYButton.h"
#import "SocketService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "CacheHelper.h"
#import "UIView+Toast.h"
#define HEAD_HEIGHT 40
@interface ExpandRealDataView(){
    int clickParentIndex;
}
@property(nonatomic,strong) RealDataLoadBlock block;
@property(nonatomic,strong) NSMutableDictionary *onlineTable;
@end
@implementation ExpandRealDataView

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


    
    self.onlineTable=[NSMutableDictionary new];
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
   
//    
//    [_realDataCache setObject:@[[NSString stringWithFormat:@"%@|%f|%f|%@",@"溶氧",8.0,20.0,@"mg/L"],[NSString stringWithFormat:@"%@|%f|%f|%@",@"Test",20.0,20.0,@"mg/L"]]  forKey:delegate.customerNo];

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
    RealDataTableView *realDataView;
    YYRealDataUITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[YYRealDataUITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        realDataView=[[RealDataTableView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width-0, 0)];
        
        [realDataView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [realDataView setSeparatorColor:[UIColor colorWithWhite:0.6 alpha:0.5]];
        
        
       
        [realDataView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        
        [cell addSubview:realDataView];
        [cell setRealDataTableView:realDataView];
        
    }
    
    realDataView=cell.realDataTableView;
    
    YYCollectorInfo *collector=[self findSelectedCollectorInfo];
   
    NSArray *realDatas=[CacheHelper fetchCacheRealDataFromDisk:collector.CustomerNo];
    
    if(realDataView!=nil&&realDatas!=nil){
        [cell hideLoading];
        [realDataView setRealDatas:realDatas];
        [realDataView reloadData];
        
        CGRect frame=realDataView.frame;
        frame.size.height=[realDatas count]*50;
        [realDataView setFrame:frame];
        CGRect frameCell=cell.frame;
        frameCell.size.height=frame.size.height+20;
        [cell setFrame:frameCell];
    }else{
        [cell showLoading];
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
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.1] forState:(UIControlStateNormal)];
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.2] forState:(UIControlStateHighlighted)];
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
//    
//    [self reloadSections:[NSIndexSet indexSetWithIndex:selectCourseIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    [self reloadData];

}


-(void)reloadChildData:(int)selectCourseIndex{
    YYCollectorInfo *collectorInfo=[_collectorInfos objectAtIndex:selectCourseIndex];
    
    if([[_collectorInfos objectAtIndex:selectCourseIndex] expandYN]){
        [self reloadTableViewUI:selectCourseIndex];
        [[SocketService shareInstance] disconnectAndClear];
    }else{
        [self reloadTableViewUI:selectCourseIndex];
    
   
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
                if(packet.cmdword!=0x03){
                   return ;
                }
            
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
                    
                    [CacheHelper cacheRealDataToDisk:realDataArr customNo:[dic objectForKey:@"customNo"]];
                    
                    [self.window makeToast:@"实时数据更新成功"];
                }
            
                [self reloadData];
            
            }];
    }
    
    
    
     NSLog(@" onlineTable  %@",_onlineTable);
    
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

@interface YYRealDataUITableViewCell(){
    
}
@property(nonatomic,strong) MBProgressHUD *hud;
@end
@implementation YYRealDataUITableViewCell

-(void)showLoading{
     self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [_hud.bezelView setColor:[UIColor clearColor]];
    [_hud.bezelView setStyle:MBProgressHUDBackgroundStyleSolidColor];
    [self setFrame:_hud.bounds];
}
-(void)hideLoading{
    if(_hud!=nil){
        [_hud hideAnimated:YES];
    }
}

@end
