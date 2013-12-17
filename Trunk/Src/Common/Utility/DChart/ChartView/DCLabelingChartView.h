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

@interface DCLabelingChartView : UIView
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, strong) NSString* fontName;
@property (nonatomic, assign) CGFloat tooltipArcLineWidth;

@property (nonatomic, strong) DCLabelingSeries* series;

@property (nonatomic, weak) id<DCLabelingChartDelegate> delegate;

@end
