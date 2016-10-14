//
//  BeanObjectHelper.h
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanObject.h"
@interface BeanObjectHelper : NSObject
+(void)dictionaryToBeanObject:(NSDictionary *)dict beanObj:(NSObject *)bean;
@end
