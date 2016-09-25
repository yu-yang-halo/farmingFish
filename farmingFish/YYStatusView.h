//
//  YYStatusView.h
//  farmingFish
//
//  Created by apple on 16/9/24.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYStatusView : UIView
@property(nonatomic,assign) float statusValue;
@property(nonatomic,assign) float maxValue;

-(void)startAnimation;
@end
