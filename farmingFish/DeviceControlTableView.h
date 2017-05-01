//
//  DeviceControlTableView.h
//  farmingFish
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
@interface DeviceControlTableView : UITableView

@property(nonatomic,strong) NSArray      *deviceDatas;
@property(nonatomic,strong) NSString     *realStatus;//@"10000000"
@property(nonatomic,strong) YYCollectorInfo *collectorInfo;



@end
