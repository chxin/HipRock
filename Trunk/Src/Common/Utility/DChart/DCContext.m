//
//  DCContext.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCContext.h"
#import "DCUtility.h"

NSString* const kDCMaxLabel = @"999,999T";
double const kDCReservedSpace = 1.1;   // 纵向预留10%的高度
CGFloat const kDCColumnOffset = 0.1;    // 柱图的横向预留空间
int const kDCLabelToLine = 5;              // label到轴线的距离

int const kDCFramesPerSecord = 60;          // 动画帧数
CGFloat const kDCAnimationDuration = 0.4;    // 动画的时间长度

CGFloat const kDCSymbolAlpha = 1;    // 线图Symbol的alpha

CGFloat const kDCFocusPointAlpha = 0.42;    // focus的柱图，未被关注的柱子的透明度
CGFloat const kDCUnfocusPointSymbolAlph = 0.4;    // focus的线图的symbol的alpha

BOOL const kDCHideLineSymbolWhenDragging = NO;  // 在拖动时是否隐藏Symbol


NSString* const kDCPieShadowColor = @"#e9e9e9";
NSString* const kDCPieIndicatorColor = @"#e9e9e9";

@interface DCContext()
@property (nonatomic) NSMutableArray* hRangeObservers;
@end

@implementation DCContext
-(id)init {
    self = [super init];
    if (self) {
        _pointHorizentalOffset = 0;
        _xLabelHorizentalOffset = 0;
//        _pointAlignToTick = NO;
//        _xLabelAlignToTick = NO;
        _focusX = INT32_MIN;
    }
    return self;
}
-(void)addHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer {
    if (observer == nil) return;
    if (self.hRangeObservers == nil) self.hRangeObservers = [[NSMutableArray alloc]init];
    if (![self.hRangeObservers containsObject:observer]) [self.hRangeObservers addObject:observer];
}
-(void)removeHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer {
    if (self.hRangeObservers == nil || self.hRangeObservers.count==0) return;
    for (id o in self.hRangeObservers) {
        if (o == observer) {
            [self.hRangeObservers removeObject:o];
            break;
        }
    }
}

-(void)clearHRangeObservers {
    [self.hRangeObservers removeAllObjects];
}


-(void)setHRange:(DCRange *)hRange {
    if ([DCRange isRange:hRange equalTo:self.hRange]) return;
    DCRange* oldRange = self.hRange;
    
    for (id o in self.hRangeObservers) {
        if ([o respondsToSelector:@selector(willHRangeChanged:newRange:)]) {
            [o willHRangeChanged:oldRange newRange:hRange];
        }
    }
    _hRange = hRange;
    
    for (id o in self.hRangeObservers) {
        if ([o respondsToSelector:@selector(didHRangeChanged:newRange:)]) {
            [o didHRangeChanged:oldRange newRange:self.hRange];
        }
    }
}
@end
