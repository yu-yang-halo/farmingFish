//
//  MainViewController.m
//  farmingFish
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "MainViewController.h"
#import <UIView+Toast.h>
#import "UIColor+hexStr.h"
#import "UIViewController+Extension.h"
#import "VideoViewController.h"
#import "FService.h"
#import "AppDelegate.h"
#import "SocketService.h"
#import "UIButton+BGColor.h"
#import "RealDataViewController.h"

@interface MainViewController (){
    NSArray *items;
}
@property (strong, nonatomic)  UIButton *item0;
@property (strong, nonatomic)  UIButton *item1;
@property (strong, nonatomic)  UIButton *item2;
@property (strong, nonatomic)  UIButton *item3;
@property (strong, nonatomic)  UIImageView *logoView;

/*
 *params data
 */
@property(nonatomic,strong) NSDictionary *videoInfo;
@property(nonatomic,strong) NSDictionary *devicesInfo;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"主页";
    [self navigationBarInit];
    items=@[@"我的视频",@"实时数据",@"历史数据",@"新闻中心"];
    //初始化页面背景色
    [self viewControllerBGInit];
    [self buttonStyleInit];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        
        
        self.videoInfo=[[FService shareInstance] GetUserVideoInfo:delegate.userAccount];
        self.devicesInfo=[[FService shareInstance] GetCollectorInfo:delegate.customerNo  userAccount:delegate.userAccount];
        
        
        NSLog(@"GetUserVideoInfo::: %@", _videoInfo);
        NSLog(@"GetCollectorInfo::: %@", _devicesInfo);
        
    });

   
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self animationStart];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)animationStart{
    //加点动画效果
    CGRect frame0=_item0.frame;
    CGRect frame1=_item1.frame;
    CGRect frame2=_item2.frame;
    CGRect frame3=_item3.frame;
    CGRect logoFrame=_logoView.frame;
    
    CGFloat alpha_0=0.0;
    CGFloat alpha_1=1.0;
    
    [UIView animateWithDuration:0.02 animations:^{
        _item0.frame=logoFrame;
        _item1.frame=logoFrame;
        _item2.frame=logoFrame;
        _item3.frame=logoFrame;
        
        _item0.alpha=alpha_0;
        _item1.alpha=alpha_0;
        _item2.alpha=alpha_0;
        _item3.alpha=alpha_0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _item0.frame=frame0;
            _item1.frame=frame1;
            _item2.frame=frame2;
            _item3.frame=frame3;
            
            _item0.alpha=alpha_1;
            _item1.alpha=alpha_1;
            _item2.alpha=alpha_1;
            _item3.alpha=alpha_1;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}

-(void)buttonStyleInit{
    CGRect bounds=self.view.bounds;
    self.logoView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    _logoView.frame=CGRectMake((bounds.size.width-80)/2, (bounds.size.height-80)/2, 80, 80);
    [_logoView setAlpha:0.15];
    self.item0=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item0 setTitle:items[0] forState:UIControlStateNormal];
    self.item1=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item1 setTitle:items[1] forState:UIControlStateNormal];
    self.item2=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item2 setTitle:items[2] forState:UIControlStateNormal];
    self.item3=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item3 setTitle:items[3] forState:UIControlStateNormal];
    
    
    CGFloat WH=100;
    CGFloat SPACE=60;
    
    
    [_item0 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item0 setCenter:CGPointMake(_logoView.center.x-SPACE, _logoView.center.y-SPACE)];
    
    [_item1 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item1 setCenter:CGPointMake(_logoView.center.x+SPACE, _logoView.center.y-SPACE)];
    
    [_item2 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item2 setCenter:CGPointMake(_logoView.center.x-SPACE, _logoView.center.y+SPACE)];
    
    
    [_item3 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item3 setCenter:CGPointMake(_logoView.center.x+SPACE, _logoView.center.y+SPACE)];
    
    
    
    [self.view addSubview:_logoView];
    
    [self.view addSubview:_item0];
    [self.view addSubview:_item1];
    [self.view addSubview:_item2];
    [self.view addSubview:_item3];
    
    [_item0 setTag:0];
    [_item1 setTag:1];
    [_item2 setTag:2];
    [_item3 setTag:3];
    
    [_item0 addTarget:self action:@selector(redirectTo:) forControlEvents:UIControlEventTouchUpInside];
    [_item1 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];
    [_item2 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];

    [_item3 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];

    
   
    
    
    /*
        我的设备button 样式 EDE41A
     */
    [self styleInitToButton:_item0 data:@{@"selBgColor":@"90EDE41A",@"backgroundColor":@"EDE41A",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
   
    [self styleInitToButton:_item1 data:@{@"selBgColor":@"9068E668",@"backgroundColor":@"68E668",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    [self styleInitToButton:_item2 data:@{@"selBgColor":@"902194ED",@"backgroundColor":@"2194ED",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    
    [self styleInitToButton:_item3 data:@{@"selBgColor":@"90F55959",@"backgroundColor":@"F55959",@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    

    
    
}

-(void)redirectTo:(UIButton *)sender{
    if(sender.tag==0){
        if(_videoInfo==nil){
            [self.view makeToast:@"视频数据无法找到～"];
            return;
        }
        
        [self performSegueWithIdentifier:@"toVideo" sender:sender];
    }else  if(sender.tag==1){
        [self performSegueWithIdentifier:@"toRealData" sender:sender];
    }
}



-(void)styleInitToButton:(UIButton *)button data:(NSDictionary *)dic{
     button.layer.cornerRadius=button.frame.size.width/2;

    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateHighlighted];
    
    
    [button setBackgroundColor:[UIColor colorWithHexString:[dic objectForKey:@"backgroundColor"]]  forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:[dic objectForKey:@"selBgColor"]]  forState:UIControlStateHighlighted];
    
    button.layer.borderColor=[[UIColor colorWithHexString:[dic objectForKey:@"borderColor"]] CGColor];
    button.layer.borderWidth=5;
    button.layer.opacity=0.85;
    
    button.layer.shadowColor=[[UIColor colorWithHexString:[dic objectForKey:@"shadowColor"]] CGColor];
    button.layer.shadowRadius=10;
    // 设置layer的透明度
    button.layer.shadowOpacity = 1.0f;
    button.layer.shadowOffset=CGSizeMake(0,1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    if(sender.tag==0){
        [(VideoViewController *)(segue.destinationViewController) setVideoInfo:_videoInfo];
    }else if(sender.tag==1){
        [(RealDataViewController *)(segue.destinationViewController) setDeviceData:_devicesInfo];
    }
}

@end
