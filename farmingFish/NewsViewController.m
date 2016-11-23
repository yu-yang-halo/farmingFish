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
#import "FService.h"
#import "BeanObject.h"
#import "BeanObjectHelper.h"
#import "JSONKit.h"
#import "UIWebViewController.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong) NSMutableArray *newsList;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
     self.title=@"知识库";
    [self viewControllerBGInitWhite];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-tldTabBarHeight)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
   // [_tableView setSeparatorColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    
    [self.view addSubview:_tableView];
    [self loadNewsData];
}


-(void)loadNewsData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        id retObj=[[FService shareInstance] GetNewsList:CATEGORYID_KNOWLEDGE number:10];
        
        self.newsList=[NSMutableArray new];
        
        if(retObj!=nil){
            NSArray *arr=[[retObj objectForKey:@"GetNewsListResult"] objectFromJSONString];
            if(arr!=nil&&[arr count]>0){
                
                for(NSDictionary *dict in arr){
                    YYNews *news=[[YYNews alloc] init];
                    [BeanObjectHelper dictionaryToBeanObject:dict beanObj:news];
                    
                    NSLog(@"news :: %@",news);
                    
                    
                    [self.newsList addObject:news];
                    
                }
            }
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}

-(void)click:(id)sender{
    NSLog(@"sender %@",sender);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_newsList==nil){
        return 0;
    }
    return [_newsList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *selView=[[UIView alloc] initWithFrame:cell.bounds];
    [selView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selView];
    
    
    YYNews *yyNews=[_newsList objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text=yyNews.title;
    
    cell.textLabel.textColor=[UIColor colorWithWhite:0.1 alpha:0.5];
    
    return cell;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [_tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    YYNews *yyNews=[_newsList objectAtIndex:indexPath.row];
    

    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIWebViewController *webVC=[storyBoard instantiateViewControllerWithIdentifier:@"webVC"];
    
    webVC.url=yyNews.url;
    webVC.title=yyNews.title;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
