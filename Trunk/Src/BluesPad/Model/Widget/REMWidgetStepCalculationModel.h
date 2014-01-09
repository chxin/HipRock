//
//  REMWidgetStepCalculationModel.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/9/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMTimeRange.h"

@interface REMWidgetStepCalculationModel : NSObject

@property (nonatomic,strong) NSArray *stepList;
@property (nonatomic,strong) NSArray *titleList;
@property (nonatomic) REMEnergyStep defaultStep;
@property (nonatomic) NSUInteger defaultStepIndex;

+ (REMWidgetStepCalculationModel *)tryNewStepByRange:(REMTimeRange *)range;
@end
