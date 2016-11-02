//
//  AppDelegate.m
//  farmingFish
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "AppDelegate.h"
#import "SocketService.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
@interface AppDelegate ()<BMKLocationServiceDelegate>
{
    BMKMapManager *mapManager;
    BMKLocationService *locService;
}
@property(nonatomic,assign) CLLocationCoordinate2D myLocation;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     NSLog(@"didFinishLaunchingWithOptions...");
    
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"r3ZVUYbY8K40NBY4D11uchiKIbPHBATj"  generalDelegate:nil];
    //r3ZVUYbY8K40NBY4D11uchiKIbPHBATj
    //zM1g4ZYRsDAQAfK8kiZtVBiVx3FPo9Tj
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success");
        [self locMyPosition];
    }
    

    
    return YES;
}
-(void)locMyPosition{
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // NSLog(@"heading is %@ userLocation::%@",userLocation.heading,userLocation);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //[self.eventDelegate onLocationComplete:userLocation];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    
    double lat=userLocation.location.coordinate.latitude;
    double lgt=userLocation.location.coordinate.longitude;
    

    CLLocation *location=[[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    self.myLocation=CLLocationCoordinate2DMake(lat, lgt);
    
    
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        for (CLPlacemark *mark in placemarks) {
            NSLog(@"%@ : %@ ",mark.thoroughfare,mark.locality);
            
            [[NSUserDefaults standardUserDefaults] setObject:mark.locality forKey:@"city"];
        }
        
        
    }];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //NSLog(@"applicationWillResignActive...");
    [[SocketService shareInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //NSLog(@"applicationDidEnterBackground...");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // NSLog(@"applicationWillEnterForeground...");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     // NSLog(@"applicationDidBecomeActive...");
    [[SocketService shareInstance] applicationDidBecomeActive:application];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
     // NSLog(@"applicationWillTerminate...");
}

@end
