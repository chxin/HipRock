//
//  DCLabelingChartView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import <UIKit/UIKit.h>
#import "DCLabelingChartDelegate.h"

@interface DCLabelingChartView : UIView
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingRight;

@property (nonatomic, weak) id<DCLabelingChartDelegate> delegate;
@end
