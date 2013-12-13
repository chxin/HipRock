//
//  DCHGridlineLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCLayer.h"
#import "DCAxis.h"
#import "DCUtility.h"

@interface _DCHGridlineLayer : _DCLayer

@property (nonatomic,assign) float lineWidth;
@property (nonatomic) UIColor* lineColor;
@property (nonatomic,assign) DCLineType lineStyle;

@end
