//
//  YYButton.m
//  farmingFish
//
//  Created by apple on 2016/11/3.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "YYButton.h"
#import <objc/runtime.h>
#define CONTEXT_NEW_VALUE "CONTEXT_HAS_NEW_VALUE"
#define UICONTROL_STATE_NORMAL @"STATE_NORMAL"
#define UICONTROL_STATE_HIGHTLIGHT @"STATE_HIGHTLIGHT"
@interface YYButton()
@property(nonatomic,strong) NSMutableDictionary *stateDict;
@end

@implementation YYButton

-(instancetype)init{
    self=[super init];
    if(self!=nil){
        NSLog(@"%@ class catagery bgcolor init",self.class);
        
        [self dataBindInit];
    }
    return self;
}
-(void)dataBindInit{
    [self addObserver:self forKeyPath:@"self.highlighted" options:NSKeyValueObservingOptionNew context:CONTEXT_NEW_VALUE];
    self.stateDict=[NSMutableDictionary new];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
          [self dataBindInit];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    
    [_stateDict setObject:color forKey:@(state)];
    
    if(state==UIControlStateNormal){
        [self setBackgroundColor:color]; 
    }
    
}


-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"self.highlighted" context:CONTEXT_NEW_VALUE];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(context==CONTEXT_NEW_VALUE){
        id value=[change objectForKey:NSKeyValueChangeNewKey];
        if([value intValue]==1){
            UIColor *color= [_stateDict objectForKey:@(UIControlStateHighlighted)];
            if(color==nil){
                return;
            }
           
            [self setBackgroundColor:color];
        }else{
            UIColor *color= [_stateDict objectForKey:@(UIControlStateNormal)];
            
            if(color==nil){
                return;
            }
            [self setBackgroundColor:color];
        }
    }
    
}


@end
