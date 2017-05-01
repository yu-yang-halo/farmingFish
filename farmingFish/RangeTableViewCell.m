//
//  RangeTableViewCell.m
//  farmingFish
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 雨神 623240480@qq.com. All rights reserved.
//

#import "RangeTableViewCell.h"
#import "SocketService.h"
#import "AppDelegate.h"
@interface RangeTableViewCell()<UITextFieldDelegate>{
    
}
@end
@implementation RangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_upperTF.layer setBorderWidth:1];
    _upperTF.layer.cornerRadius=2;
    [_upperTF.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
    
    [_lowerTF.layer setBorderWidth:1];
    _lowerTF.layer.cornerRadius=2;
    [_lowerTF.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
    
    
    [_timeTF.layer setBorderWidth:1];
    _timeTF.layer.cornerRadius=2;
    [_timeTF.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
    
    _upperTF.delegate=self;
    _upperTF.inputAccessoryView=[self addToolbar];
    _lowerTF.delegate=self;
    _lowerTF.inputAccessoryView=[self addToolbar];
    _timeTF.delegate=self;
    _timeTF.inputAccessoryView=[self addToolbar];

    [_upperTF addTarget:self action:@selector(textFieldTextChange:)  forControlEvents:UIControlEventEditingChanged];
    [_upperTF setTag:0];
    
    [_lowerTF addTarget:self action:@selector(textFieldTextChange:)  forControlEvents:UIControlEventEditingChanged];
     [_lowerTF setTag:1];
    
    [_timeTF addTarget:self action:@selector(textFieldTextChange:)  forControlEvents:UIControlEventEditingChanged];
     [_timeTF setTag:2];
}

-(void)textFieldTextChange:(UITextField *)textField{
    NSLog(@"textField - 输入框内容改变,当前内容为: %@",textField.text);
    int value=textField.text.intValue;
    switch (textField.tag) {
        case 0:
            [_collectorInfo setUpperValueChange:value];
            break;
        case 1:
            [_collectorInfo setLowerValueChange:value];
            break;
        case 2:
             [_collectorInfo setTimeChange:value];
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)modeSwitch:(UISwitch *)sender {
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    [delegate setOnlyFirst:YES];
    [delegate showLoading:@"设置中..."];
    if(sender.isOn){
        [_modeText setText:@"自动"];
        [[SocketService shareInstance] modeSwith:MethodType_POST mode:MODE_TYPE_AUTO devId:_collectorInfo.CustomerNo];
    }else{
        [_modeText setText:@"手动"];
        [[SocketService shareInstance] modeSwith:MethodType_POST mode:MODE_TYPE_MENUAL devId:_collectorInfo.CustomerNo];
    }
    
}

-(void)textFieldDone{
    [self endEditing:YES];
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];
   
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[ space, bar];
    return toolbar;
}
@end
