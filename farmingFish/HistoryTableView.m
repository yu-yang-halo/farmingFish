//
//  HistoryTableView.m
//  farmingFish
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
#import <FSLineChart/FSLineChart.h>
#import <FSLineChart/UIColor+FSPalette.h>
#import "HistoryTableView.h"
#import "BeanObject.h"
#import "ConstansManager.h"
@interface HistoryTableView(){
    
}
@end
@implementation HistoryTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self!=nil){
        self.dataSource=self;
        self.delegate=self;
        [self setScrollEnabled:NO];
    }
    return self;
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:(UITableViewStylePlain)];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_historyDataDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYCell *cell=[tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    
    UIView *chartView;
    if(cell==nil){
        cell=[[YYCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"historyCell"];
        chartView=[self createChartView:indexPath];
        
       
        [cell addSubview:chartView];
         cell.chartView=chartView;
        
    }else{
        chartView=cell.chartView;
        
        [chartView removeFromSuperview];
         chartView=[self createChartView:indexPath];
        
        [cell addSubview:chartView];
         cell.chartView=chartView;
        
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView=[[UIView alloc] initWithFrame:cell.bounds];
    
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    [cell setSelectedBackgroundView:bgView];
    
    
    CGRect cellFrame=cell.frame;
    cellFrame.size.height=CGRectGetHeight(chartView.frame);
    cell.frame=cellFrame;
    
    return cell;
}

-(UIView *)createChartView:(NSIndexPath *)indexPath{
    UIView *containerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 220)];
    
    NSArray *xyArrs=[self convertChartViewData:indexPath];
    
    
    
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(30, 30, CGRectGetWidth([UIScreen mainScreen].bounds)-30, 170)];
    
    
    // Setting up the line chart
    lineChart.verticalGridStep =[xyArrs[0] count]/2;
    lineChart.horizontalGridStep =[xyArrs[1] count]/2 ;
    lineChart.fillColor = nil;
    lineChart.displayDataPoint = NO;
    lineChart.dataPointColor = [UIColor fsLightBlue];
    lineChart.dataPointBackgroundColor = [UIColor fsDarkBlue];
    lineChart.dataPointRadius = 2;
    lineChart.lineWidth=2;
    lineChart.innerGridLineWidth=0;
    lineChart.color = [lineChart.dataPointColor colorWithAlphaComponent:0.3];
    lineChart.valueLabelPosition = ValueLabelLeft;
    
    
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return xyArrs[0][item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.01f", value];
    };
    
    
    [lineChart setChartData:xyArrs[1]];
    
    
   
    [containerView addSubview:lineChart];
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(10,0,CGRectGetWidth([UIScreen mainScreen].bounds),30)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,10,CGRectGetWidth([UIScreen mainScreen].bounds),20)];
    
    [label setText:[NSString stringWithFormat:@"%@平均值（%.01f）",xyArrs[2],[xyArrs[3] floatValue]]];
    
    
    [label setTextColor:[UIColor fsDarkBlue]];
    [label setTextAlignment:(NSTextAlignmentLeft)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [contentView addSubview:label];
    
    [containerView addSubview:contentView];
   
    
    
    return containerView;
}

-(NSArray *)convertChartViewData:(NSIndexPath *)indexPath{
    NSArray *allValues=_historyDataDict.allValues;
    //NSArray *allKeys=_historyDataDict.allKeys;
    
    allValues=[allValues sortedArrayUsingComparator:^NSComparisonResult(NSArray*  _Nonnull obj1, NSArray *  _Nonnull obj2) {
        
       HistoryWantData *o1= [obj1 lastObject];
       HistoryWantData *o2= [obj2 lastObject];
       
        return o1.index-o2.index<0?NSOrderedAscending:NSOrderedDescending;
        
    }];
    
    
    
    NSArray<HistoryWantData *> *valueArr=allValues[indexPath.row];
    
    id key=@([[valueArr lastObject] detectType]);
    
    NSMutableArray *xArrs=[NSMutableArray new];
    NSMutableArray *yArrs=[NSMutableArray new];
    
    float avg=0.0;
    float sum=0.0;
    
    for (HistoryWantData *wantData in valueArr) {
        
        [xArrs addObject:[self timeFormat:wantData.time]];
        [yArrs addObject:@(wantData.value)];
        sum+=wantData.value;
    }
    
    NSString *title=[ConstansManager contentForKeyInt:key];
    NSLog(@"title %@",title);
    if([valueArr count]>0){
        avg=sum/[valueArr count];
    }
    
    return @[xArrs,yArrs, title,@(avg)];
}

-(NSString *)timeFormat:(int)time{
    //6 -> 06:00
    
    if(time<10){
        return [NSString stringWithFormat:@"0%d:00",time];
    }else{
        return [NSString stringWithFormat:@"%d:00",time];
    }
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end

@implementation YYCell


@end
