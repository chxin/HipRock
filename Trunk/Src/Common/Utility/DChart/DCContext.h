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
extern CGFloat const kDCUnfocusPointSymbolAlph;
extern int const kDCFramesPerSecord;
extern BOOL const kDCHideLineSymbolWhenDragging;
extern NSString* const kDCPieShadowColor;
extern NSString* const kDCPieIndicatorColor;

typedef enum _DCLineType {
    DCLineTypeDefault = 0,
    DCLineTypeDotted = 1
}DCLineType;

@protocol DCContextHRangeObserverProtocal <NSObject>

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;
-(void)willHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;

@end
//@protocol DCContextYRangeObserverProtocal <NSObject>
//
//-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;
//
//@end
@protocol DCContextYIntervalObserverProtocal <NSObject>

-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange;

@end

@interface DCContext : NSObject
-(id)initWithStacked:(BOOL)stacked;

@property (nonatomic, assign) NSUInteger hGridlineAmount;
@property (nonatomic, strong) DCRange* hRange;
@property (nonatomic, readonly) BOOL stacked;
@property (nonatomic, assign) BOOL pointAlignToTick;
@property (nonatomic, assign) BOOL xLabelAlignToTick;

@property (nonatomic,strong) DCRange* globalHRange;

@property (nonatomic, assign) int focusX;
@property (nonatomic, assign) BOOL showIndicatorOnFocus;


-(void)addHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
-(void)removeHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
@end
