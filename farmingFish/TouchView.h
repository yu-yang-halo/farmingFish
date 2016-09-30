//
//  TouchView.h
//  farmingFish
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"
@interface TouchView : UIView
@property(nonatomic,weak) id<PTZDelegate> ptzDelegate;
@end
