//
//  DCPieChartView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import <UIKit/UIKit.h>
#import "DCContext.h"
#import "DCPieDataPoint.h"
#import "DCPieSeries.h"
#import "DCPieChartViewDelegate.h"
#import "REMCommonHeaders.h"
#import "REMChartHeader.h"
#import "REMChartStyle.h"

@interface DCPieChartView : UIView
@property (nonatomic, weak) REMChartStyle* chartStyle;
@property (nonatomic,strong,readonly) DCPieSeries* series;
@property (nonatomic,assign) CGFloat radius;            // 圆形区域半径
@property (nonatomic,assign) CGFloat radiusForShadow;   // 投影半径
@property (nonatomic,assign) CGFloat rotationAngle;     // 扇图已经旋转的角度，值域为[0-2)，例如需要旋转90°，rotationAngle=0.5
@property (nonatomic,assign) CGFloat fullAngle;         // 扇图的总体的角度和，值域为[0-2]，例如如果只需要画半圆，fullAngle=1
@property (nonatomic,assign) CGFloat indicatorAlpha;
@property (nonatomic,assign) BOOL showIndicator;

@property (nonatomic, assign) BOOL playBeginAnimation;
@property (nonatomic, weak) id<DCPieChartViewDelegate> delegate;

@property (nonatomic, readonly, assign) NSUInteger focusPointIndex;

@property (nonatomic, readonly, assign) REMDirection rotateDirection;

- (id)initWithFrame:(CGRect)frame series:(DCPieSeries*)series;
-(void)setSlice:(DCPieDataPoint*)slice hidden:(BOOL)hidden;
-(void)showPercentageTexts;
-(void)hidePercentageTexts;
-(void)redraw;
-(void)setIndicatorHidden:(BOOL)hidden;
@end
