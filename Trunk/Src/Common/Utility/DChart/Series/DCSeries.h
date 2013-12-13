//
//  DCSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContext.h"

typedef enum _DCSeriesType {
    DCSeriesTypeLine,
    DCSeriesTypeColumn
} DCSeriesType;

@interface DCSeries : NSObject

/*
 * IList<DCDataPoint>
 */
@property (nonatomic, strong) NSArray* datas;
@property (nonatomic) UIColor* color;
@property (nonatomic) DCSeriesType type;

/*
 * seriesData: IList<DCDataPoint>
 */
-(DCSeries*)initWithEnergyData:(NSArray*)seriesData;

@end
