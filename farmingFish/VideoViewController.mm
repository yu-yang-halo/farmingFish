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
#import "YYButton.h"
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
#import "GradientHelper.h"
#import "BeanObject.h"
VideoViewController *g_pController = NULL;
@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    int layoutMode;//may be 1 2 3 4
    int lastMode;
    
    int CURRENT_LAYOUTMODE;
    
    CGRect Screen_bounds;
    YYVideoView  *m_multiView[MAX_VIEW_NUM_16];
    int singleSelectIndex;
    //真实视频数
    int videoCount;
    int view_container_num;
    BOOL waitViewDidLoad;
    
}
@property(nonatomic,strong) YYVideoInfo *configParams;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIScrollView     *ptzControlView;
@property(nonatomic,strong) UIScrollView     *videoMenuView;
@property(nonatomic,assign) BOOL   isShow;
@property(nonatomic,strong) NSString *videoPath;
@property(nonatomic,strong) NSMutableDictionary *indexCodeDict;
@property(nonatomic,strong) NSArray<YYVideoInfo *> *realVideoArrs;

@end

@implementation VideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self viewControllerBGInit];
    
    waitViewDidLoad=YES;
    singleSelectIndex=0;
    
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    
    self.indexCodeDict=[NSMutableDictionary new];
    self.realVideoArrs=delegate.videoInfoArrs;
    
    
    if(_realVideoArrs!=nil&&[_realVideoArrs count]>0){
        self.configParams=_realVideoArrs[0];
        videoCount=[_realVideoArrs count];
    }else{
        videoCount=0;
    }
    if(videoCount<=4){
        view_container_num=MAX_VIEW_NUM_4;
        CURRENT_LAYOUTMODE=2;
    }else if (videoCount<=9){
        view_container_num=MAX_VIEW_NUM_9;
        CURRENT_LAYOUTMODE=3;
    }else if (videoCount<=16){
        view_container_num=MAX_VIEW_NUM_16;
        CURRENT_LAYOUTMODE=4;
    }

    
   
    for(int i=0;i<view_container_num;i++){
        m_multiView[i]=[[YYVideoView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [m_multiView[i] setBackgroundColor:[UIColor clearColor]];
        [m_multiView[i] setTag:i];
        if(i<videoCount){
             [m_multiView[i] setIsVaildYN:YES];
        }else{
             [m_multiView[i] setIsVaildYN:NO];
        }
        
    }
   
    g_pController=self;
    Screen_bounds=self.view.bounds;
    Screen_bounds.size.height=Screen_bounds.size.width-40;
    
    
    layoutMode=CURRENT_LAYOUTMODE;
    
    float width=(Screen_bounds.size.width-(layoutMode-1)*3)/layoutMode;
    float height=(Screen_bounds.size.height-(layoutMode-1)*3)/layoutMode;
    /*
     * UICollectionView layout
     */
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize=CGSizeMake(width, height);
    
    flowLayout.minimumLineSpacing=3;
    flowLayout.minimumInteritemSpacing=3;
   
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,Screen_bounds.size.width,Screen_bounds.size.height) collectionViewLayout:flowLayout];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.layer.borderWidth=0.5;
    self.collectionView.layer.borderColor=[[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    [self.collectionView setPagingEnabled:YES];
    
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"videoCell"];
    
    
    
    [self.view addSubview:_collectionView];
   
    [self ptzViewInit];
    [self videoMenuViewInit];
    

    [self videoConfigurationInit];
    [self loadVideoData];
    
}
-(void)setBarTitle:(NSString *)_title{
     self.tabBarController.title=_title;
}
#pragma mark 云台控制view init
-(void)ptzViewInit{
    self.ptzControlView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(_collectionView.frame)-tldTabBarHeight)];
    
    //[GradientHelper setGradientToView:_ptzControlView];
    
    
    float space=3;
    float btn_width=(_ptzControlView.frame.size.width-space*4)/3;
    float btn_heigth=(_ptzControlView.frame.size.height-space*4)/3;
    
    NSArray *contents=@[@"左上",@"上仰",@"右上",@"左转",@"自动",@"右转",@"左下",@"下俯",@"右下"];
    int tags[]={25,21,26,23,29,24,27,22,28};
    
    for (int i=0; i<9; i++) {
        int row=i/3;
        int col=i%3;
        YYButton *btn=[[YYButton alloc] initWithFrame:CGRectMake(col*(btn_width)+(col+1)*space,row*(btn_heigth)+(row+1)*space, btn_width, btn_heigth)];
        [btn setTitle:contents[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:(UIControlStateNormal)];
        btn.layer.cornerRadius=3;
        
//        [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
        
        [btn setTag:tags[i]];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.3] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.1] forState:UIControlStateHighlighted];
        
        [_ptzControlView addSubview:btn];
        
    }
    _ptzControlView.alpha=0;
    [self.view addSubview:_ptzControlView];
    
}
#pragma mark 视频菜单view
-(void)videoMenuViewInit{
   
    self.videoMenuView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(_collectionView.frame)-tldTabBarHeight)];
    
    //[GradientHelper setGradientToView:_videoMenuView];
    
    if(videoCount<=0){
        return;
    }
    /*
     *  根据视频个数来计算行数和列数
     *  4  列数 4 行数 1
     *  3      3      1
     *  2      2      1
     */
    
    int  maxColums=4;
    float space=0;
    int   row=1;

    if(videoCount<=maxColums){
        maxColums=videoCount;
    }else{
        row=videoCount%maxColums==0?videoCount/maxColums:(videoCount/maxColums+1);
    }
    
    float btn_width=CGRectGetWidth(self.view.frame)/maxColums;
    float btn_heigth=70;
  
    for (int i=0; i<videoCount; i++) {
        
       
        int row=i/maxColums;
        int col=i%maxColums;
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(col*(btn_width)+(col+1)*space,row*(btn_heigth)+(row+1)*space, btn_width, btn_heigth)];
       
        
        [btn setTitle:[_realVideoArrs[i] valueForKey:@"F_Name"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"video_dev"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:(UIControlStateNormal)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        //top left bottom right
        //icon text

        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0,-40)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -58,-49, 0)];

        
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(fullScreenVideo:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_videoMenuView addSubview:btn];
        
    }
    
    if( btn_heigth*row>CGRectGetHeight(_videoMenuView.frame)){
        
        [_videoMenuView setContentSize:CGSizeMake(CGRectGetWidth(_videoMenuView.frame),  btn_heigth*row)];
        
    }
    
    
    [self.view addSubview:_videoMenuView];

    
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
    if(layoutMode==1){
        [self screenVideoSwitch:YES tag:singleSelectIndex];
    }else{
        [self loadVideoData];
    }
}
-(void)loadVideoData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(!waitViewDidLoad){
            [self playAllVideo:YES index:-1];
        }else{
            [self loginHCSystem];
            [self playAllVideo:YES index:-1];
            waitViewDidLoad=NO;
        }
    });
 
}
-(void)viewWillDisappear:(BOOL)animated{
        self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style: UIBarButtonItemStyleDone target:self action:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self closeAllVideo:YES index:-1];
    });
}

