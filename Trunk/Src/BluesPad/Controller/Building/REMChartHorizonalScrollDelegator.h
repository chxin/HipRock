/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartHorizonalScrollManager.h
 * Created      : tantan on 9/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "REMDataRange.h"

@interface REMChartHorizonalScrollDelegator : NSObject<CPTPlotSpaceDelegate>


@property (nonatomic,weak) REMDataRange *globalRange;

@property (nonatomic,weak) REMDataRange *visiableRange;

@property (nonatomic,weak) CPTGraphHostingView *hostView;

@property (nonatomic,weak) NSArray *snapshotArray;


@end
