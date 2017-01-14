//
//  YYStatusView.m
//  farmingFish
//
//  Created by apple on 16/9/24.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYStatusView.h"
#import "UIColor+hexStr.h"
#import <UIColor_uiGradients/UIColor+uiGradients.h>

//static const CGFloat YY_STATUS_HEIGHT=10;
//static const CGFloat YY_STATUS_RADIUS=4;
@interface YYStatusView(){
    float percentage;
    //CGFloat height;
}

@property(nonatomic,strong) UIView *valueView;
@property(nonatomic,assign) float lastValue;

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
   
   // [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];

    if(self.layer!=nil){
        for (UIView *childView in [self subviews]) {
            [childView removeFromSuperview];
        }
        for (CALayer *childLayer in [self.layer sublayers]) {
            [childLayer removeFromSuperlayer];
        }
    }
   
    
    CALayer *layer=[CALayer layer];
    layer.frame =self.bounds;
    layer.backgroundColor=[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor];
    layer.cornerRadius=CGRectGetHeight(frame)/2;
    
    [self.layer insertSublayer:layer atIndex:0];
     self.layer.cornerRadius=CGRectGetHeight(frame)/2;
    
    [self percentageInit];
    
    self.valueView=[[UIView alloc] initWithFrame:[self currentStatusRect]];
    
    //C96608  32980B AC0101

    UIColor *startColor = [UIColor colorWithHexString:@"C96608"];
    UIColor *centerColor=[UIColor colorWithHexString:@"32980B"];
    UIColor *endColor = [UIColor colorWithHexString:@"AC0101"];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,0);
    gradient.colors = @[(id)[startColor CGColor],
                        (id)[centerColor CGColor],
                          (id)[centerColor CGColor],
                          (id)[centerColor CGColor],
                        (id)[endColor CGColor]];
    gradient.cornerRadius=CGRectGetHeight(frame)/2;
    [_valueView.layer insertSublayer:gradient atIndex:0];

    _valueView.layer.cornerRadius=CGRectGetHeight(frame)/2;
    [_valueView setClipsToBounds:YES];

    [self addSubview:_valueView];
    
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self viewInit:self.frame];
}
/*
 *当前状态
 */
-(CGRect)currentStatusRect{
    
    return CGRectMake(0, 0, self.frame.size.width*percentage, self.frame.size.height);
}
/*
 *上一次的状态
 */
-(CGRect)lastStatusRect{
    float percentage1=0.0;
    if(_maxValue!=0&&_lastValue!=0){
        percentage1=_lastValue/_maxValue;
    }
    return CGRectMake(0, 0, self.frame.size.width*percentage1, self.frame.size.height);
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
    _lastValue=_statusValue;
    _statusValue=statusValue;
    [self percentageInit];
    
}

-(void)startAnimation:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:0.6 animations:^{
            [_valueView setFrame:[self lastStatusRect]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3 animations:^{
                [_valueView setFrame:[self currentStatusRect]];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        [_valueView setFrame:[self currentStatusRect]];
    }
  
   
}
-(void)startAlphaAnimation:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:0.6 animations:^{
            [_valueView setAlpha:0.1];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
               [_valueView setAlpha:1];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        [_valueView setAlpha:1];
    }
    
    
}

-(void)layoutSubviews{
    [self viewInit:self.frame];
    [self startAlphaAnimation:YES];
     
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
