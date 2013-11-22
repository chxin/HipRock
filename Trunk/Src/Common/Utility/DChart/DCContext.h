//
//  DCContext.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRange.h"

extern NSString* const kDCMaxLabel;
extern double const kDCReservedSpace;
extern CGFloat const kDCColumnOffset;
extern CGFloat const kDCAnimationDuration;
extern int const kDCLabelToLine;
extern CGFloat const kDCFocusPointAlpha;
extern CGFloat const kDCSymbolAlpha;
extern CGFloat const kDCFocusPointSymbolMagnify;
extern int const kDCFramesPerSecord;
extern double const kDCYRangeChangeDetection;
extern BOOL const kDCHideLineSymbolWhenDragging;

typedef enum _DCLineType {
    DCLineTypeDefault = 0,
    DCLineTypeDotted = 1
}DCLineType;

@protocol DCContextHRangeObserverProtocal <NSObject>

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;

@end
@protocol DCContextYRangeObserverProtocal <NSObject>

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;

@end
@protocol DCContextYIntervalObserverProtocal <NSObject>

-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange;

@end

@interface DCContext : NSObject
-(id)initWithStacked:(BOOL)stacked;

@property (nonatomic, assign) NSUInteger hGridlineAmount;
@property (nonatomic, strong) DCRange* hRange;
@property (nonatomic, readonly) BOOL stacked;

@property (nonatomic, strong) DCRange* y0Range;
@property (nonatomic, strong) DCRange* y1Range;
@property (nonatomic, strong) DCRange* y2Range;

@property (nonatomic, assign) double y0Interval;
@property (nonatomic, assign) double y1Interval;
@property (nonatomic, assign) double y2Interval;

@property (nonatomic,strong) DCRange* globalHRange;

-(void)addHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
-(void)removeHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
-(void)addY0RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)removeY0RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)addY1RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)removeY1RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)addY2RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)removeY2RangeObsever:(id<DCContextYRangeObserverProtocal>)observer;
-(void)addY0IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)removeY0IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)addY1IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)removeY1IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)addY2IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)removeY2IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
@end
