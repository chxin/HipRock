//
//  _DCVerticalBackgroundLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/23/13.
//
//

#import "_DCLayer.h"
#import "DCXYChartBackgroundBand.h"
#import "DCXYChartView.h"

@interface _DCVerticalBackgroundLayer : _DCLayer<DCContextHRangeObserverProtocal>
-(void)setBands:(NSArray*)bands;
@end
