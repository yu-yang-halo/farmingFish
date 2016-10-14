//
//  MyExpandTableView.m
//  Openlab
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "MyExpandTableView.h"

#import "UIButton+BGColor.h"
#import "SocketService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#define HEAD_HEIGHT 40
@interface MyExpandTableView(){
    int clickParentIndex;
}
@property(nonatomic,strong) RealDataLoadBlock block;
@property(nonatomic,strong) NSMutableDictionary *realDataCache;
@property(nonatomic,strong) NSMutableDictionary *onlineTable;
@end
@implementation MyExpandTableView

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
    
    self.realDataCache=[NSMutableDictionary new];
    self.onlineTable=[NSMutableDictionary new];
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
    RealDataTableView *realDataView;
    YYRealDataUITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[YYRealDataUITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        realDataView=[[RealDataTableView alloc] initWithFrame:CGRectMake(10,10, cell.frame.size.width-20, 0)];
        
        realDataView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.1] CGColor];
        realDataView.separatorColor=[UIColor colorWithWhite:1 alpha:0.3];
        
        realDataView.layer.borderWidth=1;
        realDataView.layer.cornerRadius=2;
        [realDataView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.1]];
        
        [cell addSubview:realDataView];
        [cell setRealDataTableView:realDataView];
        
    }
    
    realDataView=cell.realDataTableView;
    
    YYCollectorInfo *collector=[self findSelectedCollectorInfo];
    NSArray *realDatas=[_realDataCache objectForKey:collector.CustomerNo];
    
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
    return cell;
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
    
    UIImageView *arrowImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,(HEAD_HEIGHT-6)/2,13,6)];
    
   
    
    if(![[_collectorInfos objectAtIndex:section] expandYN]){
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
    }else{
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
    }
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70,0,250,HEAD_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor colorWithWhite:0 alpha:0.6]];
    label.text=[[_collectorInfos objectAtIndex:section] CustomerNo];
   
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
        [[SocketService shareInstance] disconnect];
    }else{
        [self reloadTableViewUI:selectCourseIndex];
   
        [[SocketService shareInstance] connect:collectorInfo.CustomerNo];
            
        [[SocketService shareInstance] setOnlineStatusBlock:^(BOOL onlineYN,NSString *customerNO) {
                
                if(onlineYN){
                    //@"实时数据";
                    NSLog(@"%@ online",customerNO);
                }else{
                    //@"实时数据(离线)";
                    NSLog(@"%@ offline",customerNO);
                }
                
            }];
            
        [[SocketService shareInstance] setStatusBlock:^(NSDictionary *dic) {
                
                NSLog(@"%@",dic);
                NSMutableArray *realDataArr=[NSMutableArray new];
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    if([key isKindOfClass:[NSNumber class]]){
                        /*
                         * 属性名称 当前值 最大值 单位 filter
                         */
                        NSArray* contents=[obj componentsSeparatedByString:@"|"];
                        if(contents!=nil&&[contents count]==4){
                            [realDataArr addObject:obj];
                        }
                    }else if([key isKindOfClass:[NSString class]]){
                        
                    }
                    
                }];
                
                if(realDataArr!=nil&&[realDataArr count]>0){
                    [_realDataCache setObject:realDataArr forKey:[dic objectForKey:@"customNo"]];
                }
                
//               [self reloadSections:[NSIndexSet indexSetWithIndex:selectCourseIndex] withRowAnimation:UITableViewRowAnimationFade];
//               
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
