//
//  FService.h
//  farmingFish
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FService : NSObject
+(instancetype)shareInstance;
-(void)loginName:(NSString *)name password:(NSString *)pass;
@end
