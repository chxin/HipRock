//
//  DCLineSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYSeries.h"

typedef enum _DCLineSymbolType {
    DCLineSymbolTypeNone = INT32_MIN,
    DCLineSymbolTypeRound = 0,
    DCLineSymbolTypeDiamond = 1,
    DCLineSymbolTypeRectangle = 2,
    DCLineSymbolTypeTriangle = 3,
    DCLineSymbolTypeBackTriangle = 4
    
}DCLineSymbolType;

@interface DCLineSeries : DCXYSeries
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) DCLineSymbolType symbol;
@property (nonatomic, assign) CGFloat symbolSize;
@end
