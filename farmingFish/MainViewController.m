//
//  MainViewController.m
//  farmingFish
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "MainViewController.h"
#import <UIView+Toast.h>
#import "UIColor+hexStr.h"
#import "UIViewController+Extension.h"
#import "VideoViewController.h"
#import "FService.h"
#import "AppDelegate.h"
#import "SocketService.h"
#import "RealDataViewController.h"
#import "YYTabViewController.h"
#import "YYWeatherService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "YYColleCollectionViewCell.h"
#import "GradientHelper.h"
#import "AppDelegate.h"
#define YYTelephone @"18905606894"

@interface MainViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIAlertViewDelegate>{
    NSArray *itemTitles;
    NSArray *itemImages;
}
/*
 *params data
 */
@property(nonatomic,strong) NSArray *videoInfoArrs;
@property(nonatomic,strong) NSDictionary *devicesInfo;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"主页";
    [self viewControllerBGInit];
   
    itemTitles=@[@"实时监测",@"视频监控",@"远程控制",@"超限预警",@"知识库",@"历史数据"];
 itemImages=@[@"main_realdata",@"main_video",@"main_control",@"main_alert",@"main_news",@"main_history"];
    
    
    [self pageViewInit];
    
    
    [self loadNeedData];

}
#pragma mark 准备好数据
-(void)loadNeedData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud.bezelView setColor:[UIColor clearColor]];
    [hud.bezelView setStyle:MBProgressHUDBackgroundStyleSolidColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        
        
        self.videoInfoArrs=[[FService shareInstance] GetUserVideoInfo:delegate.userAccount];
        
        self.devicesInfo=[[FService shareInstance] GetCollectorInfo:delegate.customerNo  userAccount:delegate.userAccount];
        
        delegate.videoInfoArrs=_videoInfoArrs;
        delegate.deviceData=_devicesInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
        });
        
    });
}

