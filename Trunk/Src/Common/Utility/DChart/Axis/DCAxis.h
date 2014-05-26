//
//  DCAxis.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRange.h"
#import "DCSeries.h"
#import "DCChartEnum.h"

typedef enum _DCAxisCoordinate {
    DCAxisCoordinateX = 0,
    DCAxisCoordinateY = 1
}DCAxisCoordinate;

@interface DCAxis : NSObject
@property (nonatomic) NSString* axisTitle;
@property (nonatomic,assign) DCAxisCoordinate coordinate;


@property (nonatomic) CGPoint startPoint;   //绘制轴线时的起点
@property (nonatomic) CGPoint endPoint;     //绘制轴线时的终点
@property (nonatomic) CGSize size;
@property (nonatomic, strong) NSArray* backgroundBands;

-(void)attachSeries:(DCSeries*)series;
-(void)detachSeries:(DCSeries*)series;
-(NSUInteger)getVisableSeriesAmount;
@end
