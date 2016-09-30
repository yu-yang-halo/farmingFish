//
//  VideoViewController.h
//  farmingFish
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTZDelegate <NSObject>

-(void)ptzControl:(int)channel ptzDirect:(int)pd;

@end

@interface VideoViewController : UIViewController<PTZDelegate>
@property(nonatomic,strong) NSDictionary *videoInfo;
- (void)previewPlay:(int*)iPlayPort playView:(UIView*)playView;
- (void)stopPreviewPlay:(int*)iPlayPort;



@end
