//
//  REMSeriesGroupingCommodityGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesGroupingCommodityGen.h"

@implementation REMSeriesGroupingCommodityGen
-(NSString*)getGroupName:(REMEnergyTargetModel*)target {
    return [NSString stringWithFormat:@"%lld", target.commodityId];
}
@end
