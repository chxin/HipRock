//
//  DCXYSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCSeries.h"
#import "DCAxis.h"
#import "DCRange.h"
#import "REMEnergyTargetModel.h"
#import "_DCCoordinateSystem.h"
@class _DCSeriesLayer;
@class DCColumnSeriesGroup;

typedef enum _DCLineSymbolType {
    DCLineSymbolTypeNone = INT32_MIN,
    DCLineSymbolTypeRound = 0,
    DCLineSymbolTypeDiamond = 1,
    DCLineSymbolTypeRectangle = 2,
    DCLineSymbolTypeTriangle = 3,
    DCLineSymbolTypeBackTriangle = 4
    
}DCLineSymbolType;

@interface DCXYSeries : DCSeries
@property (nonatomic, strong) DCRange* visableRange;
@property (nonatomic, readonly) NSNumber* visableYMax;
@property (nonatomic, readonly) NSNumber* visableYMin;
@property (nonatomic, strong) NSNumber* visableYMaxThreshold; // visableYMax不允许小于这个值

@property (nonatomic, weak) REMEnergyTargetModel* target;
@property (nonatomic, weak) _DCCoordinateSystem* coordinate;
@property (nonatomic, weak) DCColumnSeriesGroup* seriesGroup;
//@property (nonatomic, assign) CGFloat pointXOffset;
@property (nonatomic, weak) _DCSeriesLayer* seriesLayer;

@property (nonatomic, assign) BOOL hidden;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) DCLineSymbolType symbolType;
@property (nonatomic, assign) CGFloat symbolSize;
//@property (nonatomic, assign) CGFloat xRectStartAt;             // 柱的Rect的从整数点的偏移位置
//@property (nonatomic, assign) CGFloat columnWidthInCoordinate;  // 柱的宽度

@property (nonatomic, strong) NSString* coordinateSystemName;   // 此属性决定该序列隶属于哪个CoordinateSystem。等于宿主CoordinateSystem.name

//-(void)copyFromSeries:(DCXYSeries*)series;
@end
