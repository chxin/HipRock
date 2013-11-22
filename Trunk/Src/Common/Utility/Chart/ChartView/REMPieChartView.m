/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartView.m
 * Created      : Zilong-Oscar.Xu on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"
@interface REMPieChartView()
@property (nonatomic) NSMutableArray* pointAngles;
@property (nonatomic, assign) double rotationAngle;
@property (nonatomic, assign) NSUInteger focusPointIndex;
@property (nonatomic, assign) BOOL isFocusStatus;
@property (nonatomic, assign) REMDirection rotateDirection;
@end

@implementation REMPieChartView

-(REMPieChartView*)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        self.rotateDirection = REMDirectionNone;
        _series = config.series;
        self.rotationAngle = 0;
        _focusPointIndex = 0;
        self.userInteractionEnabled = config.userInteraction;
        if (self.userInteractionEnabled) {
            UILongPressGestureRecognizer* longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [self addGestureRecognizer:longPressGR];
        }
        _isFocusStatus = NO;
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
        self.hostedGraph=graph;
        graph.axisSet = nil;
        graph.paddingBottom = 0;
        graph.paddingLeft = 0;
        graph.paddingRight = 0;
        graph.paddingTop = 0;
        
        if (self.series.count == 1) {
            REMPieChartSeries* s = [self.series objectAtIndex:0];
            CPTPieChart* plot = (CPTPieChart*)[s getPlot];
            [self reset];
            [s beforePlotAddToGraph:self.hostedGraph seriesList:self.series selfIndex:0];
            [self.hostedGraph addPlot:plot];
        }
    }
    [self alignSliceWithAnimation:NO];
    return self;
}

-(void)reset {
    REMPieChartSeries* s = [self.series objectAtIndex:0];
    CPTPieChart* plot = (CPTPieChart*)[s getPlot];
    NSUInteger numberOfSlice = [s numberOfRecordsForPlot:plot];
    double sumY = 0;
    NSMutableArray* yArray = [[NSMutableArray alloc]initWithCapacity:numberOfSlice];
    for (NSUInteger i = 0; i < numberOfSlice; i++) {
        NSNumber* yVal = [s numberForPlot:plot field:CPTPieChartFieldSliceWidth recordIndex:i];
        if (yVal==nil || [yVal isEqual:[NSNull null]]) {
            [yArray addObject:@(0)];
        } else {
            [yArray addObject:yVal];
            sumY +=  yVal.doubleValue;
        }
    }
    self.pointAngles = [[NSMutableArray alloc]initWithCapacity:numberOfSlice+1];
    [self.pointAngles addObject:@(M_PI*2)];
    double yCursor = 0;
    for (int i = 0; i < numberOfSlice; i++) {
        NSNumber* yVal = yArray[i];
        yCursor+=yVal.doubleValue;
        [self.pointAngles addObject:@(M_PI*2-yCursor/sumY*2*M_PI)];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isFocusStatus) {
        [super touchesMoved:touches withEvent:event];
        UITouch* theTouch = [touches anyObject];
        CGPoint previousPoint = [theTouch previousLocationInView:self];
        CGPoint thePoint = [theTouch locationInView:self];
        if (thePoint.x > previousPoint.x) self.rotateDirection = REMDirectionRight;
        else self.rotateDirection = REMDirectionLeft;
        double rotation =(atan((previousPoint.x-self.center.x)/(previousPoint.y-self.center.y))-atan((thePoint.x-self.center.x)/(thePoint.y-self.center.y)));

        self.rotationAngle += rotation;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isFocusStatus) {
        self.rotateDirection = REMDirectionNone;
        [self alignSliceWithAnimation:YES];
    }
}

-(void)alignSliceWithAnimation:(BOOL)withAnimation {
    if (self.pointAngles.count == 0) return;
    if (self.pointAngles.count == 1) {
        return;
    }
    NSNumber* pieSlice = nil;//self.pointAngles[self.focusPointIndex+1];
    NSNumber* preSlice = nil;//self.pointAngles[self.focusPointIndex];
    NSUInteger focusPointIndex = self.focusPointIndex;
    BOOL hasNextFocusPoint = NO;
    do {
        pieSlice = self.pointAngles[focusPointIndex];
        preSlice = self.pointAngles[focusPointIndex+1];
        if (![pieSlice isEqualToNumber:preSlice]) {
            hasNextFocusPoint = YES;
            self.focusPointIndex = focusPointIndex;
            break;
        }
        focusPointIndex++;
        if (focusPointIndex == self.pointAngles.count-1) focusPointIndex = 0;
    } while (focusPointIndex!=self.focusPointIndex);
    if (hasNextFocusPoint) {
        double targetRotation = (preSlice.doubleValue+pieSlice.doubleValue)/2;
        if (withAnimation) {
            [UIView animateWithDuration:0.2 animations:^(void){
                self.rotationAngle = targetRotation;
            }];
        } else {
            self.rotationAngle = targetRotation;
        }
    }
}

-(void)setRotationAngle:(double)rotationAngle {
    if (rotationAngle >= M_PI*2) {
        rotationAngle= rotationAngle - M_PI*2;
    } else if (rotationAngle < 0) {
        rotationAngle= M_PI*2 + rotationAngle;
    }
    CGAffineTransform transform = self.transform;
    transform = CGAffineTransformRotate(transform, rotationAngle-self.rotationAngle);
    self.transform = transform;
    _rotationAngle = rotationAngle;
    
    double selfRotaion = self.rotationAngle;
    if (selfRotaion == 0) selfRotaion = M_PI*2;
    for (int i = 1; i < self.pointAngles.count; i++) {
        NSNumber* pieSlice = self.pointAngles[i];
        if (selfRotaion > pieSlice.doubleValue) {
            self.focusPointIndex = i - 1;
            break;
        }
    }
}

-(void) longPress:(UILongPressGestureRecognizer*) gest {
    if (gest.state == UIGestureRecognizerStateBegan) {
        self.isFocusStatus = YES;
        [self sendPointFocusEvent];
    }
}
-(void)setFocusPointIndex:(NSUInteger)focusPointIndex {
    if (self.focusPointIndex != focusPointIndex) {
        _focusPointIndex = focusPointIndex;
        [self sendPointFocusEvent];
    }
}

-(void)sendPointFocusEvent {
    NSUInteger focusPointIndex = self.focusPointIndex;
    REMPieChartSeries* series = self.series[0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoint:color:name:direction:)]) {
        [self.delegate highlightPoint:series.energyData[focusPointIndex] color:[series getColorByIndex:focusPointIndex].uiColor name:series.targetNames[focusPointIndex] direction:self.rotateDirection];
    }
}

-(void)cancelToolTipStatus {
    self.isFocusStatus = NO;
}

-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    REMPieChartSeries* s = self.series[0];
    if (seriesIndex >= s.energyData.count) return;
    [s setHiddenAtIndex:seriesIndex hidden:hidden];
    [self reset];
    [self alignSliceWithAnimation:NO];
}
@end
