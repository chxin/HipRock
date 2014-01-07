//
//  DCXYChartViewDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import <Foundation/Foundation.h>
typedef enum _DCHRangeChangeSender {
    DCHRangeChangeSenderByAnimation = 0,    // HRange的改变由动画发起
    DCHRangeChangeSenderByInitialize = 1,   // 初始化发起
    DCHRangeChangeSenderByUserPan = 2,         // HRange的改变由用户的Pan手势发起
    DCHRangeChangeSenderByUserPinch = 3         // HRange的改变由用户的Pan手势发起
} DCHRangeChangeSender;

@protocol DCXYChartViewDelegate <NSObject>
-(void)touchedInPlotAt:(CGPoint)point xCoordinate:(double)xLocation;
-(void)didYIntervalChange:(double)yInterval forAxis:(DCAxis *)yAxis range:(DCRange*)range;
/*
 * return ture to move all series with pan, otherwise the chart will not move.
 */
-(BOOL)panInPlotAt:(CGPoint)point translation:(CGPoint)translation;

-(void)panStopped;
-(void)pinchStopped;

-(void)focusPointChanged:(NSArray*)dcpoints at:(int)x;

/**
 * 返回YES允许HRange的改变，否则HRange将不会改变
 */
-(BOOL)testHRangeChange:(DCRange*)newRange oldRange:(DCRange*)oldRange sendBy:(DCHRangeChangeSender)senderType;
@end
