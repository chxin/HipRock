//
//  DCPieSeries.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCSeries.h"
#import "DCPieDataPoint.h"

typedef struct _DCPieSlice {
    CGFloat sliceBegin; // 饼图Slice的起始角度，值域为0-2
    CGFloat sliceCenter; // 饼图Slice的起始角度和终止角度的均值，值域为0-2
    CGFloat sliceEnd; // 饼图Slice的终止角度的均值，值域为0-2
}DCPieSlice;

@interface DCPieSeries : DCSeries
@property (nonatomic, readonly) double sumVisableValue;
@property (nonatomic, strong) NSArray* pieSlices;

-(void)didPointHiddenChanged:(DCPieDataPoint*)point;
@end
