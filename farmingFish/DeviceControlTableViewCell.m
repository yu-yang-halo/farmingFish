//
//  DeviceControlTableViewCell.m
//  farmingFish
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "DeviceControlTableViewCell.h"
#import "UIColor+hexStr.h"
@implementation DeviceControlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.propSwitch.layer setCornerRadius:3];
    [self.propSwitch setTitle:@"开" forState:(UIControlStateSelected)];
    [self.propSwitch setTitle:@"关" forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
