//
//  DCAxis.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRange.h"
#import "DCContext.h"
//typedef enum _DCAxisCoordinate {
//    DCAxisCoordinateX = 0,
//    DCAxisCoordinateY = 1
//}DCAxisCoordinate;
//
//typedef enum _DCAxisLabelAlign {
//    DCAxisLabelAlignTopCenter = 0,
//    DCAxisLabelAlignTopLeft = 1,
//    DCAxisLabelAlignTopRight = 2,
//    DCAxisLabelAlignBottomCenter = 3,
//    DCAxisLabelAlignBottomLeft = 4,
//    DCAxisLabelAlignBottomRight = 5,
//    DCAxisLabelAlignMiddleCenter = 6,
//    DCAxisLabelAlignMiddleLeft = 7,
//    DCAxisLabelAlignMiddleRight = 8
//}DCAxisLabelAlign;

//typedef enum _DCAxisType {
//    DCAxisTypeMajor = 0,
//    DCAxisTypeMinor = 1
//}DCAxisType;

@interface DCAxis : NSObject
//@property (nonatomic,assign) DCAxisCoordinate axisCoordinate;
//@property (nonatomic, assign) DCAxisType axisType;
@property (nonatomic) NSString* axisTitle;

@property (nonatomic,assign) float lineWidth;
@property (nonatomic) UIColor* lineColor;
@property (nonatomic,assign) DCLineType lineStyle;

@property (nonatomic) UIFont* labelFont;
@property (nonatomic) UIColor* labelColor;
//@property (nonatomic) CGFloat length; // 上一次绘制的时候，屏幕上轴线的长度。

//@property (nonatomic) DCRange* range;
//@property (nonatomic) DCAxisLabelAlign labelAlign;
@property (nonatomic) CGPoint startPoint;   //绘制轴线时的起点
@property (nonatomic) CGPoint endPoint;     //绘制轴线时的终点
@property (nonatomic) CGSize size;

@property (nonatomic, assign) NSUInteger visableSeriesAmount;  // 附加在该轴上的可见的序列的数量。主要用于y轴的隐藏。

@property (nonatomic, assign) CGFloat labelToLine; //label到轴线的距离
@end
