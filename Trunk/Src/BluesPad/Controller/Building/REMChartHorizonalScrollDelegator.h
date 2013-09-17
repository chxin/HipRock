//
//  REMChartHorizonalScrollManager.h
//  Blues
//
//  Created by tantan on 9/3/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "REMDataRange.h"

@interface REMChartHorizonalScrollDelegator : NSObject<CPTPlotSpaceDelegate>


@property (nonatomic,strong) REMDataRange *globalRange;

@property (nonatomic,strong) REMDataRange *visiableRange;

@property (nonatomic,strong) CPTGraphHostingView *hostView;

@property (nonatomic,strong) NSArray *snapshotArray;


@end
