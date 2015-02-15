//
//  _DCHorizontalBackgroundLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/11/14.
//
//

#import "_DCHorizontalBackgroundLayer.h"
#import "DCXYChartBackgroundBand.h"
#import "DCUtility.h"

@interface _DCHorizontalBackgroundLayer()
@property (nonatomic, strong) NSMutableDictionary* bandLayerDic;
@end

@implementation _DCHorizontalBackgroundLayer
-(id)init {
    self = [super init];
    if (self) {
        _bandLayerDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange *)yRange {
    [self redraw];
}

-(void)redraw {
    NSArray* yAxes = [self.view getYAxes];
    for (DCAxis* yAxis in yAxes) {
        if (REMIsNilOrNull(yAxis.backgroundBands)) continue;
        DCRange * yRange = yAxis.coordinateSystem.yRange;
        if (REMIsNilOrNull(yRange)) continue;
        for(DCXYChartBackgroundBand* band in yAxis.backgroundBands) {
            CGFloat yTop = [DCUtility getScreenYIn:self.graphContext.plotRect yVal:band.range.end vRange:yRange];
            CGFloat yBottom = [DCUtility getScreenYIn:self.graphContext.plotRect yVal:band.range.location vRange:yRange];
            
            NSString* key = [NSString stringWithFormat:@"%lu", (unsigned long)band.hash];
            CALayer* layer = self.bandLayerDic[key];
            if (REMIsNilOrNull(layer)) {
                layer = [[CALayer alloc]init];
                [self.bandLayerDic setObject:layer forKey:key];
                layer.backgroundColor = band.color.CGColor;
                [self addSublayer:layer];
            }
            CGFloat xLeft = self.graphContext.plotRect.origin.x;
            layer.frame = CGRectMake(xLeft, yTop, self.graphContext.plotRect.size.width, yBottom-yTop);
        }
    }
}
@end
