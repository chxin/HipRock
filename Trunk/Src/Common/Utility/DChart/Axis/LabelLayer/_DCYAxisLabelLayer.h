//
//  DCYAxisLabelLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "DCAxis.h"
#import "_DCLayer.h"

@interface _DCYAxisLabelLayer : _DCLayer<DCContextYIntervalObserverProtocal>

@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* fontColor;

@property (nonatomic, weak) DCAxis* axis;
@property (nonatomic, assign) BOOL isMajorAxis;

@property (nonatomic, strong) UIColor* axisTitleColor;
@property (nonatomic, assign) CGFloat axisTitleToTopLabel;
@property (nonatomic, assign) CGFloat axisTitleFontSize;
@end
