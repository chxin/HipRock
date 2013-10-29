//
//  REMChartHorizonalScrollManager.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/3/13.
//
//

#import "REMChartHorizonalScrollDelegator.h"

@interface REMChartHorizonalScrollDelegator()

@property (nonatomic) CGPoint lastPoint;

@property (nonatomic) NSTimeInterval lastTime;

@property (nonatomic) NSTimeInterval deltaTime;

@end

@implementation REMChartHorizonalScrollDelegator



- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    self.lastPoint=point;
    self.lastTime=event.timestamp;
    
    if (self.snapshotArray!=nil) {
        for (UIView *view in self.snapshotArray) {
            [view removeFromSuperview];
        }
        self.snapshotArray=nil;
    }
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    //NSLog(@"dragged");
    
    //self.isDragging=YES;
    CGFloat deltaX=point.x-self.lastPoint.x;
    NSTimeInterval diffTime= event.timestamp-self.lastTime;
    NSLog(@"diff time:%f",diffTime);
    NSLog(@"delta x:%f",deltaX);
    self.deltaTime=diffTime;
    self.lastTime=event.timestamp;
    //if(diffTime<0.1&&deltaX<50)return NO;
    //self.lastPoint=point;
    return YES;
}



- (BOOL)plotSpace:(CPTXYPlotSpace *)space shouldHandlePointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    
    CGFloat deltaX=point.x-self.lastPoint.x;
    
     NSTimeInterval diffTime= event.timestamp-self.lastTime;
    
    NSLog(@"up diff time:%f",diffTime);
    NSLog(@"up delta x:%f",deltaX);
    if(self.deltaTime!=0 && diffTime==0){
    //if(ABS(deltaX)>8){
       
        //NSLog(@"diff time:%f",diffTime);
        //NSLog(@"delta x:%f",deltaX);
        NSLog(@"enter ");
        diffTime=self.deltaTime;
        diffTime=MAX(0.05, diffTime);
        CGFloat speed = deltaX/diffTime;
        CGFloat constTime=0.2;
        CGFloat accelerate=speed/constTime;
        CGFloat distance = speed*constTime-0.5*accelerate*constTime*constTime;
        NSDecimal lastPoint[2], newPoint[2];
        CPTPlotArea *plotArea = self.hostView.hostedGraph.plotAreaFrame.plotArea;
        CGPoint pointInPlotArea = [self.hostView.hostedGraph convertPoint:point toLayer:plotArea];
        [space plotPoint:lastPoint forPlotAreaViewPoint:pointInPlotArea];
        [space plotPoint:newPoint forPlotAreaViewPoint:CGPointMake(pointInPlotArea.x + distance,pointInPlotArea.y)];
        
        NSDecimal shiftX = CPTDecimalSubtract(lastPoint[CPTCoordinateX], newPoint[CPTCoordinateX]);
        
        //NSLog(@"shiftx:%f",CPTDecimalFloatValue(shiftX));
        CPTMutablePlotRange *newRange= [space.xRange mutableCopy];
        
        newRange.location = CPTDecimalAdd(newRange.location, shiftX);
        
        
        //left bound
        NSDecimal currentLeftLocation = newRange.location;
        NSDecimal currentRightLocation = CPTDecimalAdd(newRange.location,newRange.length);
        
        NSDecimal minLeftLocation = CPTDecimalFromDouble(self.globalRange.start);
        NSDecimal maxRightLocation = CPTDecimalFromDouble(self.globalRange.end);
        
        BOOL isCurrentLeftLessThanMinLeft = CPTDecimalLessThan(currentLeftLocation,minLeftLocation);
        BOOL isCurrentRightGreaterThanMaxRight = CPTDecimalGreaterThan(currentRightLocation, maxRightLocation);
        
        //if current left location is smaller than global range start, go back with animation
        //if current right location is greater than global range end, go back with animation too
        CPTPlotRange  *correctRange;
        if(isCurrentLeftLessThanMinLeft == YES ){
            correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
        }
        else if(isCurrentRightGreaterThanMaxRight == YES){
            correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
            
        }
        if(correctRange!=nil){
            constTime= ABS(CPTDecimalFloatValue(CPTDecimalSubtract(newRange.location, space.xRange.location))/speed);
            
            
        }
        
        /*
        [CPTAnimation animate:space
                     property:@"xRange"
                fromPlotRange:space.xRange
                  toPlotRange:newRange
                     duration:constTime
               animationCurve:CPTAnimationCurveSinusoidalOut
                     delegate:nil];
        */
        if(correctRange!=nil){
            //newRange = [correctRange mutableCopy];
            [CPTAnimation animate:space property:@"xRange" fromPlotRange:newRange toPlotRange:correctRange duration:0.3 withDelay:constTime animationCurve:CPTAnimationCurveSinusoidalOut delegate:nil];
            
        }
        
        return  NO;
        
    }
    else{
        //left bound
        NSDecimal currentLeftLocation = space.xRange.location;
        NSDecimal currentRightLocation = CPTDecimalAdd(space.xRange.location,space.xRange.length);
        
        NSDecimal minLeftLocation = CPTDecimalFromDouble(self.globalRange.start);
        NSDecimal maxRightLocation = CPTDecimalFromDouble(self.globalRange.end);
        
        BOOL isCurrentLeftLessThanMinLeft = CPTDecimalLessThan(currentLeftLocation,minLeftLocation);
        BOOL isCurrentRightGreaterThanMaxRight = CPTDecimalGreaterThan(currentRightLocation, maxRightLocation);
        
        //if current left location is smaller than global range start, go back with animation
        //if current right location is greater than global range end, go back with animation too
        if(isCurrentLeftLessThanMinLeft == YES || isCurrentRightGreaterThanMaxRight == YES){
            CPTPlotRange *correctRange;
            if(isCurrentLeftLessThanMinLeft == YES ){
                correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
            }
            else if(isCurrentRightGreaterThanMaxRight == YES){
                correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
                
            }
            
            [CPTAnimation animate:space property:@"xRange" fromPlotRange:space.xRange toPlotRange:correctRange duration:0.3 withDelay:0 animationCurve:CPTAnimationCurveSinusoidalOut delegate:nil];
            
            return NO;
        }
    }
    
    return  YES;
}


@end
