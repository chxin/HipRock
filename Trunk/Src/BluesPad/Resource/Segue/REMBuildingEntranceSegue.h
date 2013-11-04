//
//  REMBuildingEntranceSegue.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/23/13.
//
//

#import <UIKit/UIKit.h>
#import "REMGalleryViewController.h"
#import "REMMapViewController.h"

struct REMBuildingSegueZoomParamter {
    BOOL isNeedAnimation;
    int currentBuildingIndex;
    CGRect initialZoomFrame;
    CGRect finalZoomFrame;
};
typedef struct REMBuildingSegueZoomParamter REMBuildingSegueZoomParamter;

static inline REMBuildingSegueZoomParamter  REMBuildingSegueZoomParamterMake(BOOL animation, int index, CGRect iniFrame, CGRect finFrame){
    REMBuildingSegueZoomParamter parameter;
    parameter.currentBuildingIndex = index;
    parameter.isNeedAnimation = animation;
    parameter.initialZoomFrame = iniFrame;
    parameter.finalZoomFrame = finFrame;
    
    return parameter;
}

@interface REMBuildingEntranceSegue : UIStoryboardSegue

@property (nonatomic) REMBuildingSegueZoomParamter parameter;

-(void)prepareSegueWithParameter:(REMBuildingSegueZoomParamter)parameter;


@end
