//
//  REMSeriesGroupingUomGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesGroupingUomGen.h"

@implementation REMSeriesGroupingUomGen
-(NSString*)getGroupName:(REMEnergyTargetModel*)target {
    return [NSString stringWithFormat:@"%lld", target.uomId];
}
@end
