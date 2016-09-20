//
//  SocketService.h
//  farmingFish
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketService : NSObject

+(instancetype)shareInstance;

-(void)connect;
-(void)sendControlCmd:(int)cmdval number:(int)num devId:(NSString *)devId;

@end
