/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingImageViewController.h
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMControllerBase.h"
#import "REMManagedBuildingModel.h"

typedef enum _REMBuildingCoverStatus{
    REMBuildingCoverStatusCoverPage,
    REMBuildingCoverStatusDashboard
} REMBuildingCoverStatus;

@interface REMBuildingImageViewController : REMControllerBase<UIGestureRecognizerDelegate>



@property (nonatomic,weak) UIImage *defaultImage;
@property (nonatomic,weak) UIImage *defaultBlurImage;
@property (nonatomic) CGRect viewFrame;

@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;

@property (nonatomic) REMBuildingCoverStatus currentCoverStatus;

@property (nonatomic,weak) UIButton *shareButton;

@property (nonatomic) CGFloat currentOffset;


- (void)setBlurLevel:(CGFloat)offsetY;

- (void)loadContentView;
- (void)exportImage:(void (^)(UIImage *, NSString*))callback :(BOOL)isMail;


- (void)releaseContentView;
- (void)releaseAllDataView;

@end
