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
            
            
            //NSLog(@"destMethodName %@",destMethodName);
            SEL destMethodSelector=NSSelectorFromString(destMethodName);
            if([bean respondsToSelector:destMethodSelector]){
                id value=[dict objectForKey:keyName];
               // NSLog(@"keyName %@ %@",keyName,value);
                [bean performSelector:destMethodSelector withObject:value];
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
    
   // NSLog(@"beforeStr::%@ afterStr::%@",beforeStr,afterStr);
    
    return [NSString stringWithFormat:@"%@%@",beforeStr.uppercaseString,afterStr];
    
    
}
+(NSArray<YYCollectorSensor *> *)parseYYCollectorSensorList:(id)arrs{
    NSMutableArray *sensors=[[NSMutableArray alloc] init];
    for(NSDictionary *dict in arrs) {
        YYCollectorSensor *sensor=[[YYCollectorSensor alloc] init];
        [self dictionaryToBeanObject:dict beanObj:sensor];
        
        if(sensor.F_IsChecked.intValue==1){
            [sensors addObject:sensor];
        }
        
    }
    
    return [sensors copy];
}

@end
