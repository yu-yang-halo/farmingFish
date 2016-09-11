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

static FService *instance;
const static NSString* WEBSERVICE_URL=@"http://183.78.182.98:9110/service.svc/";
@implementation FService
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[FService alloc] init];
    }
    return instance;
}

-(void)loginName:(NSString *)name password:(NSString *)pass{
    
    
    NSDictionary *parameters=@{@"userAccount":name,@"userPwd":pass};
    
    NSString *loginREQ_URL=[NSString stringWithFormat:@"%@Login",WEBSERVICE_URL];
    
    NSData *retResult=[self requestURLSyncPOST:loginREQ_URL postBody:[parameters JSONData]];
    
    NSLog(@"result::: %@", [retResult objectFromJSONData]);
    
    
}

-(NSData *)requestURLSyncPOST:(NSString *)service postBody:(NSData *)postBody{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    
    
    NSString *str=[[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding];
    NSLog(@"STR %@",str);
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7" forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        
        return data;
    }else{
        NSString *errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[error] %@",errorDescription);
        });
    }
    return nil;
}

@end
