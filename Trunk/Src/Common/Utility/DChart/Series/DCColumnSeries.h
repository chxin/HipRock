//
//  DCColumnSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYSeries.h"

@interface DCColumnSeries : DCXYSeries
@property (nonatomic, assign) CGFloat xRectStartAt;             // 柱的Rect的从整数点的偏移位置
@property (nonatomic, assign) CGFloat columnWidthInCoordinate;  // 柱的宽度
@end
