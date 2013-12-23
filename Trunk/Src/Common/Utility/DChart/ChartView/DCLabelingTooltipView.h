//
//  DCLabelingTooltipView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/17/13.
//
//

#import <UIKit/UIKit.h>
#import "REMChartHeader.h"

@interface DCLabelingTooltipView : UIView
@property (nonatomic, strong) NSString* benchmarkText;
@property (nonatomic, strong) NSString* labelText;

@property (nonatomic, weak) REMChartStyle* style;

-(void)showAt:(CGPoint)point;
- (id)initWithStyle:(REMChartStyle*)style;
@end
