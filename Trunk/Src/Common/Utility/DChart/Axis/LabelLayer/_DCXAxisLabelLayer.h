//
//  DCXAxisLabelLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCMagicLayer.h"
#import <CoreText/CoreText.h>
#import "DCAxis.h"

@interface _DCXAxisLabelLayer : _DCMagicLayer<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* fontColor;
//-(void)viewTouchesMoveFrom:(CGPoint)from to:(CGPoint)to;
@property (nonatomic, weak) DCAxis* axis;
@end
