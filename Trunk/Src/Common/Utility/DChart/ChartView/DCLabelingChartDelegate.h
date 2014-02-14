//
//  DCLabelingChartDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import <Foundation/Foundation.h>
#import "DCLabelingLabel.h"

@protocol DCLabelingChartDelegate <NSObject>
-(void)focusOn:(DCLabelingLabel*)point;
@end
