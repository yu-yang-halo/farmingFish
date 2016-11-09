//
//  ViewController.m
//  farmingFish
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import "AppDelegate.h"
#import "FService.h"
#import "SocketService.h"
#import "MainViewController.h"
#import "UIViewController+Extension.h"
const static NSString *KEY_USERNAME=@"username-key";
const static NSString *KEY_PASSWORD=@"password-key";
const static NSString *KEY_REMEMBER=@"remember-key";
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     *  界面样式设置
     */
    self.loginButton.layer.cornerRadius=23;
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:nil action:nil];
    
    _usernameTF.delegate=self;
    _passwordTF.delegate=self;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
      
    [self initUsernameOrPwd];
    
    [self versionLabelInit];
    

    
    [self flyIconToFace];
    
   
    [_checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    
}
-(void)checkClick:(UIButton *)sender{
    [sender setSelected:!sender.selected];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.selected) forKey:KEY_REMEMBER];
    [self initUsernameOrPwd];
}

-(void)initUsernameOrPwd{
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
    NSString *pwd=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    if(username!=nil){
        _usernameTF.text=username;
    }
    id rememberObj=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REMEMBER];
    if(rememberObj==nil){
        [_checkBtn setSelected:NO];
    }else{
        if([rememberObj boolValue]){
             [_checkBtn setSelected:YES];
        }else{
             [_checkBtn setSelected:NO];
        }
    }
    
    if(_checkBtn.selected){
        if(pwd!=nil){
            _passwordTF.text=pwd;
        }
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASSWORD];
        _passwordTF.text=@"";
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
        NSString *result=[[FService shareInstance] loginName:username password:password];
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if(result==nil){
                [self.view makeToast:@"无法连接网络"];
            }else{
                
                if([result isEqualToString:@"500"]){
                    [self.view makeToast:@"服务器内部错误"];
                    return ;
                }else if([result isEqualToString:@"ERROR"]){
                    [self.view makeToast:@"用户名或密码错误"];
                    return ;
                }else{
                    
                    [self performSegueWithIdentifier:@"toMainPage" sender:sender];
                
                    
                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_USERNAME];
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
                    
                    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
                    [delegate setCustomerNo:result];
                    [delegate setUserAccount:username];
                }
                
                
                
            }
            
            
        });
    });
    
    
    
}

-(void)versionLabelInit{
    NSDictionary *infoDict=[[NSBundle mainBundle] infoDictionary];
    
    self.versionLabel.text=[NSString stringWithFormat:@"当前版本 v%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
}

#pragma mark delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
