//
//  DCLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DCXYChartView.h"

@interface _DCLayer : CALayer

@property (nonatomic, weak, readonly) DCContext* graphContext;
@property (nonatomic, weak, readonly) DCXYChartView* view;

-(id)initWithContext:(DCContext*)context view:(DCXYChartView*)view;

@end
