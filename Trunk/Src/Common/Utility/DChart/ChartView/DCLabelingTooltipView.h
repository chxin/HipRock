//
//  DCLabelingTooltipView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/17/13.
//
//

#import <UIKit/UIKit.h>
#import "DCChartEnum.h"
#import "DCChartStyle.h"

@interface DCLabelingTooltipView : UIView
@property (nonatomic, strong) NSString* benchmarkText;
@property (nonatomic, strong) NSString* labelText;

@property (nonatomic, weak) DCChartStyle* style;

-(void)showAt:(CGPoint)point;
- (id)initWithStyle:(DCChartStyle*)style;
@end
