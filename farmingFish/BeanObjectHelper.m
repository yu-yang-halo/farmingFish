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
            NSString *destMethodName=[NSString stringWithFormat:@"set%@:",[self beginCharacterUpper:keyName]];
            
            
            NSLog(@"destMethodName %@",destMethodName);
            SEL destMethodSelector=NSSelectorFromString(destMethodName);
            if([bean respondsToSelector:destMethodSelector]){
                NSLog(@"keyName %@",keyName);
                [bean performSelector:destMethodSelector withObject:[dict objectForKey:keyName]];
            }
        }
    }
}

+(NSString *)beginCharacterUpper:(NSString *)str{
    int len=str.length;
    if(len<=1){
        return [str uppercaseString];
    }
    
    NSString *afterStr=[str substringWithRange:NSMakeRange(1, len-1)];
    
    NSString *beforeStr=[str substringWithRange:NSMakeRange(0, 1)];
    
    NSLog(@"beforeStr::%@ afterStr::%@",beforeStr,afterStr);
    
    return [NSString stringWithFormat:@"%@%@",beforeStr.uppercaseString,afterStr];
    
    
}
@end
