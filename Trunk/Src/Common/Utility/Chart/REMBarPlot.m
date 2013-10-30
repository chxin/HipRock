//
//  REMBarPlot.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/29/13.
//
//

#import "REMBarPlot.h"
#import "CorePlot-CocoaTouch.h"


/// @endcond

#pragma mark -

/**
 *  @brief A two-dimensional bar plot.
 *  @see See @ref plotAnimationBarPlot "Bar Plot" for a list of animatable properties.
 *  @if MacOnly
 *  @see See @ref plotBindingsBarPlot "Bar Plot Bindings" for a list of supported binding identifiers.
 *  @endif
 **/
@implementation REMBarPlot {
    NSMutableDictionary* pathDic;
}

/// @cond

-(CGFloat)lengthInView:(NSDecimal)decimalLength
{
    CGFloat length;
    
    if ( self.barWidthsAreInViewCoordinates ) {
        length = CPTDecimalCGFloatValue(decimalLength);
    }
    else {
        CPTCoordinate coordinate     = (self.barsAreHorizontal ? CPTCoordinateY : CPTCoordinateX);
        CPTXYPlotSpace *thePlotSpace = (CPTXYPlotSpace *)self.plotSpace;
        NSDecimal xLocation          = thePlotSpace.xRange.location;
        NSDecimal yLocation          = thePlotSpace.yRange.location;
        
        NSDecimal originPlotPoint[2];
        NSDecimal displacedPlotPoint[2];
        
        switch ( coordinate ) {
            case CPTCoordinateX:
                originPlotPoint[CPTCoordinateX]    = xLocation;
                originPlotPoint[CPTCoordinateY]    = yLocation;
                displacedPlotPoint[CPTCoordinateX] = CPTDecimalAdd(xLocation, decimalLength);
                displacedPlotPoint[CPTCoordinateY] = yLocation;
                break;
                
            case CPTCoordinateY:
                originPlotPoint[CPTCoordinateX]    = xLocation;
                originPlotPoint[CPTCoordinateY]    = yLocation;
                displacedPlotPoint[CPTCoordinateX] = xLocation;
                displacedPlotPoint[CPTCoordinateY] = CPTDecimalAdd(yLocation, decimalLength);
                break;
                
            default:
                break;
        }
        
        CGPoint originPoint    = [thePlotSpace plotAreaViewPointForPlotPoint:originPlotPoint];
        CGPoint displacedPoint = [thePlotSpace plotAreaViewPointForPlotPoint:displacedPlotPoint];
        
        switch ( coordinate ) {
            case CPTCoordinateX:
                length = displacedPoint.x - originPoint.x;
                break;
                
            case CPTCoordinateY:
                length = displacedPoint.y - originPoint.y;
                break;
                
            default:
                length = CPTFloat(0.0);
                break;
        }
    }
    return length;
}

