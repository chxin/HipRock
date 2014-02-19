//
//  DCLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCLayer.h"

const BOOL kDCDefaultSuspendRedraw = NO;

@implementation _DCLayer
-(id)initWithContext:(DCContext*)context view:(DCXYChartView*)view {
    self = [self init];
    if (self) {
        _graphContext = context;
        _view = view;
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}
@end
