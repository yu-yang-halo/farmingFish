//
//  SPackage.h
//  farmingFish
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketService.h"
@interface SPackage : NSObject
+(NSData *)buildSocketPackage_mobile_client;
+(NSData *)buildSocketPackage_WATER;
+(NSData *)buildSocketPackage_ControlMSG:(int)num cmd:(int)cmdStatus deviceId:(NSString *)devId;

+(void)reservePackageInfo:(NSData *)data StatusBlock:(StatusBlock)block;

@end
