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
    CGFloat unitLengthInView;
}

-(id)init {
    return [super init];
}

-(id)initWithFrame:(CGRect)newFrame {
    return [super initWithFrame:newFrame];
}

/// @cond

-(BOOL)barAtRecordIndex:(NSUInteger)idx basePoint:(CGPoint *)basePoint tipPoint:(CGPoint *)tipPoint
{
    BOOL horizontalBars            = self.barsAreHorizontal;
    CPTCoordinate independentCoord = (horizontalBars ? CPTCoordinateY : CPTCoordinateX);
    CPTCoordinate dependentCoord   = (horizontalBars ? CPTCoordinateX : CPTCoordinateY);
    
    CPTPlotSpace *thePlotSpace = self.plotSpace;
    
    if ( self.doublePrecisionCache ) {
        double plotPoint[2];
        plotPoint[independentCoord] = [self cachedDoubleForField:CPTBarPlotFieldBarLocation recordIndex:idx];
        if ( isnan(plotPoint[independentCoord]) ) {
            return NO;
        }
        
        // Tip point
        plotPoint[dependentCoord] = [self cachedDoubleForField:CPTBarPlotFieldBarTip recordIndex:idx];
        if ( isnan(plotPoint[dependentCoord]) ) {
            return NO;
        }
        *tipPoint = [thePlotSpace plotAreaViewPointForDoublePrecisionPlotPoint:plotPoint];
        
        // Base point
        if ( !self.barBasesVary ) {
            plotPoint[dependentCoord] = CPTDecimalDoubleValue(self.baseValue);
        }
        else {
            plotPoint[dependentCoord] = [self cachedDoubleForField:CPTBarPlotFieldBarBase recordIndex:idx];
        }
        if ( isnan(plotPoint[dependentCoord]) ) {
            return NO;
        }
        *basePoint = [thePlotSpace plotAreaViewPointForDoublePrecisionPlotPoint:plotPoint];
    }
    else {
        NSDecimal plotPoint[2];
        plotPoint[independentCoord] = [self cachedDecimalForField:CPTBarPlotFieldBarLocation recordIndex:idx];
        if ( NSDecimalIsNotANumber(&plotPoint[independentCoord]) ) {
            return NO;
        }
        
        // Tip point
        plotPoint[dependentCoord] = [self cachedDecimalForField:CPTBarPlotFieldBarTip recordIndex:idx];
        if ( NSDecimalIsNotANumber(&plotPoint[dependentCoord]) ) {
            return NO;
        }
        *tipPoint = [thePlotSpace plotAreaViewPointForPlotPoint:plotPoint];
        
        // Base point
        if ( !self.barBasesVary ) {
            plotPoint[dependentCoord] = self.baseValue;
        }
        else {
            plotPoint[dependentCoord] = [self cachedDecimalForField:CPTBarPlotFieldBarBase recordIndex:idx];
        }
        if ( NSDecimalIsNotANumber(&plotPoint[dependentCoord]) ) {
            return NO;
        }
        *basePoint = [thePlotSpace plotAreaViewPointForPlotPoint:plotPoint];
    }
    
    // Determine bar width and offset.
    CGFloat barOffsetLength = [self lengthInView:self.barOffset recal:NO] * self.barOffsetScale;
    
    // Offset
    if ( horizontalBars ) {
        basePoint->y += barOffsetLength;
        tipPoint->y  += barOffsetLength;
    }
    else {
        basePoint->x += barOffsetLength;
        tipPoint->x  += barOffsetLength;
    }
    
    return YES;
}
-(CGFloat)lengthInView:(NSDecimal)decimalLength recal:(BOOL)recal
{
    if (!recal) return unitLengthInView * [NSDecimalNumber decimalNumberWithDecimal:decimalLength].floatValue;
    CGFloat length = 0.0;
    
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
-(void)drawInContext:(CGContextRef)ctx {
    unitLengthInView = [self lengthInView:[NSDecimalNumber numberWithInt:1].decimalValue recal:YES];
    [super drawInContext:ctx];
}
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}
-(void)renderAsVectorInContext:(CGContextRef)context
{
    self.masksToBorder = NO;
    if ( self.hidden ) {
        return;
    }
    
    CPTMutableNumericData *cachedLocations = [self cachedNumbersForField:CPTBarPlotFieldBarLocation];
    CPTMutableNumericData *cachedLengths   = [self cachedNumbersForField:CPTBarPlotFieldBarTip];
    if ( (cachedLocations == nil) || (cachedLengths == nil) ) {
        return;
    }
    
    BOOL basesVary                     = self.barBasesVary;
    CPTMutableNumericData *cachedBases = [self cachedNumbersForField:CPTBarPlotFieldBarBase];
    if ( basesVary && (cachedBases == nil) ) {
        return;
    }
    
    NSUInteger barCount = self.cachedDataCount;
    if ( barCount == 0 ) {
        return;
    }
    
    if ( cachedLocations.numberOfSamples != cachedLengths.numberOfSamples ) {
        [NSException raise:CPTException format:@"Number of bar locations and lengths do not match"];
    }
    
    if ( basesVary && (cachedLengths.numberOfSamples != cachedBases.numberOfSamples) ) {
        [NSException raise:CPTException format:@"Number of bar lengths and bases do not match"];
    }
    
    // This is where subclasses do their drawing
//    if ( self.renderingRecursively ) {
//        [self applyMaskToContext:context];
//    }
//    [self.shadow setShadowInContext:context];
//    [super renderAsVectorInContext:context];
    
    CGContextBeginTransparencyLayer(context, NULL);
//    for ( NSUInteger ii = 0; ii < barCount; ii++ ) {
//        // Draw
//        [self drawBarInContext:context recordIndex:ii];
//    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    for ( NSUInteger ii = 0; ii < barCount; ii++ ) {
        // Draw
        CGPoint basePoint, tipPoint;
        BOOL barExists = [self barAtRecordIndex:ii basePoint:&basePoint tipPoint:&tipPoint];
        
        if ( !barExists ) {
            continue;
        }
        
        if (![self barIsVisibleWithIndex:ii]) continue;
        CGRect r = [self getRectOfBasePoint:basePoint tipPoint:tipPoint];
        CGPathAddRect(path, Nil, r);
    }
    CGContextSaveGState(context);
