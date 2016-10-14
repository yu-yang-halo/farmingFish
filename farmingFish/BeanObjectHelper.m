//
//  BeanObjectHelper.m
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "BeanObjectHelper.h"

@implementation BeanObjectHelper
+(void)dictionaryToBeanObject:(NSDictionary *)dict beanObj:(NSObject *)bean{
    if(dict&&bean){
        for(NSString *keyName in [dict allKeys]){
            NSString *destMethodName=[NSString stringWithFormat:@"set%@:",keyName];
            //NSLog(@"destMethodName %@",destMethodName);
            SEL destMethodSelector=NSSelectorFromString(destMethodName);
            if([bean respondsToSelector:destMethodSelector]){
                [bean performSelector:destMethodSelector withObject:[dict objectForKey:keyName]];
            }
        }
    }
}
@end
