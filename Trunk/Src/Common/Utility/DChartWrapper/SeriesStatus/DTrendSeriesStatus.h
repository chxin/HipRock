//
//  DTrendSeriesStatus.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "DSeriesStatus.h"
#import "DCSeries.h"

@interface DTrendSeriesStatus : DSeriesStatus
@property (nonatomic,assign) DCSeriesType originalType;
@property (nonatomic,assign) DCSeriesType currentType;
@end
