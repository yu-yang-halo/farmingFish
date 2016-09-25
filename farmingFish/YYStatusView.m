//
//  YYStatusView.m
//  farmingFish
//
//  Created by apple on 16/9/24.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYStatusView.h"
#import "UIColor+hexStr.h"


static const CGFloat YY_STATUS_HEIGHT=10;
static const CGFloat YY_STATUS_RADIUS=4;
@interface YYStatusView(){
    float percentage;
}

@property(nonatomic,strong) UIView *valueView;


@end
@implementation YYStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self viewInit:self.frame];
    }
    return self;
}
-(void)viewInit:(CGRect)frame{
    frame.size.height=YY_STATUS_HEIGHT;
    [self setFrame:frame];
    
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    self.layer.cornerRadius=YY_STATUS_RADIUS;
    
    [self percentageInit];
    
    self.valueView=[[UIView alloc] initWithFrame:[self lastStatusRect]];
    
    [_valueView setBackgroundColor:[UIColor colorWithHexString:@"80FF0000"]];
    _valueView.layer.cornerRadius=YY_STATUS_RADIUS;
    
    [self addSubview:_valueView];
}
-(void)awakeFromNib{
    [self viewInit:self.frame];
}

-(CGRect)lastStatusRect{
    
    return CGRectMake(0, 0, self.frame.size.width*percentage, YY_STATUS_HEIGHT);
}
-(void)percentageInit{
    if(_maxValue!=0&&_statusValue!=0){
        percentage=_statusValue/_maxValue;
    }
}
-(void)setMaxValue:(float)maxValue{
    _maxValue=maxValue;
    [self percentageInit];
    
}

-(void)setStatusValue:(float)statusValue{
    _statusValue=statusValue;
    [self percentageInit];
    
}

-(void)startAnimation{
   [UIView animateWithDuration:0.6 animations:^{
       [_valueView setFrame:CGRectMake(0,0,0, YY_STATUS_HEIGHT)];
   } completion:^(BOOL finished) {
       [UIView animateWithDuration:3 animations:^{
           [_valueView setFrame:[self lastStatusRect]];
       } completion:^(BOOL finished) {
           
       }];
   }];
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
