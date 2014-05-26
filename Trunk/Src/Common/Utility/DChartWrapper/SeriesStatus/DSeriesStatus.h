//
//  DSeriesStatus.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"

@interface DSeriesStatus : NSObject
@property (nonatomic,assign) BOOL hidden;

@property (nonatomic,strong,readonly) NSNumber* targetId;
@property (nonatomic,assign,readonly) REMEnergyTargetType type;
@property (nonatomic,assign,readonly) long commodityId;
@property (nonatomic,readonly) NSNumber* seriesIndex;
-(id)initWithTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex;
@end
