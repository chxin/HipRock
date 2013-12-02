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

@interface DCPieChartView : UIView

@property (nonatomic,strong,readonly) DCPieSeries* series;
@property (nonatomic,assign) CGFloat radius;            // 圆形区域半径
@property (nonatomic,assign) CGFloat radiusForShadow;   // 投影半径
@property (nonatomic,assign) CGFloat rotationAngle;     // 扇图已经旋转的角度，值域为[0-2)，例如需要旋转90°，rotationAngle=0.5
@property (nonatomic,assign) CGFloat fullAngle;         // 扇图的总体的角度和，值域为[0-2]，例如如果只需要画半圆，fullAngle=1
@property (nonatomic,assign) CGFloat indicatorAlpha;
@property (nonatomic,assign) BOOL showIndicator;

- (id)initWithFrame:(CGRect)frame series:(DCPieSeries*)series;
@end
