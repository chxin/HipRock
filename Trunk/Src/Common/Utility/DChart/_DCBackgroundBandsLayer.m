//
//  _DCBackgroundBandsLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/23/13.
//
//

#import "_DCBackgroundBandsLayer.h"
#import "DCUtility.h"

@interface _DCBackgroundBandsLayer()
@property (nonatomic, strong) NSArray* bands;
@property (nonatomic, strong) NSMutableDictionary* layerDictionary;
@end

@implementation _DCBackgroundBandsLayer
-(id)initWithContext:(DCContext *)context {
    self = [super initWithContext:context];
    if (self) {
        _layerDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)setBands:(NSArray*)bands {
    _bands = bands;
    NSArray* allKeys = self.layerDictionary.allKeys;
    for (NSString* key in allKeys) {
        CALayer* bandLayer = self.layerDictionary[key];
        [bandLayer removeFromSuperlayer];
    }
    [self.layerDictionary removeAllObjects];
    
    [self updateBands:0];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    double xMovementInScreen = self.frame.size.width * (newRange.location - oldRange.location) / newRange.length;
    [self updateBands:xMovementInScreen];
}

-(void)updateBands:(double)xMovementInScreen {
    if (REMIsNilOrNull(self.bands) || self.bands.count == 0) return;
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    NSArray* allKeys = self.layerDictionary.allKeys;
    for (NSString* key in allKeys) {
        CALayer* bandLayer = self.layerDictionary[key];
        CGRect toFrame = CGRectMake(bandLayer.frame.origin.x-xMovementInScreen, bandLayer.frame.origin.y, bandLayer.frame.size.width, bandLayer.frame.size.height);
        if ([DCUtility isFrame:toFrame visableIn:self.bounds]) {
            bandLayer.frame = toFrame;
        } else {
            [self.layerDictionary removeObjectForKey:key];
            [bandLayer removeFromSuperlayer];
        }
    }
    [CATransaction setDisableActions:caTransationState];
    for (DCXYChartBackgroundBand* band in self.bands) {
        if (![DCRange isRange:band.range visableIn:self.graphContext.hRange]) continue;
        NSString* rangeToString = [band.range description];
        if (self.layerDictionary[rangeToString] == nil) {
            CALayer* bandLayer = [[CALayer alloc]init];
            bandLayer.backgroundColor = band.color.CGColor;
            bandLayer.frame = CGRectMake([DCUtility getScreenXIn:self.bounds xVal:band.range.location hRange:self.graphContext.hRange], 0, [DCUtility getScreenXIn:self.bounds xVal:band.range.length hRange:self.graphContext.hRange], self.bounds.size.height);
            [self addSublayer:bandLayer];
        }
    }
}

@end

