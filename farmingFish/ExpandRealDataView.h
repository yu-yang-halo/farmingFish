//
//  MyExpandTableView.h
//  Openlab
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
#import "RealDataTableView.h"
typedef void (^RealDataLoadBlock)(NSString *customNo);
@interface ExpandRealDataView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;
@property(nonatomic,weak) UIViewController *viewControllerDelegate;

@end


@interface YYRealDataUITableViewCell : UITableViewCell

@property(nonatomic,strong) RealDataTableView *realDataTableView;
-(void)showLoading;
-(void)hideLoading;
@end
