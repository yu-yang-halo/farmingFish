//
//  ParamsTableViewCell.h
//  farmingFish
//
//  Created by apple on 2016/11/22.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanObject.h"
@protocol TextFieldActiveHandler <NSObject>

-(void)handleTextField:(UITextField *)activeTF;

@end

@interface ParamsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *upperValueTF;
@property (weak, nonatomic) IBOutlet UITextField *lowerValueTF;
@property(weak,nonatomic) id<TextFieldActiveHandler> handler;

@property(weak,nonatomic) YYCollectorSensor *sensor;

@end
