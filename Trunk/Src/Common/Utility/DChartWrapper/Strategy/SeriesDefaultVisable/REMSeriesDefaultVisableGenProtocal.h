//
//  REMSeriesDefaultVisableGenProtocal.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"

@protocol REMSeriesDefaultVisableGenProtocal <NSObject>
-(BOOL)getDefaultVisible:(REMEnergyTargetModel*)target;
@end
