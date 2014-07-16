//
//  REMSeriesTargetBaselineVisableGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesTargetBaselineVisableGen.h"

@implementation REMSeriesTargetBaselineVisableGen
-(BOOL)getDefaultVisible:(REMEnergyTargetModel*)target {
    return target.type != REMEnergyTargetOrigValue;
}
@end
