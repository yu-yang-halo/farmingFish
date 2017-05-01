//
//  BeanObject.h
//  farmingFish
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeanObject : NSObject

@end
@interface YYCollectorSensor:NSObject

@property(nonatomic,strong) NSNumber *F_CollectType;
@property(nonatomic,strong) NSString *F_CollectTypeName;
@property(nonatomic,strong) NSNumber *F_ID;
@property(nonatomic,strong) NSNumber *F_IsChecked;
@property(nonatomic,strong) NSNumber *F_IsWarning;
@property(nonatomic,strong) NSString *F_IsWarningName;
@property(nonatomic,strong) NSNumber *F_Lower;
@property(nonatomic,strong) NSNumber *F_LowerChange;
@property(nonatomic,strong) NSNumber *F_Upper;
@property(nonatomic,strong) NSNumber *F_UpperChange;
@property(nonatomic,strong) NSString *F_ParamText;
@property(nonatomic,strong) NSString *F_ParamValue;
@property(nonatomic,strong) NSString *F_Unit;




@end
/*
 [{"CustomerNo":"00-00-04-01","UserType":1,"CollectorID":"68eeffe7-9561-4a0f-9a7d-751c4cca98fe","DeviceID":"00-00-04-01","ProvinceName":"","CityName":"","OrgName":"","FiledID":"4f2ca14a-5a15-47f0-95e2-52746c4abeb7","PondName":"肥东县程继来家庭农场场地","Electrics":"1-增氧机,2-增氧机"}]
*/
@interface YYCollectorInfo : NSObject

@property(nonatomic,strong) NSString *CustomerNo;
@property(nonatomic,assign) int UserType;
@property(nonatomic,strong) NSString *CollectorID;
@property(nonatomic,strong) NSString *DeviceID;
@property(nonatomic,strong) NSString *ProvinceName;
@property(nonatomic,strong) NSString *CityName;
@property(nonatomic,strong) NSString *OrgName;
@property(nonatomic,strong) NSString *FiledID;
@property(nonatomic,strong) NSString *PondName;
@property(nonatomic,strong) NSString *Electrics;
@property(nonatomic,strong) NSArray  *electricsArr;
@property(nonatomic,strong) NSString *electricsStatus;

@property(nonatomic,assign) BOOL expandYN;
@property(nonatomic,assign) int  day;//0--今天,1--昨天,2--前天
@property(nonatomic,strong) NSDictionary *historyDict;


@property(nonatomic,assign) int upperValue;
@property(nonatomic,assign) int upperValueChange;
@property(nonatomic,assign) int lowerValue;
@property(nonatomic,assign) int lowerValueChange;
@property(nonatomic,assign) int mode;
@property(nonatomic,assign) int time;
@property(nonatomic,assign) int timeChange;


@property(nonatomic,strong)  NSArray<YYCollectorSensor *>* sensorList;

@end
/*
  GetNewsListResult = "[{\"articleid\":\"3070cb88-b14a-48db-a7cd-f2c4faa1476e\",\"title\":\"\U9c7c\U5858\U5927\U91cf\U9c7c\U867e\U6b7b\U4ea1\Uff0c\U517b\U6b96\U6237\U7591\U9972\U6599\U6240\U81f4\",\"createddate\":\"2016-10-18T16:51:38\",\"url\":\"http://183.78.182.98:9005/PagesBaseInfo/NewsViewMobile.aspx?ID=3070cb88-b14a-48db-a7cd-f2c4faa1476e\"}]";
 
   GetNewsListResult = "[{\"articleid\":\"8f723715-1114-4925-b89a-50fafc1c3e71\",\"title\":\"\U770b\U4e86\U8fd9\U4e2a\Uff0c\U60a8\U5c31\U77e5\U9053\U6c60\U5858\U6392\U6c61\U6709\U591a\U91cd\U8981\U4e86\Uff01\",\"createddate\":\"2016-10-18T16:56:32\",\"url\":\"http://183.78.182.98:9005/PagesBaseInfo/NewsViewMobile.aspx?ID=8f723715-1114-4925-b89a-50fafc1c3e71\"}]";
 
 */
@interface YYNews : NSObject

@property(nonatomic,strong) NSString *articleid;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *createddate;
@property(nonatomic,strong) NSString *url;


