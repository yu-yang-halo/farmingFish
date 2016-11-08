//
//  ExpandHistoryView.h
//  farmingFish
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
#import "HistoryTableView.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "WeatherShowManager.h"
typedef void (^RealDataLoadBlock)(NSString *customNo);
@interface ExpandHistoryView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;
@property(nonatomic,weak) UIViewController *viewControllerDelegate;
@end

@interface YYHistoryTableViewCell : UITableViewCell

@property(nonatomic,weak) HistoryTableView *historyTableView;
@property(nonatomic,strong) WeatherShowManager *viewManager;
@property(nonatomic,weak) UIView *weatherView;
@property(nonatomic,weak) HMSegmentedControl *segmentedControl;
@property(nonatomic,weak) UIView *headerView;

@end
