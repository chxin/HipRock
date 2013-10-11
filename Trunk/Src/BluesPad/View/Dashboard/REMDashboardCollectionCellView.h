//
//  REMDashboardCollectionCellView.h
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
@interface REMDashboardCollectionCellView : UICollectionViewCell

@property (nonatomic,weak) UILabel *titleLabel;

@property (nonatomic,weak) UILabel *shareLabel;

@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,weak) UIView *chartContainer;


- (void)initWidgetCell:(REMWidgetObject *)widgetInfo;


@end
