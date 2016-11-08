//
//  GradientHelper.h
//  farmingFish
//
//  Created by apple on 2016/11/4.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradientHelper : NSObject
+(void)setGradientToView:(UIView *)view;
+(void)setGradientToView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end
