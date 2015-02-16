//
//  REMChartStrategyFactor.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import <Foundation/Foundation.h>
#import "REMChartStrategy.h"
#import "REMDataStore.h"

@interface REMChartStrategyFactor : NSObject
+(REMChartStrategy*)getStrategyByStoreType:(NSString*)storeType;
@end
