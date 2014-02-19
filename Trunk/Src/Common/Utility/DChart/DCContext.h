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

@protocol DCContextHRangeObserverProtocal <NSObject>
@optional
-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;
-(void)willHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;

@end
//@protocol DCContextYRangeObserverProtocal <NSObject>
//
//-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange;
//
//@end
@protocol DCContextYIntervalObserverProtocal <NSObject>
@optional
-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange;

@end

@interface DCContext : NSObject
-(id)initWithStacked:(BOOL)stacked;
@property (nonatomic, assign) BOOL useTextLayer;
@property (nonatomic, assign) NSUInteger hGridlineAmount;
@property (nonatomic, strong) DCRange* hRange;
@property (nonatomic, readonly) BOOL stacked;
//@property (nonatomic, assign) BOOL pointAlignToTick;
//@property (nonatomic, assign) BOOL xLabelAlignToTick;
@property (nonatomic, assign) CGFloat pointHorizentalOffset;  // 绘制图形时，x方向的偏移量，例如：pointHorizentalOffset=0.1，point.x=1,那么这个点将会被绘制在x=1.1的位置
@property (nonatomic, assign) CGFloat xLabelHorizentalOffset;  // 绘制图形时，x轴文本的偏移量，例如：pointHorizentalOffset=0.1，并且需要在x=1的位置绘制“1月”,那么“1月”将会被绘制在x=1.1的位置


@property (nonatomic,strong) DCRange* globalHRange;

@property (nonatomic, assign) int focusX;
@property (nonatomic, assign) BOOL showIndicatorLineOnFocus;

@property (nonatomic) CGRect plotRect;


-(void)addHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
-(void)removeHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer;
-(void)clearHRangeObservers;
@end
