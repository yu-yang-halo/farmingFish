//
//  UIViewController+BGColor.m
//  farmingFish
//
//  Created by apple on 16/9/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
#import "UIColor+hexStr.h"
@implementation UIViewController (Extension)


-(void)viewWillAppear:(BOOL)animated{

    [self navigationBarInit];
}






-(void)viewControllerBGInit{
    [self setViewBGColor:self.view];
}
-(void)viewControllerBGInit:(UIView *)view{
    [self setViewBGColor:view];
}
-(void)setViewBGColor:(UIView *)_mView{
    
    UIColor *startColor = [UIColor colorWithHexString:@"#3CE6FF"];
    UIColor *endColor = [UIColor colorWithHexString:@"#2F89FF"];
        
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =_mView.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0,1);
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
        
    [_mView.layer insertSublayer:gradient atIndex:0];
    
}

/*
 * 导航栏实现渐变色
 * 利用Debug->View Debuging->Capture View Hierarchy
 * 查看NavigationBar的视图层级关系
 * 很容易发现NavigationBar也是由一些子视图组成的
 * 我们只需要加入一个背景子视图并放置到最顶端就可以了
 */



-(void)navigationBarInit:(UINavigationBar *)bar{
    
    
    [self setNavigationBar:bar];
    
    UIColor * color = [UIColor whiteColor];
    [bar setTintColor:color];
    
    NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:23],NSFontAttributeName,color, NSForegroundColorAttributeName,nil];
    bar.titleTextAttributes = dict;
}
-(void)navigationBarInit{
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:nil action:nil];
    UINavigationBar *bar=nil;
    if(self.tabBarController==nil){
        bar=self.navigationController.navigationBar;
    }else{
        bar=self.tabBarController.navigationController.navigationBar;
    }
    
    
    
    
    [self navigationBarInit:bar];
    
     
}
-(void)setNavigationBar:(UIView *)bar{
         UIView *subView=nil;
         for (UIView *v in [bar subviews] ) {
             if(v.tag==1002){
                 subView=v;
                 break;
             }
         }
         if(subView==nil){
             subView=[[UIView alloc] initWithFrame:bar.bounds];
             [subView setUserInteractionEnabled:NO];
             [subView setTag:1002];
             UIColor *startColor = [UIColor colorWithHexString:@"#3CE6FF"];
             UIColor *endColor = [UIColor colorWithHexString:@"#2F89FF"];
             
             CAGradientLayer *gradient = [CAGradientLayer layer];
             gradient.frame =bar.bounds;
             gradient.startPoint = CGPointMake(0, 0);
             gradient.endPoint = CGPointMake(1,1);
             gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
             
             [subView.layer insertSublayer:gradient atIndex:0];
             [bar insertSubview:subView atIndex:0];
             
         }
         
         [bar sendSubviewToBack:subView];
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

