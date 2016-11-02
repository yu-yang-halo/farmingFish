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
#import "YYTabViewController.h"
#import "YYWeatherService.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface MainViewController (){
    NSArray *items;
    
    NSArray *colors;
    NSArray *alphcolors;
}
@property (strong, nonatomic)  UIButton *item0;
@property (strong, nonatomic)  UIButton *item1;
@property (strong, nonatomic)  UIButton *item2;
@property (strong, nonatomic)  UIButton *item3;
@property (strong, nonatomic)  UIButton *item4;
@property (strong, nonatomic)  UIButton *item5;
@property (strong, nonatomic)  UIButton *logoItem;

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
    items=@[@"实时监测",@"视频监控",@"远程控制",@"超限预警",@"知识库",@"历史数据"];
 colors=@[@"5ac6aa",@"20938b",@"f18c9d",@"375c95",@"f96441",@"feb900",@"903e661a"];
    alphcolors=@[@"905ac6aa",@"9020938b",@"90f18c9d",@"90375c95",@"90f96441",@"90feb900",@"903e661a"];
    
    //初始化页面背景色
    [self viewControllerBGInit];
    [self buttonStyleInit];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud.bezelView setColor:[UIColor clearColor]];
    [hud.bezelView setStyle:MBProgressHUDBackgroundStyleSolidColor];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        
        
        self.videoInfo=[[FService shareInstance] GetUserVideoInfo:delegate.userAccount];
        
        self.devicesInfo=[[FService shareInstance] GetCollectorInfo:delegate.customerNo  userAccount:delegate.userAccount];
        
        delegate.videoInfo=_videoInfo;
        delegate.deviceData=_devicesInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
        });
        
       
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
    CGRect frame4=_item4.frame;
    CGRect frame5=_item5.frame;
    CGRect logoFrame=_logoItem.frame;
    
    CGFloat alpha_0=0.0;
    CGFloat alpha_1=1.0;
    
    [UIView animateWithDuration:0.02 animations:^{
        _item0.frame=logoFrame;
        _item1.frame=logoFrame;
        _item2.frame=logoFrame;
        _item3.frame=logoFrame;
        _item4.frame=logoFrame;
        _item5.frame=logoFrame;
        
        _item0.alpha=alpha_0;
        _item1.alpha=alpha_0;
        _item2.alpha=alpha_0;
        _item3.alpha=alpha_0;
        _item4.alpha=alpha_0;
        _item5.alpha=alpha_0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _item0.frame=frame0;
            _item1.frame=frame1;
            _item2.frame=frame2;
            _item3.frame=frame3;
            _item4.frame=frame4;
            _item5.frame=frame5;
            
            _item0.alpha=alpha_1;
            _item1.alpha=alpha_1;
            _item2.alpha=alpha_1;
            _item3.alpha=alpha_1;
            _item4.alpha=alpha_1;
            _item5.alpha=alpha_1;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}

-(void)buttonStyleInit{
    CGRect bounds=self.view.bounds;
    self.logoItem=[[UIButton alloc] initWithFrame:CGRectZero];
    
    _logoItem.frame=CGRectMake((bounds.size.width-80)/2, (bounds.size.height-80)/2, 85, 85);
 
    [_logoItem setTitle:@"拓立德" forState:UIControlStateNormal];
    [_logoItem setEnabled:NO];
    self.item0=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item0 setTitle:items[0] forState:UIControlStateNormal];
    self.item1=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item1 setTitle:items[1] forState:UIControlStateNormal];
    self.item2=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item2 setTitle:items[2] forState:UIControlStateNormal];
    self.item3=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item3 setTitle:items[3] forState:UIControlStateNormal];
    
    self.item4=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item4 setTitle:items[4] forState:UIControlStateNormal];
    
    self.item5=[[UIButton alloc] initWithFrame:CGRectZero];
    [_item5 setTitle:items[5] forState:UIControlStateNormal];
    
    
    CGFloat WH=90;
    CGFloat SPACE=95;
    float angel=3.1415926/6;
    
    [_item0 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item0 setCenter:CGPointMake(_logoItem.center.x-SPACE*sin(angel), _logoItem.center.y-SPACE*cos(angel))];
    
    [_item1 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item1 setCenter:CGPointMake(_logoItem.center.x+SPACE*sin(angel), _logoItem.center.y-SPACE*cos(angel))];
    
    [_item2 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item2 setCenter:CGPointMake(_logoItem.center.x-SPACE, _logoItem.center.y+0)];
    
    
    [_item3 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item3 setCenter:CGPointMake(_logoItem.center.x+SPACE, _logoItem.center.y+0)];
    
    
    [_item4 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item4 setCenter:CGPointMake(_logoItem.center.x-SPACE*sin(angel), _logoItem.center.y+SPACE*cos(angel))];
    
    [_item5 setFrame:CGRectMake(0, 0, WH, WH)];
    [_item5 setCenter:CGPointMake(_logoItem.center.x+SPACE*sin(angel), _logoItem.center.y+SPACE*cos(angel))];
    
    
    
    [self.view addSubview:_logoItem];
    
    [self.view addSubview:_item0];
    [self.view addSubview:_item1];
    [self.view addSubview:_item2];
    [self.view addSubview:_item3];
    [self.view addSubview:_item4];
    [self.view addSubview:_item5];
    
    [_item0 setTag:0];
    [_item1 setTag:1];
    [_item2 setTag:2];
    [_item3 setTag:3];
    [_item4 setTag:4];
    [_item5 setTag:5];
    
    [_item0 addTarget:self action:@selector(redirectTo:) forControlEvents:UIControlEventTouchUpInside];
    [_item1 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];
    [_item2 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];

    [_item3 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];
    [_item4 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];
    [_item5 addTarget:self action:@selector(redirectTo:)  forControlEvents:UIControlEventTouchUpInside];
    
   
    
    
    /*
        我的设备button 样式 EDE41A
     */
    [self styleInitToButton:_item0 data:@{@"selBgColor":alphcolors[0],@"backgroundColor":colors[0],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
   
    [self styleInitToButton:_item1 data:@{@"selBgColor":alphcolors[1],@"backgroundColor":colors[1],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    [self styleInitToButton:_item2 data:@{@"selBgColor":alphcolors[2],@"backgroundColor":colors[2],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    
    [self styleInitToButton:_item3 data:@{@"selBgColor":alphcolors[3],@"backgroundColor":colors[3],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
     [self styleInitToButton:_item4 data:@{@"selBgColor":alphcolors[4],@"backgroundColor":colors[4],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
     [self styleInitToButton:_item5 data:@{@"selBgColor":alphcolors[5],@"backgroundColor":colors[5],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];

    
    [self styleInitToButton:_logoItem data:@{@"selBgColor":alphcolors[6],@"backgroundColor":colors[6],@"borderColor":@"07F3ECEC",@"shadowColor":@"80FCFCFC"}];
    
    
}

-(void)redirectTo:(UIButton *)sender{
  
    if(sender.tag==0){
        if(_videoInfo==nil){
             [self.view.window makeToast:@"暂无视频数据信息,请重试"];
            return;
        }
    }else if(sender.tag==1||sender.tag==2){
        if(_devicesInfo==nil){
            [self.view.window makeToast:@"暂无设备数据信息,请重试"];
            return;
        }
    }
    
    
    
    [self performSegueWithIdentifier:@"tabVC" sender:sender];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    YYTabViewController *tabBarVC=segue.destinationViewController;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *videoVC=[storyBoard instantiateViewControllerWithIdentifier:@"videoVC"];
    UIViewController *realDataVC=[storyBoard instantiateViewControllerWithIdentifier:@"realDataVC"];
    UIViewController *controlVC=[storyBoard instantiateViewControllerWithIdentifier:@"controlVC"];
    
    UIViewController *newsVC=[storyBoard instantiateViewControllerWithIdentifier:@"newsVC"];
    
    UIViewController *historyVC=[storyBoard instantiateViewControllerWithIdentifier:@"historyVC"];
    
    UIViewController *settingsVC=[storyBoard instantiateViewControllerWithIdentifier:@"settingsVC"];
    
    
    [tabBarVC setViewControllers:@[videoVC,realDataVC,controlVC,historyVC,settingsVC,newsVC]];
    
    [tabBarVC setDefaultIndex:sender.tag];
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
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
