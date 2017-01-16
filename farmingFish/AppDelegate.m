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
#import <JZLocationConverter/JZLocationConverter.h>
#import "Reachability.h"
#import "UIView+Toast.h"
#import "FService.h"
@interface AppDelegate ()<BMKLocationServiceDelegate>
{
    BMKMapManager *mapManager;
    BMKLocationService *locService;
}
@property(nonatomic,strong)   CLGeocoder *geocoder;
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
    

    [self networkEnvInit];
    
    
    [[FService shareInstance] GetCollectorSensorList:@"68eeffe7-9561-4a0f-9a7d-751c4cca98fe" sensorId:@"1" collectType:@"1"];
    
    
    return YES;
}

-(void)networkEnvInit{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability *reach)
    {
        NSLog(@"网络连接成功。。。");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.isReachableWiFi=reach.isReachableViaWiFi;
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reach)
    {
        NSLog(@"网络连接失败。。。");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachableWiFi=reach.isReachableViaWiFi;
            [[[UIApplication sharedApplication] keyWindow] makeToast:@"网络已断开,请检查您的网络状态"];
        });
        
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

-(void)locMyPosition{
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc] init];
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
    
    self.geocoder=[[CLGeocoder alloc] init];
    
    double lat=userLocation.location.coordinate.latitude;
    double lgt=userLocation.location.coordinate.longitude;
    self.myLocation=CLLocationCoordinate2DMake(lat, lgt);
    
    
    [self reverseGeocode:userLocation.location.coordinate];
    
    
}

- (void)reverseGeocode:(CLLocationCoordinate2D)coord
{
    
    CLLocation *loc;
    
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion>=19)
    {
        CLLocationCoordinate2D wgs84ToGcj02 = [JZLocationConverter bd09ToGcj02:coord];
        loc = [[CLLocation alloc] initWithLatitude:wgs84ToGcj02.latitude longitude:wgs84ToGcj02.longitude];
    }
    else
    {
        loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    
    // 反地理编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error!=nil) {
            //NSLog(@"*********%@*****",error);
        }else{
            for (CLPlacemark *mark in placemarks) {
                //NSLog(@"%@ ",mark.locality);
                
                [[NSUserDefaults standardUserDefaults] setObject:mark.locality forKey:@"city"];
            }
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
