//
//  FService.m
//  farmingFish
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "JSONKit.h"
#import "FService.h"
#import "DateHelper.h"
#import "BeanObjectHelper.h"
#import "ConstansManager.h"
#import <objc/runtime.h>
static FService *instance;
const static NSString* WEBSERVICE_URL=@"http://183.78.182.98:9110/service.svc/";
const static NSString* REQUEST_ALERT_URL=@"http://183.78.182.98:9005/AppService/AppHandler.ashx";

@implementation FService
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[FService alloc] init];
    }
    return instance;
}
-(id)loginN:(NSString *)name password:(NSString *)pass{
    NSDictionary *parameters=@{@"userAccount":name,@"userPwd":pass};
    
    NSString *loginREQ_URL=[NSString stringWithFormat:@"%@LoginN",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:loginREQ_URL postBody:[parameters JSONData]];
    
    NSLog(@"str value: %@",[[NSString alloc] initWithData:retResult encoding:NSUTF8StringEncoding]);
    
    NSLog(@"result::: %@", [retResult objectFromJSONData]);
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    
    if(retObj==nil){
        return nil;
    }else{
        id result=[retObj objectForKey:@"LoginNResult"];
        
        return result;
    }
  
}

-(NSString *)loginName:(NSString *)name password:(NSString *)pass{
    
    
    NSDictionary *parameters=@{@"userAccount":name,@"userPwd":pass};
    
    NSString *loginREQ_URL=[NSString stringWithFormat:@"%@Login",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:loginREQ_URL postBody:[parameters JSONData]];
    
    NSLog(@"str value: %@",[[NSString alloc] initWithData:retResult encoding:NSUTF8StringEncoding]);
    
    NSLog(@"result::: %@", [retResult objectFromJSONData]);
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    
    if(retObj==nil){
        return nil;
    }else{
        id result=[retObj objectForKey:@"LoginResult"];
        
        return result;
    }
    
}
-(id)GetCollectorData:(NSString *)DeviceId day:(int)day{
    NSString *dateStr=[DateHelper GetLastDay:day];

    NSLog(@"%d day is %@",day,dateStr);
    
    return [self GetCollectorData:DeviceId dateTime:dateStr];
    
}

-(id)GetCollectorData:(NSString *)DeviceId dateTime:(NSString *)date{
    NSMutableArray *currentHistoryArrs=[NSMutableArray new];
    NSDictionary *parameters=@{@"collectorId":DeviceId,@"dateTime":date};
    
    NSString *collectorInfoREQ_URL=[NSString stringWithFormat:@"%@GetCollectorData",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:collectorInfoREQ_URL postBody:[parameters JSONData]];
    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetCollectorData::: %@", retObj);
    
    
    NSArray *dataResultArrs=[[retObj objectForKey:@"GetCollectorDataResult"] objectFromJSONString];
    
    if(dataResultArrs!=nil){
        for(NSDictionary *dict in dataResultArrs){
            YYHistoryData *info=[[YYHistoryData alloc] init];
            [BeanObjectHelper dictionaryToBeanObject:dict beanObj:info];
            
            [currentHistoryArrs addObject:info];
        }
    }
   
    return  [self convertHistoryData:currentHistoryArrs];
}

-(NSDictionary *)convertHistoryData:(NSArray<YYHistoryData *> *)datas{
    NSMutableDictionary *dicts=[NSMutableDictionary new];
    for(YYHistoryData *data  in datas){
        int count=0;
        objc_property_t *properties = class_copyPropertyList([data class], &count);
        for(int i=0;i<count;i++){
            objc_property_t property = properties[i];
            NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            //kvc读值
            if([key containsString:@"F_Param"]){
                NSString *value = [data valueForKey:key];
                NSLog(@"%@->%@",key,value);
                
                NSString *type=[key substringFromIndex:[@"F_Param" length]];
                NSLog(@"type %@",type);
                
                if(value!=nil&&[value isKindOfClass:[NSNumber class]]&&[value floatValue]!=0){
                    NSMutableArray *items=[dicts objectForKey:@(type.intValue)];
                    
                    if(items==nil){
                        items=[NSMutableArray new];
                    }
                    HistoryWantData *wantData=[[HistoryWantData alloc] init];
                    wantData.detectType=type.intValue;
                    wantData.value=value.floatValue;
                    wantData.time=data.F_ReceivedTime.intValue;
                    wantData.index=[ConstansManager indexForKeyInt:@(type.intValue)];
                    
                    
                    
                    NSLog(@"%d %d %f ",wantData.detectType,wantData.time,wantData.value);
                    
                    
                    
                    [items addObject:wantData];
                    
                    [dicts setObject:items forKey:@(type.intValue)];

                    
                }
                
                
            }
           
        }
        
    }
    
   
    
    return dicts;
}


