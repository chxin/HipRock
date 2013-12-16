//
//  DCPieChartViewDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/13/13.
//
//

#import <Foundation/Foundation.h>
#import "REMChartHeader.h"

@protocol DCPieChartViewDelegate <NSObject>

-(void)pieRotated;
-(void)touchBegan;
@end
