//
//  GradientHelper.m
//  farmingFish
//
//  Created by apple on 2016/11/4.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GradientHelper.h"
#import "UIColor+hexStr.h"
@implementation GradientHelper
+(void)setGradientToView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    UIColor *startColor = [UIColor colorWithHexString:@"#6AE6FA"];
    UIColor *endColor = [UIColor colorWithHexString:@"#36A0FB"];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =view.bounds;
    gradient.startPoint =startPoint;
    gradient.endPoint =endPoint;
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    
    [view.layer insertSublayer:gradient atIndex:0];

}
+(void)setGradientToView:(UIView *)view{
    
    [self setGradientToView:view startPoint:CGPointMake(0, 0) endPoint: CGPointMake(1,1)];
    
}
@end
