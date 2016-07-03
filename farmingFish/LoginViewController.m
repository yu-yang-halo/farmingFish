//
//  ViewController.m
//  farmingFish
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "LoginViewController.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginClick:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    /*
     *  界面样式设置
     */
    self.loginButton.layer.cornerRadius=5;
    self.loginButton.layer.borderWidth=1;
    self.loginButton.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.6] CGColor];
    
    [self.loginButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
    
    
    
    UIColor *startColor = [UIColor uig_emeraldWaterStartColor];
    UIColor *endColor = [UIColor uig_emeraldWaterEndColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,1);
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick:(id)sender {
}
@end
