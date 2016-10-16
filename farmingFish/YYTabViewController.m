//
//  YYTabViewController.m
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYTabViewController.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
#import "UIButton+BGColor.h"
@interface YYTabViewController (){
    CGFloat buttonWidth;
}
@property(nonatomic,strong) UIScrollView *tabBarView;
@property(nonatomic,strong) NSArray *items;

@end

@implementation YYTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items=@[@"我的视频",@"实时数据",@"设备控制",@"历史数据",@"设置",@"养殖知识"];
    
    [self.tabBar setHidden:YES];

    self.tabBarView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-30, CGRectGetWidth(self.view.frame), 49)];
    
  
    [self.tabBarView setBackgroundColor:[UIColor uig_lemonTwistStartColor]];
    [self.tabBarView setAlpha:0.8];
    
    buttonWidth=CGRectGetWidth(self.view.frame)/4;
    
    for (int i=0;i<[_items count]; i++) {
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*i,0, buttonWidth,30)];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:(UIControlStateNormal)];
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1] forState:UIControlStateHighlighted];
        [_tabBarView addSubview:btn];
    }
    self.tabBarView.contentSize=CGSizeMake(buttonWidth*_items.count, 30);
    [self.tabBarView setShowsHorizontalScrollIndicator:NO];
    [_tabBarView setPagingEnabled:YES];
    [self.view addSubview:_tabBarView];
    
    [self tabBarViewInit:_defaultIndex];
 
    [self.moreNavigationController.navigationBar setHidden:YES];
}

-(void)setDefaultIndex:(int)defaultIndex{
    _defaultIndex=defaultIndex;
    [self tabBarViewInit:_defaultIndex];
    
}
-(void)tabBarViewInit:(int)selectedIndex{
    [self setSelectedIndex:selectedIndex];
    [self setTitle:_items[selectedIndex]];
    
    for (UIView *view in [_tabBarView subviews]) {
        if([view isKindOfClass:[UIButton class]]){
            
            if(selectedIndex==view.tag){
                [(UIButton *)view setSelected:YES];
            }else{
                [(UIButton *)view setSelected:NO];
            }
        }
    }
    //[0,1,2,3,4,5]
    //计算中心点
    if(selectedIndex>=3){
        [_tabBarView setContentOffset:CGPointMake(buttonWidth*2, 0) animated:YES];
    }else{
         [_tabBarView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

-(void)btnClick:(UIButton *)sender{
    [self tabBarViewInit:sender.tag];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
