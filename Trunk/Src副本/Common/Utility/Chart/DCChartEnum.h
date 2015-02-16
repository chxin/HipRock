/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: DCChartEnum.h
 * Created      : Zilong-Oscar.Xu on 9/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnergyData.h"
#import "REMBuildingConstants.h"
#import "REMEnergyTargetModel.h"
#import "REMColor.h"
#import "DCLabelingLabel.h"
#import "DCPieDataPoint.h"

typedef enum _DCLineType {
    DCLineTypeDefault = 0,
    DCLineTypeDotted = 1,
    DCLineTypeDashed = 2,
    DCLineTypeShortDashed = 3
}DCLineType;
typedef enum _DChartStatus {
    DChartStatusNormal,
    DChartStatusFocus
}DChartStatus;
typedef enum _REMDirection{
    REMDirectionLeft = -1,  // 顺时针
    REMDirectionNone = 0,
    REMDirectionRight = 1   // 逆时针
}REMDirection;
