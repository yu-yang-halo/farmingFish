//
//  VideoViewController.m
//  farmingFish
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//
#import "UIViewController+Extension.h"
#import "VideoViewController.h"
#import "UIColor+hexStr.h"
#import "UIButton+BGColor.h"
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
#import "JSONKit.h"
#import "SQMenuShowView.h"
#import "YYVideoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIView+Toast.h>
#import "VoiceTalk.h"
#import "FService.h"
#import "AppDelegate.h"
VideoViewController *g_pController = NULL;
@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    int layoutMode;//1 2 3 4
    int lastMode;
    
    CGRect Screen_bounds;

    YYVideoView  *m_multiView[MAX_VIEW_NUM];
    int singleSelectIndex;
    
    //真实视频数
    int videoCount;
    BOOL waitViewDidLoad;
    
}
@property(nonatomic,strong) NSDictionary *configParams;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIScrollView     *scrollView;
@property(nonatomic,strong) UIPageControl    *pageControl;
@property(nonatomic,strong) SQMenuShowView   *showView;
@property(nonatomic,assign) BOOL   isShow;
@property(nonatomic,strong) NSString *videoPath;
@property(nonatomic,strong) NSMutableDictionary *indexCodeDict;
@end

@implementation VideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的视频";
    waitViewDidLoad=YES;
    singleSelectIndex=0;
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    
    self.indexCodeDict=[NSMutableDictionary new];
    
    self.videoInfo=delegate.videoInfo;
    NSArray *arr=[[_videoInfo objectForKey:@"GetUserVideoInfoResult"] objectFromJSONString];
    
    if(arr!=nil&&[arr count]>0){
        self.configParams=arr[0];
        NSLog(@"GetUserVideoInfo::: %@", _videoInfo);
        videoCount=[arr count];
        
        for (NSDictionary *dict in arr) {
            [_indexCodeDict setObject:@(YES) forKey: [dict objectForKey:@"F_IndexCode"]];
        }
    }else{
        videoCount=0;
    }
   
    for(int i=0;i<MAX_VIEW_NUM;i++){
        m_multiView[i]=[[YYVideoView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [m_multiView[i] setBackgroundColor:[UIColor blackColor]];
        [m_multiView[i] setTag:i];
        
        id isVaildYN=[_indexCodeDict objectForKey:@(i+1)];
        
        if(isVaildYN!=nil){
            [m_multiView[i] setIsVaildYN:[isVaildYN boolValue]];
            NSLog(@"_indexCodeDict %@",_indexCodeDict);
        }
        
    }
    [self navigationBarInit];
    
    [self viewControllerBGInit];
    

    
    
    g_pController=self;
    Screen_bounds=self.view.bounds;
    Screen_bounds.size.height=Screen_bounds.size.width-40;
    
    
    layoutMode=4;
    
    float width=(Screen_bounds.size.width-(layoutMode-1))/layoutMode;
    float height=(Screen_bounds.size.height-(layoutMode-1))/layoutMode;
    
    /*
     * UICollectionView layout
     */
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize=CGSizeMake(width, height);
    
    flowLayout.minimumLineSpacing=1;
    flowLayout.minimumInteritemSpacing=1;
   
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,Screen_bounds.size.width,Screen_bounds.size.height) collectionViewLayout:flowLayout];
    
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), Screen_bounds.size.width, 10)];
    [_pageControl setNumberOfPages:[self pageNums]];
    
    self.collectionView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.layer.borderWidth=0.5;
    self.collectionView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    [self.collectionView setPagingEnabled:YES];
    
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"videoCell"];
    
    
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:_pageControl];

    

    
    
   
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageControl.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(_pageControl.frame)-30)];
    
    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:@"#20FFFFFF"]];
    float space=3;
    float btn_width=(_scrollView.frame.size.width-space*4)/3;
    float btn_heigth=(_scrollView.frame.size.height-space*4)/3;
    

    NSArray *contents=@[@"左上",@"上仰",@"右上",@"左转",@"自动",@"右转",@"左下",@"下俯",@"右下"];
    int tags[]={25,21,26,23,29,24,27,22,28};
    
    for (int i=0; i<9; i++) {
        int row=i/3;
        int col=i%3;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(col*(btn_width)+(col+1)*space,row*(btn_heigth)+(row+1)*space, btn_width, btn_heigth)];
        [btn setTitle:contents[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:(UIControlStateNormal)];
        btn.layer.cornerRadius=3;
        
        [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
        [btn setTag:tags[i]];
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.02] forState:UIControlStateHighlighted];
        
        [_scrollView addSubview:btn];
        
    }
    
    
    [self.view addSubview:_scrollView];
    [self initPopupView];
    [self videoConfigurationInit];
    
}


