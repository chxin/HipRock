//
//  REMImageView.h
//  TestImage
//
//  Created by 谭 坦 on 7/23/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingDataView.h"
#import "REMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "REMBuildingOverallModel.h"
#import "REMCommodityUsageModel.h"
#import <Accelerate/Accelerate.h>
#import "REMDataAccessor.h"
#import "REMDataStore.h"    
#import "REMBuildingViewController.h"

@class REMBuildingViewController;

@interface REMImageView : UIView <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UIImage *defaultImage;
@property (nonatomic,weak) UIImage *defaultBlurImage;

@property (nonatomic,weak) REMBuildingViewController *controller;

- (void)moveOutOfWindow;

- (id) initWithFrame:(CGRect)frame withBuildingOveralInfo:(REMBuildingOverallModel *)buildingInfo;

- (void)scrollUp;

- (void)scrollDown;

- (void)setScrollOffset:(CGFloat)offsetY;

- (void)tapthis;

- (void)moveCenter:(CGFloat)x;

-(void)requireChartData;
- (BOOL)shouldResponseSwipe:(UITouch *)touch;

- (void)exportImage:(void(^)(UIImage *))callback;

@end
