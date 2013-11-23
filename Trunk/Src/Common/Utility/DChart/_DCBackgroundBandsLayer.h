//
//  _DCBackgroundBandsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/23/13.
//
//

#import "_DCLayer.h"
#import "DCXYChartBackgroundBand.h"

@interface _DCBackgroundBandsLayer : _DCLayer<DCContextHRangeObserverProtocal>
-(void)setBands:(NSArray*)bands;
@end
