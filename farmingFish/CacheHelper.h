//
//  CacheHelper.h
//  farmingFish
//
//  Created by apple on 2016/11/19.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject
+(void)cacheRealDataToDisk:(NSArray *)realDataArr customNo:(NSString *)customNo;
+(NSArray *)fetchCacheRealDataFromDisk:(NSString *)customNo;

@end
