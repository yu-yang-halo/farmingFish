//
//  RealDataTableViewCell.h
//  farmingFish
//
//  Created by apple on 16/9/25.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStatusView.h"
@interface RealDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *propNameLabel;
@property (weak, nonatomic) IBOutlet YYStatusView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
