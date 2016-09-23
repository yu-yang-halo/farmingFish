//
//  UIButton+BGColor.m
//  farmingFish
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "UIButton+BGColor.h"
#import <objc/runtime.h>
#define CONTEXT_NEW_VALUE "CONTEXT_HAS_NEW_VALUE"

#define UICONTROL_STATE_NORMAL @"STATE_NORMAL"
#define UICONTROL_STATE_HIGHTLIGHT @"STATE_HIGHTLIGHT"

@implementation UIButton (BGColor)


-(instancetype)init{
    self=[super init];
    if(self!=nil){
        NSLog(@"UIButton class catagery bgcolor init");
    }
    return self;
}
-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    
    NSString *key=nil;
    if(state==UIControlStateNormal){
        key=UICONTROL_STATE_NORMAL;
        [self setBackgroundColor:color];
    }else{
        key=UICONTROL_STATE_HIGHTLIGHT;
    }
    
    
    objc_setAssociatedObject(self, (__bridge const void *)(key),color, OBJC_ASSOCIATION_RETAIN);
    
    [self addObserver:self forKeyPath:@"self.highlighted" options:NSKeyValueObservingOptionNew context:CONTEXT_NEW_VALUE];
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(context==CONTEXT_NEW_VALUE){
        id value=[change objectForKey:NSKeyValueChangeNewKey];
        //  NSLog(@"change value %@",value);
        if([value intValue]==1){
            UIColor *color=objc_getAssociatedObject(self,UICONTROL_STATE_HIGHTLIGHT);
            [self setBackgroundColor:color];
        }else{
            UIColor *color=objc_getAssociatedObject(self,UICONTROL_STATE_NORMAL);
            [self setBackgroundColor:color];
        }
    }
    
}


@end
