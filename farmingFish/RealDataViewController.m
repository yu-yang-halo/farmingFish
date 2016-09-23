//
//  RealDataViewController.m
//  farmingFish
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "RealDataViewController.h"
#import "UIViewController+Extension.h"
#import "SocketService.h"
@interface RealDataViewController ()

@end

@implementation RealDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"实时数据";
    [self navigationBarInit];
    [self viewControllerBGInit];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[SocketService shareInstance] connect];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
                                               溶氧 4.050000
 2016-09-23 17:22:56.400 farmingFish[3710:60b] 温度 23.820000
 2016-09-23 17:22:56.408 farmingFish[3710:60b] PH 7.300000
 2016-09-23 17:22:56.409 farmingFish[3710:60b] 氨氮 0.120000
 2016-09-23 17:22:56.411 farmingFish[3710:60b] 亚硝酸盐 0.020000
 2016-09-23 17:22:56.412 farmingFish[3710:60b] 液位 0.000000
 2016-09-23 17:22:56.413 farmingFish[3710:60b] 硫化氢 0.000000
 2016-09-23 17:22:56.415 farmingFish[3710:60b] 浊度 0.000000
 2016-09-23 17:22:56.416 farmingFish[3710:60b] 电机状态 10000000
 */

@end
