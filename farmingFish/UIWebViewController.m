//
//  UIWebViewController.m
//  farmingFish
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "UIWebViewController.h"
#import "UIViewController+Extension.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface UIWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    
    [self viewControllerBGInit];
    
    [self.view addSubview:_webView];
    
    _webView.delegate=self;
    [_webView setBackgroundColor:[UIColor clearColor]];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark webviewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
 
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text=@"加载中...";
    [_hud showAnimated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(_hud!=nil){
        [_hud hideAnimated:YES];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"error:%@",error);
}
@end
