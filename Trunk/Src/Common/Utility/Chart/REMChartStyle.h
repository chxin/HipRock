//
//  ChartStyle.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMBuildingConstants.h"

@interface REMChartStyle : NSObject
@property (nonatomic, assign) BOOL userInteraction;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CPTLineStyle* xLineStyle;
@property (nonatomic, strong) CPTTextStyle* xTextStyle;
@property (nonatomic, strong) CPTLineStyle* xGridlineStyle;
@property (nonatomic, strong) CPTLineStyle* yLineStyle;
@property (nonatomic, strong) CPTTextStyle* yTextStyle;
@property (nonatomic, strong) CPTLineStyle* yGridlineStyle;
@property (nonatomic, assign) NSUInteger horizentalGridLineAmount;
@property (nonatomic, assign) NSUInteger symbolSize;


+(REMChartStyle*)getMaximizedStyle;
+(REMChartStyle*)getMinimunStyle;
@end
