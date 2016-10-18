//
//  ExpandHistoryView.h
//  farmingFish
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
typedef void (^RealDataLoadBlock)(NSString *customNo);
@interface ExpandHistoryView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;
@property(nonatomic,weak) UIViewController *viewControllerDelegate;
@end

@interface YYHistoryTableViewCell : UITableViewCell


@end