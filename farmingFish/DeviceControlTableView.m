//
//  DeviceControlTableView.m
//  farmingFish
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "DeviceControlTableView.h"
#import "DeviceControlTableViewCell.h"
#import "SocketService.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
@interface DeviceControlTableView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *customerNo;
@end

@implementation DeviceControlTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self!=nil){
        self.dataSource=self;
        self.delegate=self;
        [self setScrollEnabled:NO];
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        
        self.customerNo=delegate.customerNo;
        
        
    }
    return self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_deviceDatas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceControlTableViewCell *deviceControlCell=[tableView dequeueReusableCellWithIdentifier:@"deviceControlCell"];
    if(deviceControlCell==nil){
        deviceControlCell=[[[NSBundle mainBundle] loadNibNamed:@"DeviceControlTableViewCell" owner:nil options:nil] lastObject];
    }
    deviceControlCell.propSwitch.tag=indexPath.row;
    deviceControlCell.propNameLabel.text=[_deviceDatas objectAtIndex:indexPath.row];
    
    if(_realStatus!=nil&&_realStatus.length==8){
        int status=[[_realStatus substringWithRange:NSMakeRange(indexPath.row, 1)] intValue];
        
        if(status==1){
            [deviceControlCell.propSwitch setSelected:YES];
        }else{
            [deviceControlCell.propSwitch setSelected:NO];
        }

    }else{
        [deviceControlCell.propSwitch setSelected:NO];
    }
    


    [deviceControlCell.propSwitch addTarget:self action:@selector(swOnOff:) forControlEvents:UIControlEventTouchUpInside];
    
    [deviceControlCell setUserInteractionEnabled:YES];
    UIView *selectedBGView=[[UIView alloc] initWithFrame:deviceControlCell.bounds];
    
    [selectedBGView setBackgroundColor:[UIColor clearColor]];
    
    [deviceControlCell setSelectedBackgroundView:selectedBGView];
    [deviceControlCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return deviceControlCell;
}

-(void)swOnOff:(UIButton *)sender{
    
    if(_collectorInfo.mode==MODE_TYPE_AUTO){
        if(sender.tag<5){
            [self.window makeToast:@"处于自动模式,无法手动控制"];
            return;
        }
        
    }
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    [delegate setOnlyFirst:YES];
    [delegate showLoading:@"设置中..."];
    if(sender.isSelected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    [[SocketService shareInstance] sendControlCmd:sender.isSelected number:sender.tag+1 devId:_customerNo];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
