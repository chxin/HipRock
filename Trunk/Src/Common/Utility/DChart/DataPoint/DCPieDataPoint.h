//
//  DCPieDataPoint.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCDataPoint.h"

@interface DCPieDataPoint : DCDataPoint
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, weak) DCPieDataPoint* nextPoint;
@property (nonatomic, strong) UIColor* color;
@end
