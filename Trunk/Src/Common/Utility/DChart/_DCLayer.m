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
-(void)setNeedsDisplay {
    if (!self.redrawSuspended) [super setNeedsDisplay];
}

-(id)initWithContext:(DCContext*)context {
    self = [super init];
    if (self) {
        self.redrawSuspended = kDCDefaultSuspendRedraw;
        self.graphContext = context;
        self.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}
@end
