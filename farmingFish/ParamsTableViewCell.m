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
     self.valueTF.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_handler handleTextField:textField];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
