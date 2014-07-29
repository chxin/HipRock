//
//  REMWrapperFactor.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/29/14.
//
//

#import <Foundation/Foundation.h>
#import "DAbstractChartWrapper.h"

@interface REMWrapperFactor : NSObject

+(DAbstractChartWrapper*)constructorWrapper:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig*) wrapperConfig style:(DCChartStyle*)style;
@end
