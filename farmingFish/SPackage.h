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

//区间参数设置
+(NSData *)buildSocketPackage_ParametersMSG;
+(NSData *)buildSocketPackage_Parameters:(NSString *)customerNO;

//时间参数获取
+(NSData *)buildSocketPackage_Time:(NSString *)customerNO;
//时间参数保存
+(NSData *)saveSocketPackage_Time:(NSString *)customerNO;





+(void)reservePackageInfo:(NSData *)data StatusBlock:(StatusBlock)block tag:(int)tag;

@end
