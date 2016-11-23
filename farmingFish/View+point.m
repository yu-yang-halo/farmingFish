
//
//  UIImageView+redPoint.m
//  farmingFish
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "View+point.h"
#define VIEW_TAG 30000
#define VIEW_RED_SIDE 6
@implementation UIImageView (point)
@dynamic showPointHidden;
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if(self){
        [self initPointView];
    }
    
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initPointView];
}

-(void)setShowPointHidden:(BOOL)showPointHidden{
    for (UIView *subView in [self subviews]) {
        if(subView.tag==VIEW_TAG){
            [subView setHidden:showPointHidden];
        }
    }
}
-(void)initPointView{
    CGRect frame=self.frame;
    UIView *redPointView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-VIEW_RED_SIDE-(10-VIEW_RED_SIDE),0+(10-VIEW_RED_SIDE), VIEW_RED_SIDE, VIEW_RED_SIDE)];
    
    redPointView.layer.cornerRadius=VIEW_RED_SIDE/2;
    redPointView.tag=VIEW_TAG;
    
    [redPointView setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.9]];
    [self addSubview:redPointView];
    
     self.showPointHidden=YES;
}
@end


@implementation UIButton (point)

@dynamic showPointHidden;
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if(self){
        [self initPointView];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initPointView];
}

-(void)setShowPointHidden:(BOOL)showPointHidden{
    for (UIView *subView in [self subviews]) {
        if(subView.tag==VIEW_TAG){
            [subView setHidden:showPointHidden];
        }
    }
}
-(void)initPointView{
    CGRect frame=self.frame;
    UIView *redPointView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-VIEW_RED_SIDE-(10-VIEW_RED_SIDE)-8,0+(10-VIEW_RED_SIDE)-3, VIEW_RED_SIDE, VIEW_RED_SIDE)];
    
    redPointView.layer.cornerRadius=VIEW_RED_SIDE/2;
    redPointView.tag=VIEW_TAG;
    
    [redPointView setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.9]];
    [self addSubview:redPointView];
    
    self.showPointHidden=YES;
}

@end
