//
//  DCChartDataProcessor.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import <Foundation/Foundation.h>

@interface DCChartDataProcessor : NSObject
-(NSNumber*)processX:(NSDate*)xLocalTime;
-(NSNumber*)processY:(NSNumber*)yVal;
-(NSDate*)deprocessX:(float)x;
@end