-(void)touchDown:(UIButton *)sender{
    NSLog(@"down....");
   // [self ptzControl:singleSelectIndex ptzDirect:sender.tag val:0];
}
-(void)touchClick:(UIButton *)sender{
    NSLog(@"move ....");
    [self ptzControl:singleSelectIndex ptzDirect:sender.tag val:0];
    [self performSelector:@selector(moveStop:) withObject:sender afterDelay:0.4];
    
}
-(void)moveStop:(UIButton *)sender{
    NSLog(@"sender ... %@",sender);
    [self ptzControl:singleSelectIndex ptzDirect:sender.tag val:1];
}
-(void)ptzControl:(int)channel ptzDirect:(NSInteger)pd val:(NSInteger)type{
    NSInteger PTZ_DIRECT=pd;
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
    float width=(Screen_bounds.size.width-(layoutMode-1)*3)/layoutMode;
    float height=(Screen_bounds.size.height-(layoutMode-1)*3)/layoutMode;
    flowLayout.itemSize=CGSizeMake(width, height);
    [_collectionView setCollectionViewLayout:flowLayout animated:YES];
    [_collectionView reloadData];
    
    if(layoutMode==1){
        self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fullscreen"] style:(UIBarButtonItemStyleDone) target:self action:@selector(exitFullScreen:)];
        
        
    }else{
        self.tabBarController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:nil style:(UIBarButtonItemStyleDone) target:nil action:nil];

    }
}

