//
//  TouchView.m
//  farmingFish
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "TouchView.h"
static CGFloat min_trigger=30;
@interface TouchView(){
    CGPoint beginPoint;
    CGPoint endPoint;
}
@end
@implementation TouchView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // NSLog(@"touchesBegan...");
    
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        beginPoint=[obj locationInView:self];
    }];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // NSLog(@"touchesEnded...");
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        endPoint=[obj locationInView:self];
    }];
    
    
    if(fabsf(beginPoint.x-endPoint.x)-fabsf(beginPoint.y-endPoint.y)>0){
        
        if(endPoint.x-beginPoint.x>=min_trigger){
            NSLog(@"手势向右拖拽，视频界面向左转动");
            [_ptzDelegate ptzControl:self.tag ptzDirect:3];
        }
        if(beginPoint.x-endPoint.x>=min_trigger){
            NSLog(@"手势向左拖拽，视频界面向右转动");
             [_ptzDelegate ptzControl:self.tag ptzDirect:4];
        }
        
    }else{
        
        if(beginPoint.y-endPoint.y>=min_trigger){
            NSLog(@"手势向上拖拽，视频界面向下转动");
             [_ptzDelegate ptzControl:self.tag ptzDirect:2];
        }
        if(endPoint.y-beginPoint.y>=min_trigger){
            NSLog(@"手势向下拖拽，视频界面向上转动");
             [_ptzDelegate ptzControl:self.tag ptzDirect:1];
        }
    }
   
  
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // NSLog(@"touchesMoved...");
    
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // NSLog(@"touchesCancelled...");
    
}



@end
