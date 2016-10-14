//
//  TouchView.h
//  farmingFish
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"
@interface YYVideoView : UIView

@property(nonatomic,weak) id<PlayDelegate> playDelegate;
@property(nonatomic,assign) BOOL isVaildYN;

@end
