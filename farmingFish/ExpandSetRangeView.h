//
//  ExpandSetRangeView.h
//  farmingFish
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"

@interface ExpandSetRangeView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray<YYCollectorInfo *> *collectorInfos;

@end