-(CGMutablePathRef)newBarPathWithContext:(CGContextRef)context basePoint:(CGPoint)basePoint tipPoint:(CGPoint)tipPoint
{
//    if (pathDic == nil) pathDic = [[NSMutableDictionary alloc]init];
//    if (pathDic[@(tipPoint.x)] != nil) return [[pathDic objectForKey:@(tipPoint.x)] pointerValue];
    
    // This function is used to create a path which is used for both
    // drawing a bar and for doing hit-testing on a click/touch event
    BOOL horizontalBars = self.barsAreHorizontal;
    
    CGFloat barWidthLength = [self lengthInView:self.barWidth] * self.barWidthScale;
    CGFloat halfBarWidth   = CPTFloat(0.5) * barWidthLength;
    
    CGRect barRect;
    
    if ( horizontalBars ) {
        barRect = CPTRectMake(basePoint.x, basePoint.y - halfBarWidth, tipPoint.x - basePoint.x, barWidthLength);
    }
    else {
        barRect = CPTRectMake(basePoint.x - halfBarWidth, basePoint.y, barWidthLength, tipPoint.y - basePoint.y);
    }
    
    int widthNegative  = signbit(barRect.size.width);
    int heightNegative = signbit(barRect.size.height);
    
    // Align to device pixels if there is a line border.
    // Otherwise, align to view space, so fills are sharp at edges.
    // Note: may not have a context if doing hit testing.
    if ( self.alignsPointsToPixels && context ) {
        // Round bar dimensions so adjacent bars always align to the right pixel position
        const CGFloat roundingPrecision = CPTFloat(1.0e6);
        
        barRect.origin.x    = round(barRect.origin.x * roundingPrecision) / roundingPrecision;
        barRect.origin.y    = round(barRect.origin.y * roundingPrecision) / roundingPrecision;
        barRect.size.width  = round(barRect.size.width * roundingPrecision) / roundingPrecision;
        barRect.size.height = round(barRect.size.height * roundingPrecision) / roundingPrecision;
        
        if ( self.lineStyle.lineWidth > 0.0 ) {
            barRect = CPTAlignRectToUserSpace(context, barRect);
        }
        else {
            barRect = CPTAlignIntegralRectToUserSpace(context, barRect);
        }
    }
    
    CGFloat radius     = MIN( MIN( self.barCornerRadius, ABS(barRect.size.width) * CPTFloat(0.5) ), ABS(barRect.size.height) * CPTFloat(0.5) );
    CGFloat baseRadius = MIN( MIN( self.barBaseCornerRadius, ABS(barRect.size.width) * CPTFloat(0.5) ), ABS(barRect.size.height) * CPTFloat(0.5) );
    
    if ( widthNegative && (barRect.size.width > 0.0) ) {
        barRect.origin.x  += barRect.size.width;
        barRect.size.width = -barRect.size.width;
    }
    if ( heightNegative && (barRect.size.height > 0.0) ) {
        barRect.origin.y   += barRect.size.height;
        barRect.size.height = -barRect.size.height;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    if ( radius == 0.0 ) {
        if ( baseRadius == 0.0 ) {
            // square corners
            CGPathAddRect(path, NULL, barRect);
        }
        else {
            CGFloat tipX = barRect.origin.x + barRect.size.width;
            CGFloat tipY = barRect.origin.y + barRect.size.height;
            
            // rounded at base end only
            if ( horizontalBars ) {
                CGPathMoveToPoint(path, NULL, tipX, tipY);
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, tipY, barRect.origin.x, CGRectGetMidY(barRect), baseRadius);
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, barRect.origin.y, tipX, barRect.origin.y, baseRadius);
                CGPathAddLineToPoint(path, NULL, tipX, barRect.origin.y);
            }
            else {
                CGPathMoveToPoint(path, NULL, barRect.origin.x, tipY);
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, barRect.origin.y, CGRectGetMidX(barRect), barRect.origin.y, baseRadius);
                CGPathAddArcToPoint(path, NULL, tipX, barRect.origin.y, tipX, tipY, baseRadius);
                CGPathAddLineToPoint(path, NULL, tipX, tipY);
            }
            CGPathCloseSubpath(path);
        }
    }
    else {
        CGFloat tipX = barRect.origin.x + barRect.size.width;
        CGFloat tipY = barRect.origin.y + barRect.size.height;
        
        if ( baseRadius == 0.0 ) {
            // rounded at tip end only
            CGPathMoveToPoint(path, NULL, barRect.origin.x, barRect.origin.y);
            if ( horizontalBars ) {
                CGPathAddArcToPoint(path, NULL, tipX, barRect.origin.y, tipX, CGRectGetMidY(barRect), radius);
                CGPathAddArcToPoint(path, NULL, tipX, tipY, barRect.origin.x, tipY, radius);
                CGPathAddLineToPoint(path, NULL, barRect.origin.x, tipY);
            }
            else {
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, tipY, CGRectGetMidX(barRect), tipY, radius);
                CGPathAddArcToPoint(path, NULL, tipX, tipY, tipX, barRect.origin.y, radius);
                CGPathAddLineToPoint(path, NULL, tipX, barRect.origin.y);
            }
            CGPathCloseSubpath(path);
        }
        else {
            // rounded at both ends
            if ( horizontalBars ) {
                CGPathMoveToPoint( path, NULL, barRect.origin.x, CGRectGetMidY(barRect) );
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, tipY, CGRectGetMidX(barRect), tipY, baseRadius);
                CGPathAddArcToPoint(path, NULL, tipX, tipY, tipX, CGRectGetMidY(barRect), radius);
                CGPathAddArcToPoint(path, NULL, tipX, barRect.origin.y, CGRectGetMidX(barRect), barRect.origin.y, radius);
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, barRect.origin.y, barRect.origin.x, CGRectGetMidY(barRect), baseRadius);
            }
            else {
                CGPathMoveToPoint( path, NULL, barRect.origin.x, CGRectGetMidY(barRect) );
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, tipY, CGRectGetMidX(barRect), tipY, radius);
                CGPathAddArcToPoint(path, NULL, tipX, tipY, tipX, CGRectGetMidY(barRect), radius);
                CGPathAddArcToPoint(path, NULL, tipX, barRect.origin.y, CGRectGetMidX(barRect), barRect.origin.y, baseRadius);
                CGPathAddArcToPoint(path, NULL, barRect.origin.x, barRect.origin.y, barRect.origin.x, CGRectGetMidY(barRect), baseRadius);
            }
            CGPathCloseSubpath(path);
        }
    }
//    [pathDic setObject:[NSValue valueWithPointer:path] forKey:@(tipPoint.x)];
    
    return path;
}

@end
