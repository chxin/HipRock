//
//  DCDataPoint.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REMEnergyData.h"
#import "REMEnergyTargetModel.h"
typedef enum _DCDataPointType {
    DCDataPointTypeNormal,  // 正常数据点，有值，有EnergyData。
    DCDataPointTypeBreak,   // 破点，无值，有EnergyData，在绘制线图时会中断曲线
    DCDataPointTypeEmpty    // 空点，无值，无EnergyData，在绘制线图时不会中断曲线
}DCDataPointType;

@interface DCDataPoint : NSObject<NSCopying>
@property (nonatomic) NSNumber* value;
@property (nonatomic, assign) DCDataPointType pointType;
@property (nonatomic, weak) REMEnergyData* energyData;
@property (nonatomic, weak) REMEnergyTargetModel* target;
@end
