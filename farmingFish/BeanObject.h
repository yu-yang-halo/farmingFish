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