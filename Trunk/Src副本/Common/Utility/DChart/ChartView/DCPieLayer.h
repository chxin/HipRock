//
//  DCPieLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/15/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "DCPieChartView.h"
#import "DCPieChartAnimationManager.h"
#import "REMCommonHeaders.h"


@interface DCPieLayer : CALayer
@property (nonatomic, weak) DCPieChartView* view;
@property (nonatomic, weak) DCPieChartAnimationManager* animationManager;
@property (nonatomic, assign) BOOL percentageTextHidden;    // 此属性为False时，无论ChartStyle里面是否要求显示百分比文本，都不会绘制文本。
@end
