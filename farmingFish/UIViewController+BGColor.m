//
//  UIViewController+BGColor.m
//  farmingFish
//
//  Created by apple on 16/9/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "UIViewController+BGColor.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
@implementation UIViewController (BGColor)
-(void)viewControllerBGInit{
    
    [self setViewBGColor:self.view];

}
-(void)setViewBGColor:(UIView *)_mView{
    
    UIColor *startColor = [UIColor uig_emeraldWaterStartColor];
    UIColor *endColor = [UIColor uig_emeraldWaterEndColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =_mView.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,1);
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    
    [_mView.layer insertSublayer:gradient atIndex:0];
    
}
-(void)flyIconToFace{
    CGRect bounds=self.view.bounds;
    UIView *containerView=[[UIView alloc] initWithFrame:bounds];
    
    [self setViewBGColor:containerView];
    
    
    UIImageView *logoView=[[UIImageView alloc] initWithFrame:CGRectMake((bounds.size.width-80)/2, (bounds.size.height-80)/2, 80, 80)];
    [logoView setImage:[UIImage imageNamed:@"logo"]];
    
    
    [containerView addSubview:logoView];
    
    [self.view addSubview:containerView];
    
    
    
    [UIView animateWithDuration:1.2 animations:^{
        logoView.bounds=CGRectMake(0, 0,1000, 1000);
        logoView.center=containerView.center;
        logoView.alpha=0.0;
    } completion:^(BOOL finished) {
        [logoView removeFromSuperview];
        [containerView removeFromSuperview];
        
    }];
    
    
    
}

@end