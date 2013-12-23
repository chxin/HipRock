//
//  _DCPieView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/20/13.
//
//

#import <UIKit/UIKit.h>
#import "DCPieChartView.h"
#import "DCPieLayer.h"

@interface _DCPieView : UIView
@property (nonatomic, weak) DCPieChartView* view;
@property (nonatomic,strong) DCPieLayer* pieLayer;
-(void)redraw;
@end
