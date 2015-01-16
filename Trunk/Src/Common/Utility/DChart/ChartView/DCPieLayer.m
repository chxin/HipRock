//
//  DCPieLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/15/13.
//
//

#import "DCPieLayer.h"
#import "DCUtility.h"

const double kDCPiePercentageTextThreshold = 0.05; // 百分比低于这个值的不显示百分比文本

@implementation DCPieLayer
-(id)init {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.transform = CATransform3DMakeRotation(-M_PI_2, 0.0f, 0.0f, 1.0f);
        _percentageTextHidden = YES;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    double sum = [self.animationManager getVisableSliceSum];
    if (sum > 0) {
        UIColor* shadowColor = [REMColor colorByHexString:kDCPieShadowColor alpha:self.view.indicatorAlpha];
        CGContextSetFillColorWithColor(ctx, shadowColor.CGColor);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddArc(ctx, center.x, center.y, self.view.radiusForShadow, 0, M_PI*2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGFloat startAnglePI = self.view.rotationAngle * M_PI;
        UIFont* percentageFont = self.view.chartStyle.piePercentageTextFont;
        for (int i = 0; i < self.view.series.datas.count; i++) {
            DCPieDataPoint* point = self.view.series.datas[i];
            if (point.pointType != DCDataPointTypeNormal) continue;
            // 计算扇形区域的角度
            CGFloat pointValue = [self.animationManager getVisableValueOfPoint:point];
            CGFloat pieSlicePI = pointValue / sum * M_PI * self.view.fullAngle;
            // 绘制扇型区域
            CGContextSetFillColorWithColor(ctx, point.color.CGColor);
            CGContextMoveToPoint(ctx, center.x, center.y);
            CGContextAddArc(ctx, center.x, center.y, self.view.radius, startAnglePI, pieSlicePI+startAnglePI, 0);
            CGContextDrawPath(ctx, kCGPathFill);
            
            /*
             * 当ChartStyle要求百分比文本需要显示，且扇区所占的百分比大于kDCPiePercentageTextThreshold（5%）时，绘制百分比文本
             */
            if (!self.view.chartStyle.piePercentageTextHidden && !self.percentageTextHidden && pointValue / sum > kDCPiePercentageTextThreshold) {
                CGContextSaveGState(ctx);
                // 绘制在扇形的中间角度区域
                CGFloat centerAngle = startAnglePI + pieSlicePI / 2;
                CGPoint textCenter;
                textCenter.x = center.x + sin(centerAngle) * self.view.chartStyle.piePercentageTextRadius;
                textCenter.y = center.y - cos(centerAngle) * self.view.chartStyle.piePercentageTextRadius;
                NSString* percentageText = [NSString stringWithFormat:@"%.02f%%",pointValue * 100 / sum];
                CGSize textSize = [DCUtility getSizeOfText:percentageText forFont:percentageFont];
                
                // 旋转90°，并且修正文本的位置
                CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI/2);
                transform1.tx = self.frame.size.height;
                CGContextConcatCTM(ctx, transform1);
                
                [DCUtility drawText:percentageText inContext:ctx font:percentageFont rect:CGRectMake(textCenter.x-textSize.width/2, textCenter.y-textSize.height/2, textSize.width, textSize.height) alignment:NSTextAlignmentCenter lineBreak:NSLineBreakByClipping color:self.view.chartStyle.piePercentageTextColor];
                CGContextRestoreGState(ctx);
            }
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
