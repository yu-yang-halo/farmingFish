//
//  CacheHelper.m
//  farmingFish
//
//  Created by apple on 2016/11/19.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "CacheHelper.h"
const static NSString *KEY_REAL_DATA_TABLE=@"realDataDictKEY";

@implementation CacheHelper
+(void)cacheRealDataToDisk:(NSArray *)realDataArr customNo:(NSString *)customNo{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REAL_DATA_TABLE];
    
    if(dict==nil){
        dict=[NSMutableDictionary new];
    }else{
        if([dict isKindOfClass:[NSDictionary class]]){
            dict=[dict mutableCopy];
        }
    }
    
    [dict setObject:realDataArr forKey:customNo];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:KEY_REAL_DATA_TABLE];
    
    
    
}
+(NSArray *)fetchCacheRealDataFromDisk:(NSString *)customNo{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REAL_DATA_TABLE];
    
    if(dict==nil){
        return nil;
    }
    NSArray *realDataArrs=[dict objectForKey:customNo];
    return realDataArrs;
}
@end
