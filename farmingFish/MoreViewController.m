//
//  MoreViewController.m
//  farmingFish
//
//  Created by apple on 2016/11/6.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "MoreViewController.h"
#import "UIViewController+Extension.h"
@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *itemTitles;
@property(nonatomic,strong) NSArray *itemImages;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerBGInit];
    self.itemTitles=@[@"知识库",@"历史数据"];
    self.itemImages=@[@"main_news",@"main_history"];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) style:(UITableViewStylePlain)];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    [self.view addSubview:_tableView];
    
    
    
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
 
    return [_itemTitles count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"itemCell"];
       
       
        
    }
    
    [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
    
    UIView *bgView=[[UIView alloc] initWithFrame:cell.bounds];
    
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    [cell setSelectedBackgroundView:bgView];

    
    cell.textLabel.text=_itemTitles[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:_itemImages[indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:tldCellFontSize]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *newsVC=[storyBoard instantiateViewControllerWithIdentifier:@"newsVC"];
    
    UIViewController *historyVC=[storyBoard instantiateViewControllerWithIdentifier:@"historyVC"];
    
    UIViewController *settingsVC=[storyBoard instantiateViewControllerWithIdentifier:@"settingsVC"];
    
    
    switch (indexPath.row) {
        case 0:
            
            [self.tabBarController.navigationController pushViewController:newsVC animated:YES];
            break;
        case 1:
             [self.tabBarController.navigationController pushViewController:historyVC animated:YES];
            break;

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
