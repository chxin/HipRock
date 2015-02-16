//
//  _DCXLabelFormatter.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "_DCXLabelFormatterProtocal.h"

@interface _DCXLabelFormatter : NSFormatter<_DCXLabelFormatterProtocal>

-(_DCXLabelFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval;
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) REMEnergyStep step;
@property (nonatomic) int interval;
@property (nonatomic, assign) BOOL stepSupplementary;   // 是否在新的年份/月份/天的第一个日期上补全年月日，默认YES
@end