@end
/*
{\"F_ReceivedTime\":0,\"F_Param1\":6.59,\"F_Param3\":7.99,\"F_Param4\":0.28,\"F_Param5\":15.30,\"F_Param6\":0.06,\"F_Param8\":0.00,\"F_Param2\":null,\"F_Param7\":0.00,\"F_Param9\":0.00,\"F_Param10\":null,\"F_Param11\":null,\"F_Param12\":null,\"F_Param13\":null,\"F_Param14\":null,\"F_Param15\":null,\"F_Param16\":null,\"F_Param17\":null,\"F_Param18\":null}
 */
@interface YYHistoryData : NSObject
@property(nonatomic,strong) NSNumber *F_ReceivedTime;
@property(nonatomic,strong) NSNumber *F_Param1;
@property(nonatomic,strong) NSNumber *F_Param2;
@property(nonatomic,strong) NSNumber *F_Param3;
@property(nonatomic,strong) NSNumber *F_Param4;
@property(nonatomic,strong) NSNumber *F_Param5;
@property(nonatomic,strong) NSNumber *F_Param6;
@property(nonatomic,strong) NSNumber *F_Param7;
@property(nonatomic,strong) NSNumber *F_Param8;
@property(nonatomic,strong) NSNumber *F_Param9;
@property(nonatomic,strong) NSNumber *F_Param10;
@property(nonatomic,strong) NSNumber *F_Param11;
@property(nonatomic,strong) NSNumber *F_Param12;
@property(nonatomic,strong) NSNumber *F_Param13;
@property(nonatomic,strong) NSNumber *F_Param14;
@property(nonatomic,strong) NSNumber *F_Param15;
@property(nonatomic,strong) NSNumber *F_Param16;
@property(nonatomic,strong) NSNumber *F_Param17;
@property(nonatomic,strong) NSNumber *F_Param18;
@end

@interface HistoryWantData : NSObject

@property(nonatomic,assign) int detectType;//监测类型 0x01 --- 0x12
@property(nonatomic,assign) int time;
@property(nonatomic,assign) float value;
@property(nonatomic,assign) int index;

@end
/*

\"F_ID\": \"a61bbffb-31a9-408a-87fa-26236f6b13d7\",
\"F_CollectorID\": \"\",
\"F_Name\": \"\U89c6\U9891\U56db\",
\"F_UserName\": \"admin\",
\"F_UserPwd\": \"ch123456\",
\"F_OutIPAddr\": \"www.hik-online.com|tld42345678\",
\"F_IndexCode\": 4
*/
@interface YYVideoInfo : NSObject
@property(nonatomic,strong) NSString *F_ID;
@property(nonatomic,strong) NSString *F_CollectorID;
@property(nonatomic,strong) NSString *F_Name;
@property(nonatomic,strong) NSString *F_UserName;
@property(nonatomic,strong) NSString *F_UserPwd;
@property(nonatomic,strong) NSString *F_OutIPAddr;
@property(nonatomic,assign) NSNumber *F_IndexCode;



@end

@interface YYUserInfo : NSObject
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *CustomerNo;
@property(nonatomic,strong) NSString *UserAccount;
@property(nonatomic,strong) NSString *Xm;
@property(nonatomic,strong) NSString *companyid;
@end



@interface YYPacket : NSObject

-(instancetype)initWithByteArray:(Byte *)bytes;
-(NSData *)toNSData;


@property(nonatomic,assign) Byte frameHeader;  //0
@property(nonatomic,assign) short productInfo; //1-2
@property(nonatomic,assign) Byte version;//3
@property(nonatomic,assign) short deviceType;//4-5
@property(nonatomic,strong) NSString *deviceAddress;//6-9
@property(nonatomic,assign) Byte* cmdSerialNumber;//10-17
@property(nonatomic,assign) short cmdword;//18-19 命令字
@property(nonatomic,assign) Byte flag;//20 操作标志
@property(nonatomic,assign) short length;//21-22 数据包长度 N
@property(nonatomic,assign) Byte* contents;//具体数据
@property(nonatomic,assign) short checkCode;//校验和 23+N-24+N
@property(nonatomic,assign) Byte frameFooter;//帧尾  25+N

@property(nonatomic,strong) NSDictionary *dict;

@end

