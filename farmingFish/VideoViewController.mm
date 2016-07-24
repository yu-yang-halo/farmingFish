//
//  VideoViewController.m
//  farmingFish
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "VideoViewController.h"
#import "UIColor+hexStr.h"
#import <UIColor+uiGradients/UIColor+uiGradients.h>
#import "hcnetsdk.h"
#import "DeviceInfo.h"
#import "VideoCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "IOSPlayM4.h"
#import "Preview.h"
#include <stdio.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <net/if.h>
#include <map>
VideoViewController *g_pController = NULL;
@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    int layoutMode;//1 2 3 4
    CGRect Screen_bounds;
    
    int g_iStartChan;
    int g_iPreviewChanNum;
    int m_lUserID;
    BOOL m_bPreview;
    int m_lRealPlayID;
    UIView  *m_multiView[MAX_VIEW_NUM];
    int    m_nPreviewPort;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIScrollView     *scrollView;
@property(nonatomic,strong) UIPageControl    *pageControl;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"我的视频";
    g_pController=self;
    Screen_bounds=[UIScreen mainScreen].bounds;
    
    UIColor *startColor = [UIColor uig_emeraldWaterStartColor];
    UIColor *endColor = [UIColor uig_emeraldWaterEndColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1,1);
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    layoutMode=4;
    
    float side=(Screen_bounds.size.width-(layoutMode-1))/layoutMode;
    
    
    /*
     * UICollectionView layout
     */
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize=CGSizeMake(side, side);
    
    flowLayout.minimumLineSpacing=1;
    flowLayout.minimumInteritemSpacing=1;
   
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,Screen_bounds.size.width,Screen_bounds.size.width) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.layer.borderWidth=1;
    self.collectionView.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"videoCell"];
    
    
    
    [self.view addSubview:_collectionView];

    
    for(int i=0;i<MAX_VIEW_NUM;i++){
        m_multiView[i]=[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [m_multiView[i] setTag:i];
    }
    
    [self scaleViewLayout];
    [self loginHCSystem];

}
-(void)viewWillAppear:(BOOL)animated{
     [self playVideo];
}
-(void)viewWillDisappear:(BOOL)animated{
     [self closeVideo];
}

-(void)scaleViewLayout{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,_collectionView.frame.origin.y+_collectionView.frame.size.height,Screen_bounds.size.width, 50)];
    
    float h_space=(Screen_bounds.size.width-40*4)/5;
    
    for (int i=0; i<4; i++) {
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(h_space*(i+1)+40*(i),(50-40)/2, 40, 40)];
        
        [btn setTitle:[NSString stringWithFormat:@"%d",(i+1)*(i+1)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor purpleColor]];
        
        [btn setTag:(i+1)];
        [btn addTarget:self action:@selector(modeShow:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
    }
    
    [self.view addSubview:view ];
}
-(void)modeShow:(UIButton *)sender{
     layoutMode=sender.tag;
    
    
    UICollectionViewFlowLayout *flowLayout=_collectionView.collectionViewLayout;
    float side=(Screen_bounds.size.width-(layoutMode-1))/layoutMode;
    flowLayout.itemSize=CGSizeMake(side, side);
    [_collectionView reloadData];
    
    
}


#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return layoutMode*layoutMode;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //collectionView.contentOffset=CGPointMake(0, 0);
    
    VideoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    [cell.videoView addSubview:m_multiView[indexPath.row]];
    
    [m_multiView[indexPath.row] mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@[cell.videoView.mas_height,m_multiView[indexPath.row].mas_height]);
        make.width.equalTo(@[cell.videoView.mas_width,m_multiView[indexPath.row].mas_width]);
        
        make.leading.equalTo(@[cell.videoView.mas_leading,m_multiView[indexPath.row].mas_leading]);
        
        make.top.equalTo(@[cell.videoView.mas_top,m_multiView[indexPath.row].mas_top]);
        
    }];
    
    
    return cell;
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loginHCSystem{
    m_lUserID=-1;
    g_iStartChan=0;
    g_iPreviewChanNum=0;
    
    NSArray *ipAndPortArr=[self domainIpAndPort];
    DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
    deviceInfo.chDeviceAddr = ipAndPortArr[0];
    deviceInfo.nDevicePort = [ipAndPortArr[1] intValue];
    deviceInfo.chLoginName = @"admin";//账户名
    deviceInfo.chPassWord = @"12345678tld";//密码
    
    // device login
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    
    // encode type
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    m_lUserID = NET_DVR_Login_V30((char*)[deviceInfo.chDeviceAddr UTF8String],
                                  deviceInfo.nDevicePort,
                                  (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc],
                                  (char*)[deviceInfo.chPassWord UTF8String],
                                  &logindeviceInfo);
    
    printf("iP:%s\n", (char*)[deviceInfo.chDeviceAddr UTF8String]);
    printf("Port:%d\n", deviceInfo.nDevicePort);
    printf("UsrName:%s\n", (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc]);
    printf("Password:%s\n", (char*)[deviceInfo.chPassWord UTF8String]);
   
    if(m_lUserID!=-1){
        if(logindeviceInfo.byChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartChan;
            g_iPreviewChanNum = logindeviceInfo.byChanNum;
        }
        else if(logindeviceInfo.byIPChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartDChan;
            g_iPreviewChanNum = logindeviceInfo.byIPChanNum + logindeviceInfo.byHighDChanNum * 256;
        }
 
        NSLog(@"g_iStartChan %d",g_iStartChan);
        NSLog(@"g_iPreviewChanNum %d",g_iPreviewChanNum);
        
        
       
        
    }
    
    
    
}
-(void)previewPlay:(int*)iPlayPort playView:(UIView *)playView
{
    m_nPreviewPort = *iPlayPort;
    int iRet = PlayM4_Play(*iPlayPort,(__bridge void *)playView);
    PlayM4_PlaySound(*iPlayPort);
    if (iRet != 1)
    {
        NSLog(@"PlayM4_Play fail");
        [self stopPreviewPlay:(iPlayPort)];
        return;
    }
}

