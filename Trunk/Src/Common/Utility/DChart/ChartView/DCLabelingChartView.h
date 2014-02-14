//
//  DCLabelingChartView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import <UIKit/UIKit.h>
#import "DCLabelingChartDelegate.h"
#import "DCLabelingSeries.h"
#import "REMChartStyle.h"

@interface DCLabelingChartView : UIView
@property (nonatomic, weak) REMChartStyle* style;
@property (nonatomic, strong) DCLabelingSeries* series;
-(void)unfocusLabel;

@property (nonatomic, weak) id<DCLabelingChartDelegate> delegate;

@end
