//
//  REMSeriesGroupingGenProtocal.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"

@protocol REMSeriesGroupingGenProtocal <NSObject>
-(NSString*)getGroupName:(REMEnergyTargetModel*)target;
@end