-(void)videoConfigurationInit{
    m_lUserID = -1;
    m_lRealPlayID = -1;
    m_lPlaybackID = -1;
    m_nPreviewPort = -1;
    m_nPlaybackPort = -1;
    m_bRecord = false;
    m_bVoiceTalk=false;
    g_iStartChan=0;
    g_iPreviewChanNum=0;
    
    
}


-(void)viewWillAppear:(BOOL)animated{
     self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"浏览模式" style: UIBarButtonItemStyleDone target:self action:@selector(popupView:)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
      
        if(!waitViewDidLoad){
            [self playAllVideo];
        }else{
            [self loginHCSystem];
            [self playAllVideo];
             waitViewDidLoad=NO;
        }
        
        
    });
   
    
}
-(void)viewWillDisappear:(BOOL)animated{
        self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style: UIBarButtonItemStyleDone target:self action:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self closeVideo];
    });
}

/*
 * 初始化popupView
 */
-(void)initPopupView{
    self.showView=[[SQMenuShowView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-100-10, 64+5,100,0) items:@[@"1x1",@"2x2",@"3x3",@"4x4"] showPoint:CGPointMake(CGRectGetWidth(self.view.frame)-25,10)];
    __weak typeof(self) weakSelf=self;
    
    [_showView setSelectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow=NO;
        layoutMode=(index+1);
        if(singleSelectIndex>=videoCount){
            singleSelectIndex=0;
        }
        [weakSelf layoutReload];
    }];
    
    _showView.sq_backGroundColor=[UIColor whiteColor];
    [self.view addSubview:_showView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}
-(void)dismissView{
    _isShow=NO;
    [self.showView dismissView];

}
-(void)poppupViewHideOrShow{
    _isShow= !_isShow;
    if(_isShow){
        [self.showView showView];
    }else{
        [self.showView dismissView];
    }
}
-(void)popupView:(id)sender{
    [self poppupViewHideOrShow];
}
-(void)touchDown:(UIButton *)sender{
    NSLog(@"down....");
    [self ptzControl:singleSelectIndex ptzDirect:sender.tag val:0];
}
-(void)touchUp:(UIButton *)sender{
    NSLog(@"up....");
    [self ptzControl:singleSelectIndex ptzDirect:sender.tag val:1];
}
-(void)ptzControl:(int)channel ptzDirect:(int)pd val:(int)type{
    int PTZ_DIRECT=pd;
    NSString *loggerTag=@"";
    if(type==0){
        loggerTag=@"START";
    }else{
        loggerTag=@"STOP";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan+channel, PTZ_DIRECT, type))
        {
            NSLog(@"%@  failed with[%d]",loggerTag,NET_DVR_GetLastError());
        }
        else
        {
            NSLog(@"%@  succ",loggerTag);
        }
        

    });
    
    

}



-(void)layoutReload{
    UICollectionViewFlowLayout *flowLayout=_collectionView.collectionViewLayout;
    float width=(Screen_bounds.size.width-(layoutMode-1))/layoutMode;
    float height=(Screen_bounds.size.height-(layoutMode-1))/layoutMode;
    flowLayout.itemSize=CGSizeMake(width, height);
    
    
    
    [_collectionView setCollectionViewLayout:flowLayout animated:YES];
    if(layoutMode==1&&singleSelectIndex>=0){
         [_collectionView setContentOffset:CGPointMake(width*singleSelectIndex, 0)];
         [_pageControl setCurrentPage:singleSelectIndex];
    }
    
    [_pageControl setNumberOfPages:[self pageNums]];
   
    [_collectionView reloadData];
}
-(int)pageNums{
    
    return videoCount%(layoutMode*layoutMode)==0?videoCount/(layoutMode*layoutMode):videoCount/(layoutMode*layoutMode)+1;
}

