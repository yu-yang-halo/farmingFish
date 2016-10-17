//
//  UIViewController+BGColor.m
//  farmingFish
//
//  Created by apple on 16/9/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
@implementation UIViewController (BGColor)
-(void)viewControllerBGInit{
    
    [self setViewBGColor:self.view];

}
-(void)setViewBGColor:(UIView *)_mView{
    
    UIColor *startColor = [UIColor uig_lemonTwistStartColor];
    UIColor *endColor = [UIColor uig_lemonTwistEndColor];
    //uig_lemonTwistStartColor
    //uig_lemonTwistEndColor
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
    
    [UIView animateWithDuration:0.2 animations:^{
        logoView.bounds=CGRectMake(0, 0, 80,80);
        logoView.center=containerView.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            logoView.bounds=CGRectMake(0, 0,1000, 1000);
            logoView.center=containerView.center;
            logoView.alpha=0.0;
        } completion:^(BOOL finished) {
            [logoView removeFromSuperview];
            [containerView removeFromSuperview];
            
        }];
        
        
    }];

    
    
    
    
    
    
}

@end

@implementation UIViewController (NavigationBar)

-(void)navigationBarInit{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"alph0"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end