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
//@property (nonatomic, assign) CGFloat paddingTop;
//@property (nonatomic, assign) CGFloat paddingBottom;
//@property (nonatomic, assign) CGFloat minStageWidth;
//@property (nonatomic, assign) CGFloat maxStageWidth;
//@property (nonatomic, assign) CGFloat stageToLineMargin;
//@property (nonatomic, assign) CGFloat labelToLineMargin;
//@property (nonatomic, assign) CGFloat lineWidth;
//
//@property (nonatomic, assign) CGFloat labelWidth;
//@property (nonatomic, assign) CGFloat labelHeight;
//
//@property (nonatomic, strong) UIColor* lineColor;
//@property (nonatomic, strong) NSString* fontName;
//@property (nonatomic, assign) CGFloat tooltipArcLineWidth;
//
//@property (nonatomic, assign) CGFloat stageFontSize;
//@property (nonatomic, assign) CGFloat stageToStageTextMargin;
//@property (nonatomic, assign) CGFloat stageToBorderMargin;
//@property (nonatomic, strong) UIColor* stageFontColor;
//@property (nonatomic,assign) CGFloat tooltipIconLeftMargin;

@property (nonatomic, strong) DCLabelingSeries* series;

@property (nonatomic, weak) id<DCLabelingChartDelegate> delegate;

@end
