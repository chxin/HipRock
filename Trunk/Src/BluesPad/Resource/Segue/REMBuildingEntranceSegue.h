/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingEntranceSegue.h
 * Created      : 张 锋 on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMGalleryViewController.h"
#import "REMMapViewController.h"

struct REMBuildingSegueZoomParamter {
    BOOL isNoAnimation;
    int currentBuildingIndex;
    CGRect initialZoomFrame;
    CGRect finalZoomFrame;
};
typedef struct REMBuildingSegueZoomParamter REMBuildingSegueZoomParamter;

static inline REMBuildingSegueZoomParamter  REMBuildingSegueZoomParamterMake(BOOL animation, int index, CGRect iniFrame, CGRect finFrame){
    REMBuildingSegueZoomParamter parameter;
    parameter.currentBuildingIndex = index;
    parameter.isNoAnimation = animation;
    parameter.initialZoomFrame = iniFrame;
    parameter.finalZoomFrame = finFrame;
    
    return parameter;
}

@interface REMBuildingEntranceSegue : UIStoryboardSegue

@property (nonatomic) REMBuildingSegueZoomParamter parameter;

-(void)prepareSegueWithParameter:(REMBuildingSegueZoomParamter)parameter;


@end
