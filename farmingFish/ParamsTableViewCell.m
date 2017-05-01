//
//  ParamsTableViewCell.m
//  farmingFish
//
//  Created by apple on 2016/11/22.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "ParamsTableViewCell.h"

@interface ParamsTableViewCell()<UITextFieldDelegate>{
    
}


@end

@implementation ParamsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.upperValueTF.delegate=self;
    self.lowerValueTF.delegate=self;
    
    [_upperValueTF.layer setBorderWidth:1];
    _upperValueTF.layer.cornerRadius=2;
    [_upperValueTF.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
    
    [_lowerValueTF.layer setBorderWidth:1];
    _lowerValueTF.layer.cornerRadius=2;
    [_lowerValueTF.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
    
    
  
    
    _upperValueTF.delegate=self;
    _upperValueTF.inputAccessoryView=[self addToolbar];
    _lowerValueTF.delegate=self;
    _lowerValueTF.inputAccessoryView=[self addToolbar];
    [_upperValueTF addTarget:self action:@selector(textFieldTextChange:)  forControlEvents:UIControlEventEditingChanged];
    [_upperValueTF setTag:0];
    
    [_lowerValueTF addTarget:self action:@selector(textFieldTextChange:)  forControlEvents:UIControlEventEditingChanged];
    [_lowerValueTF setTag:1];
    


}

-(void)textFieldTextChange:(UITextField *)textField{
    NSLog(@"textField - 输入框内容改变,当前内容为: %@",textField.text);
    float value=textField.text.floatValue;
    
    switch (textField.tag) {
        case 0:
            [_sensor setF_UpperChange:[NSNumber numberWithFloat:value]];
            break;
        case 1:
             [_sensor setF_LowerChange:[NSNumber numberWithFloat:value]];
            break;
      
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
