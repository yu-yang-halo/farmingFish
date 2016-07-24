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

#define MAX_VIEW_NUM    16


int startPreview(int iUserID, int iStartChan, UIView *pView, int iIndex);
void stopPreview(int iIndex);

#endif
