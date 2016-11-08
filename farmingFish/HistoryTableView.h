//
//  HistoryTableView.h
//  farmingFish
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSDictionary *historyDataDict;

@end

@interface YYCell : UITableViewCell
@property(nonatomic,weak) UIView *chartView;
@end
