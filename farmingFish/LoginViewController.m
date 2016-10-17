//
//  ViewController.m
//  farmingFish
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Extension.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import "AppDelegate.h"
#import "FService.h"
#import "SocketService.h"
const static NSString *KEY_USERNAME=@"username-key";
const static NSString *KEY_PASSWORD=@"password-key";
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginClick:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     *  界面样式设置
     */
    self.loginButton.layer.cornerRadius=23;
//    self.loginButton.layer.borderWidth=1;
//    self.loginButton.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.6] CGColor];
//    
//    [self.loginButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
//    
    
    _usernameTF.delegate=self;
    _passwordTF.delegate=self;
    
    
    
    //[self viewControllerBGInit];
    [self.view setBackgroundColor:[UIColor whiteColor]];
      
    [self initUsernameOrPwd];
    
    
    [self flyIconToFace];
    
   
}

-(void)initUsernameOrPwd{
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
    NSString *pwd=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    if(username!=nil){
        _usernameTF.text=username;
    }
    if(pwd!=nil){
        _passwordTF.text=pwd;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)stringIsEmpty:(NSString *)str{
    if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        return YES;
    }else{
        return NO;
    }
}

- (IBAction)loginClick:(id)sender {
    
    NSString *username=_usernameTF.text;
    NSString *password=_passwordTF.text;
    
    if([self stringIsEmpty:username]){
        [self.view makeToast:@"用户名不能为空"];
        return;
    }
    if([self stringIsEmpty:password]){
        [self.view makeToast:@"密码不能为空"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
   
   
    hud.label.text = @"登录中...";
   // [self performSegueWithIdentifier:@"toMainPage" sender:sender];
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *customerNo=[[FService shareInstance] loginName:username password:password];
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if(customerNo==nil){
                [self.view makeToast:@"用户名或密码错误"];
            }else{
                [self performSegueWithIdentifier:@"toMainPage" sender:sender];
                
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_USERNAME];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
                
                AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
                [delegate setCustomerNo:customerNo];
                [delegate setUserAccount:username];
                
            }
            
            
        });
    });
    
    
    
}

#pragma mark delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
