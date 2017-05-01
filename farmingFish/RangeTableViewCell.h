//
//  RangeTableViewCell.h
//  farmingFish
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
@interface RangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *lowerTF;
@property (weak, nonatomic) IBOutlet UITextField *upperTF;
@property (weak, nonatomic) IBOutlet UILabel *modeText;

@property(nonatomic,strong) YYCollectorInfo *collectorInfo;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@end
