//
//  MainViewController.m
//  farmingFish
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "MainViewController.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
#import "UIColor+hexStr.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deviceMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *myVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *realDataButton;
@property (weak, nonatomic) IBOutlet UIButton *historyDataButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.title=@"主页";
    
    
    
    UIColor *startColor = [UIColor uig_emeraldWaterStartColor];
    UIColor *endColor = [UIColor uig_emeraldWaterEndColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,1);
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    [self buttonStyleInit];


}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)buttonStyleInit{
    /*
        我的设备button 样式 EDE41A
     */
    [self styleInitToButton:_deviceMenuButton data:@{@"backgroundColor":@"EDE41A",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    /*
     我的视频button 样式
     */
    [self styleInitToButton:_myVideoButton data:@{@"backgroundColor":@"68E668",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    /*
     实时数据button 样式
     */
    [self styleInitToButton:_realDataButton data:@{@"backgroundColor":@"2194ED",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    /*
     历史数据button 样式
     */
    [self styleInitToButton:_historyDataButton data:@{@"backgroundColor":@"F55959",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    
}

-(void)styleInitToButton:(UIButton *)button data:(NSDictionary *)dic{
    button.layer.cornerRadius=_deviceMenuButton.frame.size.width/2;
    button.layer.backgroundColor=[[UIColor colorWithHexString:[dic objectForKey:@"backgroundColor"]] CGColor];
    
    button.layer.borderColor=[[UIColor colorWithHexString:[dic objectForKey:@"borderColor"]] CGColor];
    button.layer.borderWidth=1;
    
    button.layer.shadowColor=[[UIColor colorWithHexString:[dic objectForKey:@"shadowColor"]] CGColor];
    button.layer.shadowRadius=5;
    // 设置layer的透明度
    button.layer.shadowOpacity = 1.0f;
    button.layer.shadowOffset=CGSizeMake(0,1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
