//
//  YYStatusView.m
//  farmingFish
//
//  Created by apple on 16/9/24.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYStatusView.h"
#import "UIColor+hexStr.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>

//static const CGFloat YY_STATUS_HEIGHT=10;
static const CGFloat YY_STATUS_RADIUS=4;
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
//    frame.size.height=YY_STATUS_HEIGHT;
//    [self setFrame:frame];
    
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
    self.layer.cornerRadius=YY_STATUS_RADIUS;
    
    [self percentageInit];
    
    self.valueView=[[UIView alloc] initWithFrame:[self currentStatusRect]];
    

    UIColor *startColor = [UIColor colorWithHexString:@"00ff00"];
    UIColor *endColor = [UIColor colorWithHexString:@"ff0000"];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,0);
    gradient.colors = @[(id)[startColor CGColor],(id)[startColor CGColor],(id)[startColor CGColor],(id)[endColor CGColor],(id)[endColor CGColor]];
    
    [_valueView.layer insertSublayer:gradient atIndex:0];
    
    _valueView.layer.cornerRadius=YY_STATUS_RADIUS;
    [_valueView setClipsToBounds:YES];
    
    [self addSubview:_valueView];
}
-(void)awakeFromNib{
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
