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
@end