- (void)stopPreviewPlay:(int*)iPlayPort
{
    PlayM4_StopSound();
    if (!PlayM4_Stop(*iPlayPort))
    {
        NSLog(@"PlayM4_Stop failed");
    }
    if(!PlayM4_CloseStream(*iPlayPort))
    {
        NSLog(@"PlayM4_CloseStream failed");
    }
    if (!PlayM4_FreePort(*iPlayPort))
    {
        NSLog(@"PlayM4_FreePort failed");
    }
    *iPlayPort = -1;
}

-(void)closeVideo{
    for(int i = 0; i < MAX_VIEW_NUM; i++)
    {
        stopPreview(i);
    }
    m_bPreview = false;

}

-(void)playVideo{
    NSLog(@"liveStreamBtnClicked");
    
    if(g_iPreviewChanNum > 0)
    {
        int iPreviewID[MAX_VIEW_NUM] = {0};
        for(int i = 0; i < MAX_VIEW_NUM; i++)
        {
            iPreviewID[i] = startPreview(m_lUserID, g_iStartChan, m_multiView[i], i);
        }
        m_lRealPlayID = iPreviewID[0];
        m_bPreview = true;

    }
}


/**获取动态ip port**/
-(NSArray *)domainIpAndPort{
    
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"NET_DVR_Init failed");
    }

    
    NSArray *ipAndPortArr=nil;
    NET_DVR_QUERY_COUNTRYID_COND	struCountryIDCond = {0};
    NET_DVR_QUERY_COUNTRYID_RET		struCountryIDRet = {0};
    struCountryIDCond.wCountryID = 248;//China
    memcpy(struCountryIDCond.szSvrAddr, "www.hik-online.com", strlen("www.hik-online.com"));
    memcpy(struCountryIDCond.szClientVersion, "iOS NetSDK Demo", strlen("iOS NetSDK Demo"));
    if(NET_DVR_GetAddrInfoByServer(QUERYSVR_BY_COUNTRYID, &struCountryIDCond, sizeof(struCountryIDCond), &struCountryIDRet, sizeof(struCountryIDRet)))
    {
        NSLog(@"QUERYSVR_BY_COUNTRYID succ,resolve:%s", struCountryIDRet.szResolveSvrAddr);
    }
    else
    {
        LONG ERROR_CODE=NET_DVR_GetLastError();
        
        NSLog(@"QUERYSVR_BY_COUNTRYID failed:%s", NET_DVR_GetErrorMsg(&ERROR_CODE));
    }
    //follow code show how to get dvr/ipc address from the area resolve server by nickname or serial no.
    NET_DVR_QUERY_DDNS_COND	struDDNSCond = {0};
    NET_DVR_QUERY_DDNS_RET	struDDNSQueryRet = {0};
    NET_DVR_CHECK_DDNS_RET	struDDNSCheckRet = {0};
    memcpy(struDDNSCond.szClientVersion, "iOS NetSDK Fish", strlen("iOS NetSDK Fish"));
    memcpy(struDDNSCond.szResolveSvrAddr, struCountryIDRet.szResolveSvrAddr, strlen(struCountryIDRet.szResolveSvrAddr));
    memcpy(struDDNSCond.szDevNickName, "tld22345678", strlen("tld22345678"));//your dvr/ipc nickname
    if(NET_DVR_GetAddrInfoByServer(QUERYDEV_BY_NICKNAME_DDNS, &struDDNSCond, sizeof(struDDNSCond), &struDDNSQueryRet, sizeof(struDDNSQueryRet)))
    {
        NSLog(@"QUERYDEV_BY_NICKNAME_DDNS succ,ip[%s],sdk port[%d]:", struDDNSQueryRet.szDevIP, struDDNSQueryRet.wCmdPort);
        
        NSString *ipObj=[[NSString alloc] initWithUTF8String:struDDNSQueryRet.szDevIP];
        
        
        
        ipAndPortArr=@[ipObj,@(struDDNSQueryRet.wCmdPort)];
    }
    else
    {
        NSLog(@"QUERYDEV_BY_NICKNAME_DDNS failed:%d", NET_DVR_GetLastError());
    }
    
    //if you get the dvr/ipc address failed from the area reolve server,you can check the reason show as follow
    if(NET_DVR_GetAddrInfoByServer(CHECKDEV_BY_NICKNAME_DDNS, &struDDNSCond, sizeof(struDDNSCond), &struDDNSCheckRet, sizeof(struDDNSCheckRet)))
    {
        NSLog(@"CHECKDEV_BY_NICKNAME_DDNS succ,ip[%s], sdk port[%d], region[%d], status[%d]",struDDNSCheckRet.struQueryRet.szDevIP, struDDNSCheckRet.struQueryRet.wCmdPort, struDDNSCheckRet.wRegionID, struDDNSCheckRet.byDevStatus);
    }
    else
    {
        NSLog(@"CHECKDEV_BY_NICKNAME_DDNS failed[%d]", NET_DVR_GetLastError());
    }
    
    return ipAndPortArr;
    
}
 
 

@end
