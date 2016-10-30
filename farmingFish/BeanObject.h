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



