//
//  ExpandSettingsView.h
//  farmingFish
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
@interface ExpandSettingsView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;

@end

