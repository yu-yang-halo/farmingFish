//
//  YYTabViewController.m
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYTabViewController.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
#import "UIColor+hexStr.h"
#import "UIViewController+Extension.h"
#import "View+point.h"
@interface YYTabViewController (){
    CGFloat buttonWidth;
    NSArray *normalImages;
    NSArray *highlightImages;
}
@property(nonatomic,strong) UIView *tabBarView;
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,strong) NSArray *itemsMore;
@end

@implementation YYTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerBGInit];
    self.items=@[@"实时",@"视频",@"控制",@"预警",@"更多"];
    self.itemsMore=@[ITEM_REALDATA,ITEM_VIDEO,ITEM_CONTROL,ITEM_ALERT,@"更多"];

    
  normalImages=@[@"tab_realdata0",@"tab_video0",@"tab_control0",@"tab_alert0",@"tab_more0"];
 highlightImages=@[@"tab_realdata1",@"tab_video1",@"tab_control1",@"tab_alert1",@"tab_more1"];
    
    [self.tabBar setHidden:YES];

    self.tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-tldTabBarHeight, CGRectGetWidth(self.view.frame), tldTabBarHeight)];
    self.tabBarView.layer.borderWidth=0.1;
    self.tabBarView.layer.borderColor=[[UIColor colorWithHexString:@"#b2b2b2"] CGColor];
  
    [self.tabBarView setBackgroundColor:[UIColor colorWithHexString:@"#fafafa"]];
    [self.tabBarView setAlpha:1];
    
    buttonWidth=CGRectGetWidth(self.view.frame)/[_items count];
    
    for (int i=0;i<[_items count]; i++) {
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*i,(tldTabBarHeight-56)/2, buttonWidth,56)];
        
        
        [self buttonStyleInit:btn index:i];
        
        if(i==3){
            [btn setShowPointHidden:NO];
        }else{
            [btn setShowPointHidden:YES];
        }
        
        
       
        
        [_tabBarView addSubview:btn];
    }
    
    [self.view addSubview:_tabBarView];
    
    [self tabBarViewInit:_defaultIndex];
 
    [self.moreNavigationController.navigationBar setHidden:YES];
    
   
}
-(void)buttonStyleInit:(UIButton *)btn index:(int)idx{
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-18, 0, 0,-32)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -38, -34, 0)];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#2E82FA"] forState:(UIControlStateSelected)];
    [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:normalImages[idx]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImages[idx]] forState:UIControlStateSelected];
    
    [btn setTitle:_items[idx] forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTag:idx];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
   
}

-(void)setDefaultIndex:(int)defaultIndex{
    _defaultIndex=defaultIndex;
    [self tabBarViewInit:_defaultIndex];
    
}

-(void)tabBarViewInit:(int)selectedIndex{
    

    
    [self setSelectedIndex:selectedIndex];
//    [self setTitle:_itemsMore[selectedIndex]];
    self.navigationItem.title=_itemsMore[selectedIndex];
    
    for (UIView *view in [_tabBarView subviews]) {
        if([view isKindOfClass:[UIButton class]]){
            
            if(selectedIndex==view.tag){
                [(UIButton *)view setSelected:YES];
            }else{
                [(UIButton *)view setSelected:NO];
            }
        }
    }
    
    
}

-(void)btnClick:(UIButton *)sender{
    [self tabBarViewInit:sender.tag];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
