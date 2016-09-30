//
//  RealDataTableView.m
//  farmingFish
//
//  Created by apple on 16/9/25.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "RealDataTableView.h"
#import "RealDataTableViewCell.h"
@interface RealDataTableView()
{
    
}

@end
@implementation RealDataTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self!=nil){
        self.dataSource=self;
        self.delegate=self;
        [self setScrollEnabled:NO];
    }
    return self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_realDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RealDataTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"realDataCell"];
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RealDataTableViewCell" owner:nil options:nil] lastObject];
        
    }
    /*
     * 属性名称 当前值 最大值 单位
     */
    NSString *datas=[_realDatas objectAtIndex:indexPath.row];
    NSArray  *arrs=[datas componentsSeparatedByString:@"|"];
    
    if(arrs!=nil&&[arrs count]==4){
       
        cell.propNameLabel.text=arrs[0];
        
        cell.valueLabel.text=[NSString stringWithFormat:@"%.2f%@",[arrs[1] floatValue],arrs[3]];
        [cell.statusView setStatusValue:[arrs[1] floatValue]];
        [cell.statusView setMaxValue:[arrs[2] floatValue]];
        [cell.statusView startAnimation:YES];
    }
    [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
    [cell setUserInteractionEnabled:NO];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

@end
