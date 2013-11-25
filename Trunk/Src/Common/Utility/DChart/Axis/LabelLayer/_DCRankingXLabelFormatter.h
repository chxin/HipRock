//
//  _DCRankingXLabelFormatter.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/25/13.
//
//

#import <Foundation/Foundation.h>
#import "DCXYSeries.h"

@interface _DCRankingXLabelFormatter : NSFormatter

@property (nonatomic, weak) DCXYSeries* series;
-(id)initWithSeries:(DCXYSeries*)series;

@end
