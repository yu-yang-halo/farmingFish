//
//  SettingsViewController.m
//  farmingFish
//
//  Created by apple on 16/10/16.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+Extension.h"
#import "ParamsTableViewCell.h"
@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,TextFieldActiveHandler>

@property(nonatomic,strong) NSArray *contents;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"个人中心";
    [self viewControllerBGInitWhite];
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick:)];
    
    
    [self.tableView addGestureRecognizer:tapGR];
    
    
    self.contents=@[@"溶氧下限",@"溶氧上限",@"pH值下限",@"pH值上限",@"氨氮下限",@"氨氮上限",@"亚硝酸盐上限",@"亚硝酸盐下限",@"增氧机开启时间",@"增氧机关闭时间"];
    

    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_contents count];
}

-(void)tableViewClick:(id)sender{
    
    [self.activeTF resignFirstResponder];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"paramsCell";
    
    ParamsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ParamsTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelected:NO];
     cell.nameLabel.text=[_contents objectAtIndex:indexPath.row];
     cell.valueTF.text=@"1.0";
     cell.handler=self;
    
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    
    return cell;
}
-(void)handleTextField:(UITextField *)activeTF{
    self.activeTF=activeTF;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
