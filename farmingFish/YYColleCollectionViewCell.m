//
//  YYColleCollectionViewCell.m
//  farmingFish
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYColleCollectionViewCell.h"

#import "UIColor+hexStr.h"

@implementation YYColleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.layer.borderColor=[UIColor whiteColor].CGColor;
    self.layer.borderWidth=0.5;
}


@end
