//
//  DCPieSeries.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCSeries.h"
#import "DCPieDataPoint.h"

@interface DCPieSeries : DCSeries
@property (nonatomic, readonly) double sumVisableValue;

-(void)didPointHiddenChanged:(DCPieDataPoint*)point;
-(CGFloat)findNearbySliceCenter:(CGFloat)angle;
-(NSUInteger)findIndexOfSlide:(CGFloat)angle;
@end
