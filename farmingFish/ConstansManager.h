//
//  ConstansManager.h
//  farmingFish
//
//  Created by apple on 2016/11/6.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstansManager : NSObject

+(NSString *)contentForKeyInt:(NSNumber *)key;
+(NSString *)contentForKeyString:(NSString *)key;
+(NSArray *)maxWithMinRange:(NSNumber *)key;
+(NSArray *)yAxisRange:(NSNumber *)key;
+(NSString *)unitForKeyString:(NSString *)key;
@end
