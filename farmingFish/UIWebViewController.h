//
//  UIWebViewController.h
//  farmingFish
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewController : UIViewController
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,strong) NSString *url;
@end