-(void)pageViewInit{
    
    CGFloat logoHeight=160;
    CGFloat footerHeight=60;
    
    CGFloat  buttonWidth=150;
    CGFloat  buttonHeight=50;
    
    CGFloat  linerWidth=1;
    CGFloat  linerHeight=40;
    
    CGFloat  space=5;

    
    
    
    
    
    /*
     *   图片展示页面
     */
    
    UIView *logoView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame),logoHeight)];
    
    
    logoView.layer.contents=(__bridge id _Nullable)([[UIImage imageNamed:@"main_logo"] CGImage]);
    
    [self.view addSubview:logoView];
    
    /*
     *   功能模块展示页面
     */
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame)/2, 91);
    collectionLayout.minimumInteritemSpacing=0.0;
    collectionLayout.minimumLineSpacing=0.0;
    
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(logoView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-64-footerHeight-logoHeight) collectionViewLayout:collectionLayout];
    
    collectionView.delegate=self;
    collectionView.dataSource=self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"YYColleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"yyColleCollectionViewCell"];
    
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [GradientHelper setGradientToView:self.view];
    
    
    
    
    [self.view addSubview:collectionView];
    
    
    /*
     *   公司信息页
     */
    
    
    
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-footerHeight, CGRectGetWidth(self.view.frame), footerHeight)];
    
    [footerView setBackgroundColor:[UIColor colorWithHexString:@"#C0DCFF"]];
    
    
    UIButton *phoneBtn=[[UIButton alloc] initWithFrame:CGRectMake(space, (footerHeight-buttonHeight)/2, buttonWidth,buttonHeight)];
    
    
    [phoneBtn setImage:[UIImage imageNamed:@"main_phone"] forState:UIControlStateNormal];
    
    [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    [self buttonStyleInit:phoneBtn];
    
    
    [phoneBtn setTag:0];
    [phoneBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-1)/2,(footerHeight-linerHeight)/2, 1, linerHeight)];
    
    [line setBackgroundColor:[UIColor colorWithHexString:@"#80888888"]];
    
    UIButton *productBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-space-buttonWidth, (footerHeight-buttonHeight)/2,buttonWidth,buttonHeight)];
    
    [productBtn setImage:[UIImage imageNamed:@"main_product"] forState:UIControlStateNormal];
    
    [productBtn setTitle:@"产品展示" forState:UIControlStateNormal];
    
    [self buttonStyleInit:productBtn];
    [productBtn setTag:1];
    [productBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [footerView addSubview:phoneBtn];
    [footerView addSubview:line];
    [footerView addSubview:productBtn];
    

    
    [self.view addSubview:footerView]; 
}
-(void)buttonClick:(UIButton *)sender{
    if(sender.tag==0){
        //call phone
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"电话咨询" message: [NSString stringWithFormat:@"咨询电话:%@",YYTelephone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
        
    }
    
}

-(void)buttonStyleInit:(UIButton *)btn{
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
   
    [btn setTitleColor:[UIColor orangeColor]  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#80FF8F00"]  forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:21]];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionView DataSource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [itemTitles count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YYColleCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"yyColleCollectionViewCell" forIndexPath:indexPath];
    
    
    cell.itemLabel.text=itemTitles[indexPath.row];
    
    cell.itemImage.image=[UIImage imageNamed:itemImages[indexPath.row]];
    
    UIView *bgView=[[UIView alloc] initWithFrame:cell.bounds];
    
    [bgView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
    
    [cell setSelectedBackgroundView:bgView];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==1){
        if(_videoInfoArrs==nil){
            [self.view.window makeToast:@"暂无视频数据信息,请重试"];
             [self loadNeedData];
            return;
        }else{
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            if(!appDelegate.isReachableWiFi){
                [self.view.window makeToast:@"建议在WIFI环境下观看视频"];
            }
            
        }
    }else if (indexPath.row==0||indexPath.row==2){
        if(_devicesInfo==nil){
            [self.view.window makeToast:@"暂无设备数据信息,请重试"];
             [self loadNeedData];
            return;
        }
    }
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
            [self performSegueWithIdentifier:@"tabVC" sender:indexPath];
            break;
        case 4:
            [self performSegueWithIdentifier:@"toNewsVC" sender:indexPath];
            break;
        case 5:
            [self performSegueWithIdentifier:@"toHistoryVC" sender:indexPath];
            break;
    }
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender{
    
    if(sender.row>=4){
        return;
    }
    YYTabViewController *tabBarVC=segue.destinationViewController;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *videoVC=[storyBoard instantiateViewControllerWithIdentifier:@"videoVC"];
    UIViewController *realDataVC=[storyBoard instantiateViewControllerWithIdentifier:@"realDataVC"];
    UIViewController *controlVC=[storyBoard instantiateViewControllerWithIdentifier:@"controlVC"];
    
    UIViewController *newsVC=[storyBoard instantiateViewControllerWithIdentifier:@"newsVC"];
    
    UIViewController *historyVC=[storyBoard instantiateViewControllerWithIdentifier:@"historyVC"];
    
    UIViewController *settingsVC=[storyBoard instantiateViewControllerWithIdentifier:@"settingsVC"];
    
    
    UIViewController *alertVC=[storyBoard instantiateViewControllerWithIdentifier:@"alertVC"];
    
    UIViewController *moreVC=[storyBoard instantiateViewControllerWithIdentifier:@"moreVC"];
    

    
    [tabBarVC setViewControllers:@[realDataVC,videoVC,controlVC,alertVC,moreVC]];
    
    [tabBarVC setDefaultIndex:sender.row];
    
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int row=[itemTitles count]%2==0?[itemTitles count]/2:[itemTitles count]/2+1;
    
    CGFloat height=(collectionView.frame.size.height/row);
    
    return CGSizeMake(CGRectGetWidth(self.view.frame)/2,nearbyintf(height));
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    NSLog(@"buttonIndex %ld",buttonIndex);
    if(buttonIndex!=0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",YYTelephone]]];
    }
    
}
@end
