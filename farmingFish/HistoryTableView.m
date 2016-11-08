//
//  HistoryTableView.m
//  farmingFish
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
#import <PNChart/PNChart.h>
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
    
    
    CGRect cellFrame=cell.frame;
    cellFrame.size.height=CGRectGetHeight(chartView.frame);
    cell.frame=cellFrame;
    
    return cell;
}

-(UIView *)createChartView:(NSIndexPath *)indexPath{
    UIView *containerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0)];
    
    NSArray *xyArrs=[self convertPNChartData:indexPath];
    

    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 200.0)];
    lineChart.xLabelColor=[UIColor whiteColor];
    lineChart.yLabelColor=[UIColor whiteColor];
    lineChart.xLabelFont=[UIFont systemFontOfSize:9];
    
    
    lineChart.yLabelFormat = @"%1.1f";
    lineChart.backgroundColor = [UIColor clearColor];
    [lineChart setXLabels:xyArrs[0]];
    lineChart.showCoordinateAxis = YES;
    
    // added an examle to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    lineChart.yGridLinesColor = [UIColor clearColor];
    lineChart.showYGridLines = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    NSArray *allKeys=_historyDataDict.allKeys;
    
    id key=allKeys[indexPath.row];
    
    NSArray *maxAndMinArr=[ConstansManager maxWithMinRange:key];
    
    NSArray *yLabels=[ConstansManager yAxisRange:key];

    
    lineChart.yFixedValueMax = [maxAndMinArr[0] floatValue];
    lineChart.yFixedValueMin = [maxAndMinArr[1] floatValue];
    
    
    
    [lineChart setYLabels:yLabels];
    

    // Line Chart #2
    NSArray * data02Array = xyArrs[1];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle =[NSString stringWithFormat:@"(%@%@)/(时)",xyArrs[2]
     ,[ConstansManager unitForKeyString:key]];
    
    data02.color = PNTwitterColor;
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data02];
    [lineChart strokeChart];
    //lineChart.delegate = self;

    
    lineChart.legendStyle = PNLegendItemStyleStacked;
    lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    lineChart.legendFontColor = [UIColor whiteColor];
    
    UIView *legend = [lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(30, 200, legend.frame.size.width, legend.frame.size.height+30)];
    
    
    [containerView addSubview:lineChart];
    
    [containerView addSubview:legend];
    
    containerView.frame=CGRectMake(0, 0,SCREEN_WIDTH,CGRectGetMaxY(legend.frame));
    

    return containerView;
}

-(NSArray *)convertPNChartData:(NSIndexPath *)indexPath{
    NSArray *allValues=_historyDataDict.allValues;
    NSArray *allKeys=_historyDataDict.allKeys;
    
    id key=allKeys[indexPath.row];
    
    NSArray<HistoryWantData *> *valueArr=allValues[indexPath.row];
    
    NSMutableArray *xArrs=[NSMutableArray new];
    NSMutableArray *yArrs=[NSMutableArray new];
    
    
    for (HistoryWantData *wantData in valueArr) {
        [xArrs addObject:[NSString stringWithFormat:@"%d",wantData.time]];
        [yArrs addObject:[NSString stringWithFormat:@"%f",wantData.value]];
    }
    
    NSString *title=[ConstansManager contentForKeyInt:key];
    NSLog(@"title %@",title);
    
    return @[xArrs,yArrs, title];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end

@implementation YYCell


@end