-(id)GetVideoInfo:(NSString *)fieldId{
    NSDictionary *parameters=@{@"fieldId":fieldId};
    
    NSString *collectorInfoREQ_URL=[NSString stringWithFormat:@"%@GetVideoInfo",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:collectorInfoREQ_URL postBody:[parameters JSONData]];
    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetVideoInfo::: %@", retObj);
    
    return retObj;

}
-(id)GetUserVideoInfo:(NSString *)userAccount{
    if(userAccount==nil){
        return nil;
    }
    NSDictionary *parameters=@{@"userAccount":userAccount};
    
    NSString *collectorInfoREQ_URL=[NSString stringWithFormat:@"%@GetUserVideoInfo",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:collectorInfoREQ_URL postBody:[parameters JSONData]];
    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    // NSLog(@"GetUserVideoInfo::: %@", retObj);
    
    if(retObj==nil){
        return nil;
    }
    
    NSMutableArray<YYVideoInfo *> *videoInfoArrs=[NSMutableArray new];
    
    NSArray *dataResultArrs=[[retObj objectForKey:@"GetUserVideoInfoResult"] objectFromJSONString];
    
    if(dataResultArrs!=nil){
        for(NSDictionary *dict in dataResultArrs){
            YYVideoInfo *info=[[YYVideoInfo alloc] init];
            [BeanObjectHelper dictionaryToBeanObject:dict beanObj:info];
            
            [videoInfoArrs addObject:info];
        }
        
        videoInfoArrs=[videoInfoArrs sortedArrayUsingComparator:^NSComparisonResult(YYVideoInfo*  obj1,YYVideoInfo *obj2) {
           
            if(obj1.F_IndexCode.intValue>=obj2.F_IndexCode.intValue){
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
            
        }];
    }
    
    
    return videoInfoArrs;
}
-(id)GetCollectorInfo:(NSString *)customerNo userAccount:(NSString *)ua{
    NSDictionary *parameters=@{@"customerNo":customerNo,@"userAccount":ua};
    
    NSString *collectorInfoREQ_URL=[NSString stringWithFormat:@"%@GetCollectorInfo",WEBSERVICE_URL];
     NSLog(@"collectorInfoREQ_URL::: %@", collectorInfoREQ_URL);
    NSData *retResult=[self requestURLSyncPOST:collectorInfoREQ_URL postBody:[parameters JSONData]];
    
   
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetCollectorInfo::: %@", retObj);
    
    return retObj;
 
}
-(id)GetNewsList:(CATEGORYID)categoryId number:(int)num{
    NSDictionary *parameters=@{@"categoryId":@(categoryId),@"num":@(num)};
    
    NSString *collectorInfoREQ_URL=[NSString stringWithFormat:@"%@GetNewsList",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:collectorInfoREQ_URL postBody:[parameters JSONData]];
    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetNewsList::: %@", retObj);
    
    return retObj;
}
-(NSData *)dictionaryToKeyValueData:(NSDictionary *)params{
    NSMutableString *kvStr=[NSMutableString new];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [kvStr appendFormat:@"%@=%@&",key,obj];
        
        
    }];
    
    [kvStr replaceCharactersInRange:NSMakeRange(kvStr.length-1, 1) withString:@""];
    
    NSLog(@"kvStr %@",kvStr);
    
    NSData *body=[kvStr dataUsingEncoding:(NSUTF8StringEncoding)];
    return body;
}
-(id)GetWarningList:(NSString *)companyId collectorId:(NSString *)collectorId startTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDictionary *parameters=@{@"CmdID":@"GetWarningList",@"CollectorID":collectorId,@"CompanyID":companyId,@"BeginDateTime":startTime,@"EndDateTime":endTime};
    
    
    
    NSData *body=[self dictionaryToKeyValueData:parameters];
    
    NSData *retResult=[self requestURLSyncPOSTKV:REQUEST_ALERT_URL postBody:body];

    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetWarningList::: %@", retObj);
    
    return retObj;
}

-(id)GetCollectorSensorList:(NSString *)collectorId sensorId:(NSString *)sensorId collectType:(NSString *)collectType{
    
    NSDictionary *parameters=@{@"CmdID":@"GetCollecotSensorList",@"CollectorID":collectorId,@"SensorID":sensorId,@"CollectType":collectType};

    
   
    NSData *body=[self dictionaryToKeyValueData:parameters];
    
    NSData *retResult=[self requestURLSyncPOSTKV:REQUEST_ALERT_URL postBody:body];
    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"GetCollectorSensorList::: %@", retObj);

    
    return retObj;
}
-(id)SetCollectorSensor:(NSString *)collectorId sensorId:(NSString *)sensorId paramId:(int)paramId LowerValue:(float)lowerValue UpperValue:(float)upperValue IsWarning:(short)iswarning{
    NSDictionary *parameters=@{@"CmdID":@"SetCollectorSensor",@"CollectorID":collectorId,@"SensorID":sensorId,@"ParamID":[NSString stringWithFormat:@"%d",paramId],@"LowerValue":@(lowerValue),@"UpperValue":@(upperValue),@"IsWarning":@(iswarning)};
    
    
    NSData *body=[self dictionaryToKeyValueData:parameters];
    
    NSData *retResult=[self requestURLSyncPOSTKV:REQUEST_ALERT_URL postBody:body];

    
    
    
    NSDictionary *retObj=[retResult objectFromJSONData];
    NSLog(@"SetCollectorSensor::: %@", retObj);
    return retObj;
}


-(NSData *)requestURLSyncPOSTKV:(NSString *)service postBody:(NSData *)postBody{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7" forHTTPHeaderField:@"User-Agent"];
    
    
    NSHTTPURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        if(response.statusCode==200){
            return data;
        }else{
            NSString *str=@"{\"LoginNResult\":\"500\"}";
            
            return [str dataUsingEncoding:(NSUTF8StringEncoding)];
        }
    }else{
        NSString *errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[error] %@",errorDescription);
        });
        
        
    }
    return nil;
}

-(NSData *)requestURLSyncPOST:(NSString *)service postBody:(NSData *)postBody{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7" forHTTPHeaderField:@"User-Agent"];
    
    
    NSHTTPURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        if(response.statusCode==200){
            return data;
        }else{
            NSString *str=@"{\"LoginNResult\":\"500\"}";
            
            return [str dataUsingEncoding:(NSUTF8StringEncoding)];
        }
    }else{
        NSString *errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[error] %@",errorDescription);
        });
        
        
    }
    return nil;
}

@end
