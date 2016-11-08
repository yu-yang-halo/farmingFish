//
//  DeviceControlTableViewCell.m
//  farmingFish
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "DeviceControlTableViewCell.h"

@implementation DeviceControlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.propStatusSwitch setOnImage:[UIImage imageNamed:@"switch_on"]];
    [self.propStatusSwitch setOffImage:[UIImage imageNamed:@"switch_off"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
