//
//  DCChartPieWrapperDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "DCChartWrapperDelegate.h"

@protocol DCChartPieWrapperDelegate <DCChartWrapperDelegate>

@optional
/*
 * points: List<REMEnergyData>
 * colors: List<UIColor>
 * names: List<NSString>
 */
-(void)highlightPoint:(DCPieDataPoint*)point direction:(REMDirection)direction;
@end
