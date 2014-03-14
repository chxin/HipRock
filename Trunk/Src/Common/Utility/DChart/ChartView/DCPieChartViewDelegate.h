//
//  DCPieChartViewDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/13/13.
//
//

#import <Foundation/Foundation.h>
#import "DCChartEnum.h"

@protocol DCPieChartViewDelegate <NSObject>
-(void)pieRotated;
-(void)touchBegan;
@optional
-(void)beginAnimationDone;
@end
