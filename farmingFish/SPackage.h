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
+(NSData *)buildSocketPackage_mobile_client:(NSString *)DeviceId;

+(NSData *)buildSocketPackage_WATER:(NSString *)DeviceId;
+(NSData *)buildSocketPackage_ControlMSG:(int)num cmd:(int)cmdStatus deviceId:(NSString *)DeviceId;

+(NSData *)buildSocketPackage_range:(int)max min:(int)min deviceId:(NSString *)DeviceId methodType:(int)type;

+(NSData *)buildSocketPackage_mode:(int)mode deviceId:(NSString *)DeviceId methodType:(int)type;

+(NSData *)buildSocketPackage_time:(int)time deviceId:(NSString *)DeviceId methodType:(int)type;


+(void)reservePackageInfo:(Byte *)bytes StatusBlock:(StatusBlock)block tag:(int)tag;
//+(void)resolveRangeData:(Byte *)status StatusBlock:(StatusBlock)block DeviceId:(NSString *)DeviceId;
//+(void)resolveModeData:(Byte *)status StatusBlock:(StatusBlock)block DeviceId:(NSString *)DeviceId;
//
//+(void)resolveTimeData:(Byte *)status StatusBlock:(StatusBlock)block DeviceId:(NSString *)DeviceId;

@end
