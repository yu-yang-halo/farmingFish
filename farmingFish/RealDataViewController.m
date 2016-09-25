//
//  RealDataViewController.m
//  farmingFish
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "RealDataViewController.h"
#import "UIViewController+Extension.h"
#import "SocketService.h"
#import "YYStatusView.h"
#import "RealDataTableView.h"
@interface RealDataViewController ()
@property(nonatomic,strong) UIScrollView *globalView;
@property(nonatomic,strong) RealDataTableView *realDataView;
@property(nonatomic,strong) NSMutableArray *statusArr;

@end

@implementation RealDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"实时数据";
    [self navigationBarInit];
    [self viewControllerBGInit];
    
    [self viewInit];
    
    
}
/*
 *代码布局view
 */
-(void)viewInit{
    self.globalView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_globalView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    self.realDataView=[[RealDataTableView alloc] initWithFrame:CGRectMake(10,10, _globalView.frame.size.width-20, 200)];
    
    _realDataView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    _realDataView.layer.borderWidth=1;
    _realDataView.layer.cornerRadius=2;
    [_realDataView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.1]];
    
    

    
    
    
    [self.globalView addSubview:_realDataView];
    [self.view addSubview:_globalView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[SocketService shareInstance] connect];
    [[SocketService shareInstance] setStatusBlock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        self.statusArr=[NSMutableArray new];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if([key isKindOfClass:[NSNumber class]]){
                /*
                 * 属性名称 当前值 最大值 单位 filter
                 */
                NSArray* contents=[obj componentsSeparatedByString:@"|"];
                if(contents!=nil&&[contents count]==4){
                    [_statusArr addObject:obj];
                }
            }else if([key isKindOfClass:[NSString class]]){
                if([key isEqualToString:@"status"]){
                    NSLog(@"status %@",obj);
                }
            }

            
        }];
        
        [_realDataView setRealDatas:_statusArr];
        [_realDataView reloadData];
        
        
    }];
}
/*
 status = 10000000;
 3 = "PH|7.300000";
 6 = "\U4e9a\U785d\U9178\U76d0|0.030000";
 5 = "\U6e29\U5ea6|24.450001";
 1 = "\U6eb6\U6c27|4.090000";
 4 = "\U6c28\U6c2e|0.140000";
 */
-(void)viewWillDisappear:(BOOL)animated{
    [[SocketService shareInstance] disconnect];
    [[SocketService shareInstance] setStatusBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
                                               溶氧 4.050000
 2016-09-23 17:22:56.400 farmingFish[3710:60b] 温度 23.820000
 2016-09-23 17:22:56.408 farmingFish[3710:60b] PH 7.300000
 2016-09-23 17:22:56.409 farmingFish[3710:60b] 氨氮 0.120000
 2016-09-23 17:22:56.411 farmingFish[3710:60b] 亚硝酸盐 0.020000
 2016-09-23 17:22:56.412 farmingFish[3710:60b] 液位 0.000000
 2016-09-23 17:22:56.413 farmingFish[3710:60b] 硫化氢 0.000000
 2016-09-23 17:22:56.415 farmingFish[3710:60b] 浊度 0.000000
 2016-09-23 17:22:56.416 farmingFish[3710:60b] 电机状态 10000000
 */

@end
