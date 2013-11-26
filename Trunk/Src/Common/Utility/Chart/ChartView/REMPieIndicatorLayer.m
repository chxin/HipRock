//
//  REMPieIndicatorLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import "REMPieIndicatorLayer.h"
#import "REMColor.h"

@implementation REMPieIndicatorLayer
-(void)drawInContext:(CGContextRef)ctx {
    self.contentsScale = [[UIScreen mainScreen] scale];
    [super drawInContext:ctx];
    
//    UIColor* shadowColor = [REMColor colorByHexString:kDCPieShadowColor alpha:self.fullAngle/2];
//    CGContextSetFillColorWithColor(ctx, shadowColor.CGColor);
//    CGContextMoveToPoint(ctx, self.center.x, self.center.y);
//    CGContextAddArc(ctx, self.center.x, self.center.y, self.radiusForShadow, 0, M_PI*2, 0);
//    CGContextDrawPath(ctx, kCGPathFill);
//    
//    CGFloat startAnglePI = self.rotationAngle * M_PI;
//    for (int i = 0; i < self.series.datas.count; i++) {
//        DCPieDataPoint* point = self.series.datas[i];
//        if (point.hidden || point.pointType != DCDataPointTypeNormal) continue;
//        CGFloat pieSlicePI = point.value.doubleValue / self.series.sumVisableValue * M_PI * self.fullAngle;
//        UIColor* color = [REMColor colorByIndex:i].uiColor;
//        CGContextSetFillColorWithColor(ctx, color.CGColor);
//        CGContextMoveToPoint(ctx, self.center.x, self.center.y);
//        CGContextAddArc(ctx, self.center.x, self.center.y, self.radius, startAnglePI, pieSlicePI+startAnglePI, 0);
//        CGContextDrawPath(ctx, kCGPathFill);
//        startAnglePI+=pieSlicePI;
//    }
//    
//    if(self.indicatorAlpha > 0) {
        UIColor* indicatorColor = [REMColor colorByHexString:@"#e9e9e9" alpha:0.8];
        CGContextSetFillColorWithColor(ctx, indicatorColor.CGColor);
        CGContextMoveToPoint(ctx, self.frame.size.width/2, self.frame.size.height/2-self.pieRadius * 2 / 3);
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.pieRadius+1, -M_PI/20-M_PI/2, M_PI/20-M_PI/2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
//    }
}
@end
