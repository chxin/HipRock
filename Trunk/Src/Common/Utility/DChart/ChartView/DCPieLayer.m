//
//  DCPieLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/15/13.
//
//

#import "DCPieLayer.h"

@implementation DCPieLayer
-(id)init {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.transform = CATransform3DMakeRotation(-M_PI_2, 0.0f, 0.0f, 1.0f);
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (self.view.series.sumVisableValue > 0) {
        UIColor* shadowColor = [REMColor colorByHexString:kDCPieShadowColor alpha:self.view.indicatorAlpha];
        CGContextSetFillColorWithColor(ctx, shadowColor.CGColor);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddArc(ctx, center.x, center.y, self.view.radiusForShadow, 0, M_PI*2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGFloat startAnglePI = self.view.rotationAngle * M_PI;
        for (int i = 0; i < self.view.series.datas.count; i++) {
            DCPieDataPoint* point = self.view.series.datas[i];
            if (point.hidden || point.pointType != DCDataPointTypeNormal) continue;
            CGFloat pieSlicePI = point.value.doubleValue / self.view.series.sumVisableValue * M_PI * self.view.fullAngle;
            CGContextSetFillColorWithColor(ctx, point.color.CGColor);
            CGContextMoveToPoint(ctx, center.x, center.y);
            CGContextAddArc(ctx, center.x, center.y, self.view.radius, startAnglePI, pieSlicePI+startAnglePI, 0);
            CGContextDrawPath(ctx, kCGPathFill);
            startAnglePI+=pieSlicePI;
        }
        
//        if(self.view.indicatorAlpha > 0 && self.view.showIndicator) {
//            CGPoint indicatorPoint = CGPointMake(center.x, center.y-self.view.radius*2/3);
//            UIColor* indicatorColor = [REMColor colorByHexString:kDCPieIndicatorColor alpha:self.view.indicatorAlpha];
//            CGContextSetFillColorWithColor(ctx, indicatorColor.CGColor);
//            CGContextMoveToPoint(ctx, indicatorPoint.x, indicatorPoint.y);
//            CGContextAddArc(ctx, center.x, center.y, self.view.radius+.2, -M_PI/20-M_PI/2, M_PI/20-M_PI/2, 0);
//            CGContextDrawPath(ctx, kCGPathFill);
//        }
    }
}
@end
