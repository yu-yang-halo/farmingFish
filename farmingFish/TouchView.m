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
    NSLog(@"touchesBegan...");
    
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        beginPoint=[obj locationInView:self];
    }];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"touchesEnded...");
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        endPoint=[obj locationInView:self];
    }];
    
    
    if(fabsf(beginPoint.x-endPoint.x)-fabsf(beginPoint.y-endPoint.y)>0){
        
        if(endPoint.x-beginPoint.x>=min_trigger){
            NSLog(@"RIGHT");
            [_ptzDelegate ptzControl:self.tag ptzDirect:4];
        }
        if(beginPoint.x-endPoint.x>=min_trigger){
            NSLog(@"LEFT");
             [_ptzDelegate ptzControl:self.tag ptzDirect:3];
        }
        
    }else{
        
        if(beginPoint.y-endPoint.y>=min_trigger){
            NSLog(@"UP");
             [_ptzDelegate ptzControl:self.tag ptzDirect:1];
        }
        if(endPoint.y-beginPoint.y>=min_trigger){
            NSLog(@"DOWN");
             [_ptzDelegate ptzControl:self.tag ptzDirect:2];
        }
    }
   
  
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"touchesMoved...");
    
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"touchesCancelled...");
    
}



@end
