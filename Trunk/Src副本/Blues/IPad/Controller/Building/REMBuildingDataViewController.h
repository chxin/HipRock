/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingDataViewController.h
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMBuildingCommodityViewController.h"
#import "REMBuildingAirQualityViewController.h"
#import "REMBuildingImageViewController.h"
#import "REMBuildingConstants.h"
#import "REMBuildingViewController.h"
#import "REMManagedBuildingModel.h"
@interface REMBuildingDataViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic) CGRect upViewFrame;

@property (nonatomic) CGFloat currentOffsetY;

- (void)loadingDataComplete:(NSUInteger)index;
- (NSDictionary *)realExport:(BOOL)isMail;


@end
