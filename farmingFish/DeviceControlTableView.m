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
    deviceControlCell.propStatusSwitch.tag=indexPath.row;
    
    deviceControlCell.propNameLabel.text=[_deviceDatas objectAtIndex:indexPath.row];
    
    if(_realStatus!=nil&&_realStatus.length==8){
        int status=[[_realStatus substringWithRange:NSMakeRange(indexPath.row, 1)] intValue];
        
        if(status==1){
            [deviceControlCell.propStatusSwitch setOn:YES];
        }else{
            [deviceControlCell.propStatusSwitch setOn:NO];
        }

    }else{
         [deviceControlCell.propStatusSwitch setOn:NO];
    }
    
    [deviceControlCell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
    
    UIView *bgView=[[UIView alloc] initWithFrame:deviceControlCell.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [deviceControlCell setSelectedBackgroundView:bgView];
    
    [deviceControlCell.propStatusSwitch addTarget:self action:@selector(swOnOff:) forControlEvents:UIControlEventValueChanged];
    return deviceControlCell;
}

-(void)swOnOff:(UISwitch *)sender{
     NSLog(@"ON : %d",sender.on);
    
    [[SocketService shareInstance] sendControlCmd:sender.on number:sender.tag+1 devId:_customerNo];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