//    CPTFill *theBarFill = [self barFillForIndex:0];
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    
//    if ( [theBarFill isKindOfClass:[CPTFill class]] ) {
//        [theBarFill fillPathInContext:context];
//    }
    CGContextRestoreGState(context);
    CGPathRelease(path);


    CGContextEndTransparencyLayer(context);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(-25, 0, 50, 50));
//    CGContextSaveGState(context);
//    CPTFill *theBarFill = [self barFillForIndex:0];
//    if ( [theBarFill isKindOfClass:[CPTFill class]] ) {
//        CGContextBeginPath(context);
//        CGContextAddPath(context, path);
//        [theBarFill fillPathInContext:context];
//    }
//    CGContextRestoreGState(context);
//    CGPathRelease(path);
//    
//    CGContextEndTransparencyLayer(context);
////    self.paddingLeft = 25;
//    CALayer* superLayer = self.superlayer;
//    while (superLayer && [superLayer isKindOfClass:[CPTLayer class]]) {
//        superLayer.masksToBounds = NO;
//        CGRect FFF = superLayer.frame;
////        superLayer.frame = CGRectMake(-300, 0, superLayer.frame.size.width+300, superLayer.frame.size.height);
////        superLayer.backgroundColor = [UIColor yellowColor].CGColor;
//        superLayer.borderWidth =1.0f;
//        if ([superLayer isKindOfClass:[CPTPlotGroup class]]) {
//            superLayer.borderColor = [UIColor greenColor].CGColor;
//        } else if ([superLayer isKindOfClass:[CPTPlotArea class]]) {
//            superLayer.borderColor = [UIColor blueColor].CGColor;
//        } else if ([superLayer isKindOfClass:[CPTPlotAreaFrame class]]) {
//            superLayer.borderColor = [UIColor orangeColor].CGColor;
//            superLayer.borderWidth = 2.0f;
//        } else {
//            
//        }
//        superLayer = superLayer.superlayer;
//    }
//    self.backgroundColor = [UIColor redColor].CGColor;
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
}

