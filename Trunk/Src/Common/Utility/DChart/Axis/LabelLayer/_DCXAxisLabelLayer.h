//
//  DCXAxisLabelLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCLayerTrashbox.h"
#import <CoreText/CoreText.h>
#import "DCAxis.h"
#import "_DCLayer.h"

@interface _DCXAxisLabelLayer : _DCLayer<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* fontColor;
//-(void)viewTouchesMoveFrom:(CGPoint)from to:(CGPoint)to;
@property (nonatomic, weak) DCAxis* axis;
@property (nonatomic, strong) NSFormatter* labelFormatter;
@end
