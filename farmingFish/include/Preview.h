//
//  Preview.h
//  PlayerDemo
//
//  Created by Netsdk on 15/4/22.
//
//

#ifndef PlayerDemo_Preview_h
#define PlayerDemo_Preview_h
#import "VideoViewController.h"
#define MAX_VIEW_NUM_CACHE    16
#define MAX_VIEW_NUM_16    16
#define MAX_VIEW_NUM_9      9
#define MAX_VIEW_NUM_4      4
#define MAX_VIEW_NUM_1      1

int startPreview(int iUserID, int iStartChan, UIView *pView, int iIndex);
void stopPreview(int iIndex);

#endif