-(BOOL)barIsVisibleWithBasePoint:(CGPoint)basePoint
{
//    return YES;
    BOOL horizontalBars    = self.barsAreHorizontal;
    CGFloat barWidthLength = [self lengthInView:self.barWidth recal:NO] * self.barWidthScale;
    CGFloat halfBarWidth   = CPTFloat(0.5) * barWidthLength;
    CPTPlotArea *thePlotArea = self.plotArea;

    CGFloat lowerBound = ( horizontalBars ? CGRectGetMinY(thePlotArea.bounds) : CGRectGetMinX(thePlotArea.bounds) );
    CGFloat upperBound = ( horizontalBars ? CGRectGetMaxY(thePlotArea.bounds) : CGRectGetMaxX(thePlotArea.bounds) );
    CGFloat base       = (horizontalBars ? basePoint.y : basePoint.x);
    
    return (base + halfBarWidth >= lowerBound) && (base - halfBarWidth <= upperBound);
}
-(BOOL)barIsVisibleWithIndex:(NSUInteger)index
{
    CPTXYPlotSpace* p = (CPTXYPlotSpace*)self.plotSpace;
    CPTPlotRange* xRange = p.xRange;
    return [xRange contains:[NSDecimalNumber numberWithUnsignedInteger:index].decimalValue];
}
-(void)drawBarInContext:(CGContextRef)context recordIndex:(NSUInteger)idx
{
    // Get base and tip points
    CGPoint basePoint, tipPoint;
    BOOL barExists = [self barAtRecordIndex:idx basePoint:&basePoint tipPoint:&tipPoint];
    
    if ( !barExists ) {
        return;
    }
    
    // Return if bar is off screen
//    if ( ![self barIsVisibleWithBasePoint:basePoint] ) {
//        return;
//    }
    if (![self barIsVisibleWithIndex:idx]) return;
    
    
    CGMutablePathRef path = [self newBarPathWithContext:context basePoint:basePoint tipPoint:tipPoint];
    
    if ( path ) {
        CGContextSaveGState(context);
        
        CPTFill *theBarFill = [self barFillForIndex:idx];
        if ( [theBarFill isKindOfClass:[CPTFill class]] ) {
            CGContextBeginPath(context);
            CGContextAddPath(context, path);
            [theBarFill fillPathInContext:context];
        }
        
        CPTLineStyle *theLineStyle = [self barLineStyleForIndex:idx];
        if ( [theLineStyle isKindOfClass:[CPTLineStyle class]] ) {
            CGContextBeginPath(context);
            CGContextAddPath(context, path);
            [theLineStyle setLineStyleInContext:context];
            [theLineStyle strokePathInContext:context];
        }
        
        CGContextRestoreGState(context);
        
        CGPathRelease(path);
    }
}
-(CPTFill *)barFillForIndex:(NSUInteger)idx
{
    CPTFill *theBarFill = [self cachedValueForKey:CPTBarPlotBindingBarFills recordIndex:idx];
    
    if ( (theBarFill == nil) || (theBarFill == [CPTPlot nilData]) ) {
        theBarFill = self.fill;
    }
    
    return theBarFill;
}

-(CPTLineStyle *)barLineStyleForIndex:(NSUInteger)idx
{
    CPTLineStyle *theBarLineStyle = [self cachedValueForKey:CPTBarPlotBindingBarLineStyles recordIndex:idx];
    
    if ( (theBarLineStyle == nil) || (theBarLineStyle == [CPTPlot nilData]) ) {
        theBarLineStyle = self.lineStyle;
    }
    
    return theBarLineStyle;
}

-(CGRect)getRectOfBasePoint:(CGPoint)basePoint tipPoint:(CGPoint)tipPoint {
    BOOL horizontalBars = self.barsAreHorizontal;
    
    CGFloat barWidthLength = [self lengthInView:self.barWidth recal:NO] * self.barWidthScale;
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
    
    
    if ( widthNegative && (barRect.size.width > 0.0) ) {
        barRect.origin.x  += barRect.size.width;
        barRect.size.width = -barRect.size.width;
    }
    if ( heightNegative && (barRect.size.height > 0.0) ) {
        barRect.origin.y   += barRect.size.height;
        barRect.size.height = -barRect.size.height;
    }
    return barRect;
}

-(CGMutablePathRef)newBarPathWithContext:(CGContextRef)context basePoint:(CGPoint)basePoint tipPoint:(CGPoint)tipPoint
{
//    if (pathDic == nil) pathDic = [[NSMutableDictionary alloc]init];
//    if (pathDic[@(tipPoint.x)] != nil) return [[pathDic objectForKey:@(tipPoint.x)] pointerValue];
    
    // This function is used to create a path which is used for both
    // drawing a bar and for doing hit-testing on a click/touch event
    BOOL horizontalBars = self.barsAreHorizontal;
    
    CGFloat barWidthLength = [self lengthInView:self.barWidth recal:NO] * self.barWidthScale;
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
    
    return path;
}

@end
