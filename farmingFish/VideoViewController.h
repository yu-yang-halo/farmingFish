//
//  VideoViewController.h
//  farmingFish
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayDelegate <NSObject>

-(void)play:(int)index;

@end

@interface VideoViewController : UIViewController<PlayDelegate>{
    
    int  g_iStartChan;
    int  g_iPreviewChanNum;
    int  m_lUserID;
    BOOL m_bPreview;
    int  m_lRealPlayID;
    int  m_lPlaybackID;
    int  m_nPlaybackPort;
    int  m_nPreviewPort;
    bool m_bRecord;
    bool m_bVoiceTalk;
}

- (void)previewPlay:(int*)iPlayPort playView:(UIView*)playView;
- (void)stopPreviewPlay:(int*)iPlayPort;



@end
