//
//  DCChartLabelingWrapperDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "DCChartWrapperDelegate.h"

@protocol DCChartLabelingWrapperDelegate <DCChartWrapperDelegate>

@optional
-(void)highlightPoint:(DCLabelingLabel*)point;
@end
