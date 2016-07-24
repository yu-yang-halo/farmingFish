//
//  VideoViewController.h
//  farmingFish
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VideoViewController : BaseViewController
- (void)previewPlay:(int*)iPlayPort playView:(UIView*)playView;
- (void)stopPreviewPlay:(int*)iPlayPort;
@end
