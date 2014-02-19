//
//  _DCBackgroundBandsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/23/13.
//
//

#import "_DCLayer.h"
#import "DCXYChartBackgroundBand.h"
#import "DCXYChartView.h"

@interface _DCBackgroundBandsLayer : _DCLayer<DCContextHRangeObserverProtocal>
-(void)setBands:(NSArray*)bands;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* fontColor;
@end