-(void)exitFullScreen:(id)sender{
    [self screenVideoSwitch:YES tag:singleSelectIndex];
    
}

-(int)pageNums{
    
    return videoCount%(layoutMode*layoutMode)==0?videoCount/(layoutMode*layoutMode):videoCount/(layoutMode*layoutMode)+1;
}

#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    
    if(layoutMode==1){
        return 1;
    }else{
        return layoutMode*layoutMode;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    VideoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    
    for(UIView *chidView in [cell.containerView subviews]){
        [chidView removeFromSuperview];
    }
    YYVideoView *showView=nil;
    
    if(layoutMode==1){
        showView=m_multiView[singleSelectIndex];
    }else{
        showView=m_multiView[indexPath.row];
    }
    if(showView.isVaildYN){
        [cell.progressView startAnimating];
    }else{
        [cell.progressView stopAnimating];
    }
    
    
    showView.frame=cell.bounds;
    
    [cell.containerView  addSubview:showView];
    
    [cell.containerView setTag:[showView tag]];
    [cell setTag:[showView tag]];
    
    
    
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
    singleSelectIndex=gr.view.tag;
    [_collectionView reloadData];
}
-(void)fullScreenVideo:(UIButton *)sender{
    if(sender.tag>=videoCount){
        [self.view.window makeToast:@"当前窗口无视频～"];
        return;
    }
    [self screenVideoSwitch:NO tag:sender.tag];

}

-(void)screenVideoSwitch:(BOOL)switchYN tag:(int)tag{
   
    singleSelectIndex=tag;
    if(layoutMode!=1){
        [self closeAllVideo:YES index:-1];
        
        lastMode=layoutMode;
        layoutMode=1;
        _ptzControlView.alpha=1;
        _videoMenuView.alpha=0;

        [self.view bringSubviewToFront:_ptzControlView];
        
        [self playAllVideo:NO index:singleSelectIndex];
        if(singleSelectIndex<[_realVideoArrs count]){
           
            [self setBarTitle:[_realVideoArrs[singleSelectIndex] valueForKey:@"F_Name"]];
            
        }else{
            [self setBarTitle:ITEM_VIDEO];
        }
       
    }else{
        if(switchYN){
            [self closeAllVideo:NO index:singleSelectIndex];
            if(lastMode!=0){
                layoutMode=lastMode;
            }
            _ptzControlView.alpha=0;
            _videoMenuView.alpha=1;
            
            [self.view bringSubviewToFront:_videoMenuView];
            
            [self playAllVideo:YES index:-1];
            [self setBarTitle:ITEM_VIDEO];
            
        }
        
        
    }
    
    [self layoutReload];
    self.view.alpha=0;
    
    [UIView beginAnimations:@"Alpha" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.view.alpha=1;
    [UIView commitAnimations];

}


-(void)modeSwitch:(UIGestureRecognizer *)gr{
   
    if(gr.view.tag>=videoCount){
        [self.view.window makeToast:@"当前窗口无视频～"];
        return;
    }
    [self screenVideoSwitch:YES tag:gr.view.tag];

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

-(void)closeAllVideo:(BOOL)isCloseAllYN index:(int)idx{
    for(int i = 0; i < videoCount; i++)
    {
        if(isCloseAllYN){
             stopPreview(i);
        }else{
            if(idx==i){
                stopPreview(i);
            }
        }
       
    }
    m_bPreview = false;
}

-(void)playAllVideo:(BOOL)isPlayAllYN index:(int)idx{
    if(g_iPreviewChanNum > 0)
    {
        int iPreviewID[MAX_VIEW_NUM_CACHE] = {0};
        
        for(int i=0;i<videoCount;i++){
            if(isPlayAllYN){
                iPreviewID[i] = startPreview(m_lUserID, g_iStartChan, m_multiView[i], i);
            }else{
                if(i==idx){
                     iPreviewID[i] = startPreview(m_lUserID, g_iStartChan, m_multiView[i], i);
                }
               
            }
           
        }
        //???
        m_lRealPlayID = iPreviewID[0];
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
    
    deviceInfo.chLoginName = _configParams.F_UserName;//账户名
    deviceInfo.chPassWord  = _configParams.F_UserPwd;//密码
    
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
    NSString *F_OutIPAddr=_configParams.F_OutIPAddr;
    
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