#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //视频数 videoCount
    //单页最大显示数 1x1  2x2  3x3  4x4
    int result=0;
    switch (layoutMode) {
        case 1:
            result=videoCount;
            break;
        case 2:
            if(videoCount<=2*2){
                result=2*2;
            }else{
                result=2*2*2;
            }
            break;
        case 3:
            if(videoCount<=3*3){
                result=3*3;
            }else{
                result=3*3*2;
            }
            break;
        case 4:
            if(videoCount<=4*4){
                result=4*4;
            }else{
                result=4*4*2;
            }
            break;
    }
 
    return result;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float width=Screen_bounds.size.width;
    int currentPage=scrollView.contentOffset.x/width;
    if(layoutMode==1){
         singleSelectIndex=currentPage;
    }
    [_pageControl setNumberOfPages:[self pageNums]];
    [_pageControl setCurrentPage:currentPage];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    VideoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    [m_multiView[indexPath.row] removeFromSuperview];
    
     m_multiView[indexPath.row].frame=cell.bounds;
    [cell.containerView  addSubview:m_multiView[indexPath.row]];
    [cell.containerView setTag:[m_multiView[indexPath.row] tag]];
    [cell setTag:[m_multiView[indexPath.row] tag]];
    
    
    
    UITapGestureRecognizer *tapGR1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectVideo:)];
    [tapGR1 setNumberOfTapsRequired:1];

    UITapGestureRecognizer *tapGR2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modeSwitch:)];
     [tapGR2 setNumberOfTapsRequired:2];
    
    
    if(singleSelectIndex==indexPath.row){
        cell.layer.borderWidth=1;
        cell.layer.borderColor=[[UIColor yellowColor] CGColor];
    }else{
        cell.layer.borderWidth=0;
    }
    
    [cell.containerView setUserInteractionEnabled:YES];
    
    [cell.containerView addGestureRecognizer:tapGR1];
    [cell.containerView addGestureRecognizer:tapGR2];

   
    [tapGR1 requireGestureRecognizerToFail:tapGR2];
   

    return cell;
}
-(void)selectVideo:(UIGestureRecognizer *)gr{
    [self dismissView];
    singleSelectIndex=gr.view.tag;
    

    [_collectionView reloadData];
  
   
}

-(void)modeSwitch:(UIGestureRecognizer *)gr{
    [self dismissView];
    if(gr.view.tag>=videoCount){
        [self.view.window makeToast:@"当前窗口无视频～"];
        return;
    }
    
    
     singleSelectIndex=gr.view.tag;
    
    
    if(layoutMode!=1){
        lastMode=layoutMode;
        layoutMode=1;
    }else{
        if(lastMode!=0){
            layoutMode=lastMode;
        }
    }
    [self layoutReload];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)previewPlay:(int*)iPlayPort playView:(UIView *)playView
{
    NSLog(@"m_nPreviewPort %d",*iPlayPort);
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
-(void)playAllVideo{
    if(g_iPreviewChanNum > 0)
    {
        int iPreviewID[MAX_VIEW_NUM] = {0};
        
        for(int i=0;i<MAX_VIEW_NUM;i++){
           iPreviewID[i] = startPreview(m_lUserID, g_iStartChan, m_multiView[i], i);
        }
        
        m_lRealPlayID = iPreviewID[0];
        m_bPreview = true;
        
    }
}

-(void)playVideo:(int)index{
    NSLog(@"liveStreamBtnClicked");
    
    if(index>=MAX_VIEW_NUM){
        return;
    }
    if(g_iPreviewChanNum > 0)
    {
        int iPreviewID[MAX_VIEW_NUM] = {0};
      
        iPreviewID[index] = startPreview(m_lUserID, g_iStartChan, m_multiView[index], index);
        
        m_lRealPlayID = iPreviewID[index];
        m_bPreview = true;

    }
}

-(void)loginHCSystem{
    NSArray *ipAndPortArr=[self domainIpAndPort];
    
    if(ipAndPortArr==nil){
        return;
    }
    
    DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
    deviceInfo.chDeviceAddr = ipAndPortArr[0];
    deviceInfo.nDevicePort = [ipAndPortArr[1] intValue];
    deviceInfo.chLoginName = [_configParams objectForKey:@"F_UserName"];//账户名
    deviceInfo.chPassWord = [_configParams objectForKey:@"F_UserPwd"];;//密码
    
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


/**获取动态ip port**/
-(NSArray *)domainIpAndPort{
    NSString *F_OutIPAddr=[_configParams objectForKey:@"F_OutIPAddr"];
    
    NSArray *params=[F_OutIPAddr componentsSeparatedByString:@"|"];
    
    NSString *ipAddr=params[0];
    NSString *nickname=params[1];
    
    if(ipAddr==nil){
        return nil;
    }
    
    
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"NET_DVR_Init failed");
    }

    
    NSArray *ipAndPortArr=nil;
    NET_DVR_QUERY_COUNTRYID_COND	struCountryIDCond = {0};
    NET_DVR_QUERY_COUNTRYID_RET		struCountryIDRet = {0};
    struCountryIDCond.wCountryID = 248;//China
    
    memcpy(struCountryIDCond.szSvrAddr, ipAddr.UTF8String, strlen(ipAddr.UTF8String));
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
    memcpy(struDDNSCond.szDevNickName, nickname.UTF8String, strlen(nickname.UTF8String));//your dvr/ipc nickname
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
