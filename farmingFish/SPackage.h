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
+(NSData *)buildSocketPackage_mobile_client:(NSString *)customerNO;
+(NSData *)buildSocketPackage_WATER:(NSString *)customerNO;
+(NSData *)buildSocketPackage_ControlMSG:(int)num cmd:(int)cmdStatus deviceId:(NSString *)customerNO;

+(NSData *)buildSocketPackage_range:(int)max min:(int)min deviceId:(NSString *)customerNO methodType:(int)type;

+(NSData *)buildSocketPackage_mode:(int)mode deviceId:(NSString *)customerNO methodType:(int)type;

+(NSData *)buildSocketPackage_time:(int)time deviceId:(NSString *)customerNO methodType:(int)type;


+(void)reservePackageInfo:(Byte *)bytes StatusBlock:(StatusBlock)block tag:(int)tag;
+(void)resolveRangeData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo;
+(void)resolveModeData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo;

+(void)resolveTimeData:(Byte *)status StatusBlock:(StatusBlock)block customNo:(NSString *)customNo;

@end
