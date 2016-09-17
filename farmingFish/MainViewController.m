//
//  MainViewController.m
//  farmingFish
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+hexStr.h"
#import "UIViewController+BGColor.h"
#import "VideoViewController.h"
@interface MainViewController (){
    NSArray *items;
}
@property (strong, nonatomic)  UIButton *deviceMenuButton;
@property (strong, nonatomic)  UIButton *myVideoButton;
@property (strong, nonatomic)  UIButton *realDataButton;
@property (strong, nonatomic)  UIButton *historyDataButton;
@property (strong, nonatomic)  UIImageView *logoView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"主页";
    items=@[@"我的设备",@"我的视频",@"实时数据",@"历史数据"];
    //初始化页面背景色
    [self viewControllerBGInit];
    [self buttonStyleInit];
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self animationStart];

}

-(void)animationStart{
    //加点动画效果
    CGRect devFrame=_deviceMenuButton.frame;
    CGRect videoFrame=_myVideoButton.frame;
    CGRect realDataFrame=_realDataButton.frame;
    CGRect hisDataFrame=_historyDataButton.frame;
    CGRect logoFrame=_logoView.frame;
    
    CGFloat alpha_0=0.0;
    CGFloat alpha_1=1.0;
    
    [UIView animateWithDuration:0.02 animations:^{
        _deviceMenuButton.frame=logoFrame;
        _myVideoButton.frame=logoFrame;
        _realDataButton.frame=logoFrame;
        _historyDataButton.frame=logoFrame;
        
        _deviceMenuButton.alpha=alpha_0;
        _myVideoButton.alpha=alpha_0;
        _realDataButton.alpha=alpha_0;
        _historyDataButton.alpha=alpha_0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _deviceMenuButton.frame=devFrame;
            _myVideoButton.frame=videoFrame;
            _realDataButton.frame=realDataFrame;
            _historyDataButton.frame=hisDataFrame;
            
            _deviceMenuButton.alpha=alpha_1;
            _myVideoButton.alpha=alpha_1;
            _realDataButton.alpha=alpha_1;
            _historyDataButton.alpha=alpha_1;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}

-(void)buttonStyleInit{
    CGRect bounds=self.view.bounds;
    self.logoView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    _logoView.frame=CGRectMake((bounds.size.width-80)/2, (bounds.size.height-80)/2, 80, 80);
    [_logoView setAlpha:0.15];
    self.deviceMenuButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [_deviceMenuButton setTitle:items[0] forState:UIControlStateNormal];
    self.myVideoButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [_myVideoButton setTitle:items[1] forState:UIControlStateNormal];
    self.realDataButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [_realDataButton setTitle:items[2] forState:UIControlStateNormal];
    self.historyDataButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [_historyDataButton setTitle:items[3] forState:UIControlStateNormal];
    
    
    CGFloat WH=100;
    CGFloat SPACE=60;
    
    
    [_deviceMenuButton setFrame:CGRectMake(0, 0, WH, WH)];
    [_deviceMenuButton setCenter:CGPointMake(_logoView.center.x-SPACE, _logoView.center.y-SPACE)];
    
    [_myVideoButton setFrame:CGRectMake(0, 0, WH, WH)];
    [_myVideoButton setCenter:CGPointMake(_logoView.center.x+SPACE, _logoView.center.y-SPACE)];
    
    [_realDataButton setFrame:CGRectMake(0, 0, WH, WH)];
    [_realDataButton setCenter:CGPointMake(_logoView.center.x-SPACE, _logoView.center.y+SPACE)];
    
    
    [_historyDataButton setFrame:CGRectMake(0, 0, WH, WH)];
    [_historyDataButton setCenter:CGPointMake(_logoView.center.x+SPACE, _logoView.center.y+SPACE)];
    
    
    
    [self.view addSubview:_logoView];
    
    [self.view addSubview:_deviceMenuButton];
    [self.view addSubview:_myVideoButton];
    [self.view addSubview:_realDataButton];
    [self.view addSubview:_historyDataButton];
    
    
    [_myVideoButton addTarget:self action:@selector(redirectTo:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    
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

-(void)redirectTo:(UIButton *)sender{
    
    [self performSegueWithIdentifier:@"toVideo" sender:sender];
}

-(void)styleInitToButton:(UIButton *)button data:(NSDictionary *)dic{
    button.layer.cornerRadius=_deviceMenuButton.frame.size.width/2;
    button.layer.backgroundColor=[[UIColor colorWithHexString:[dic objectForKey:@"backgroundColor"]] CGColor];
    
    button.layer.borderColor=[[UIColor colorWithHexString:[dic objectForKey:@"borderColor"]] CGColor];
    button.layer.borderWidth=1;
    button.layer.opacity=0.85;
    
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
