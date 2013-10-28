//
//  REMDashboardCollectionCellView.h
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMWidgetCollectionViewController.h"

@class REMWidgetCollectionViewController;


@interface REMDashboardCollectionCellView : UICollectionViewCell

@property (nonatomic,weak) UILabel *titleLabel;

@property (nonatomic,weak) UILabel *shareLabel;

@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic) BOOL chartLoaded;

@property (nonatomic) REMEnergyViewData *chartData;

@property (nonatomic, readonly) REMWidgetObject *widgetInfo;

- (void)initWidgetCell:(REMWidgetObject *)widgetInfo withGroupName:(NSString *)groupName;

@property (nonatomic,weak) REMWidgetCollectionViewController *controller;

@property (nonatomic,weak) UIButton  *imageButton;


@end
