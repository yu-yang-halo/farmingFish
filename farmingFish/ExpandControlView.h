//
//  ExpandControlView.h
//  farmingFish
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
#import "DeviceControlTableView.h"
typedef void (^RealDataLoadBlock)(NSString *customNo);
@interface ExpandControlView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;
@property(nonatomic,weak) UIViewController *viewControllerDelegate;
@end
@interface YYControlDataUITableViewCell : UITableViewCell

@property(nonatomic,strong) DeviceControlTableView *controlDataTableView;

@end