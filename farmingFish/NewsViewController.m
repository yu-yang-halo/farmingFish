//
//  NewsViewController.m
//  farmingFish
//
//  Created by apple on 16/10/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "NewsViewController.h"
#import "UIViewController+Extension.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface NewsViewController ()<UIWebViewDelegate>{
    
}

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) MBProgressHUD *hud;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
     self.title=@"养殖知识";
    [self viewControllerBGInit];
    

    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-30)];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    _webView.opaque=NO;
    
    
    [_webView setDelegate:self];
   
    
    [self.view addSubview:_webView];
    
    NSString *url=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"fish.html"];
    NSLog(@"URL %@",url);
 
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
  
    
    
}
-(void)click:(id)sender{
    NSLog(@"sender %@",sender);
    if(_webView.canGoBack){
        [_webView goBack];
    }
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


- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.hud=[MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [_hud showAnimated:YES];
    
   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud hideAnimated:YES];
    if(_webView.canGoBack){
         self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStyleDone target:self action:@selector(click:)];
    }else{
         self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(click:)];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
}

@end
