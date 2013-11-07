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
@end

@implementation REMPieChartView

-(REMPieChartView*)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
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
            NSUInteger numberOfSlice = [s numberOfRecordsForPlot:plot];
            double sumY = 0;
            NSMutableArray* yArray = [[NSMutableArray alloc]initWithCapacity:numberOfSlice];
            for (NSUInteger i = 0; i < numberOfSlice; i++) {
                NSNumber* yVal = [s numberForPlot:plot field:CPTPieChartFieldSliceWidth recordIndex:i];
                [yArray addObject:yVal];
                sumY += yVal.doubleValue;
            }
            self.pointAngles = [[NSMutableArray alloc]initWithCapacity:numberOfSlice+1];
            [self.pointAngles addObject:@(M_PI*2)];
            double yCursor = 0;
            for (int i = 0; i < numberOfSlice; i++) {
                NSNumber* yVal = yArray[i];
                yCursor+=yVal.doubleValue;
                [self.pointAngles addObject:@(M_PI*2-yCursor/sumY*2*M_PI)];
            }
            [s beforePlotAddToGraph:self.hostedGraph seriesList:self.series selfIndex:0];
            [self.hostedGraph addPlot:[s getPlot]];
        }
    }
    [self alignSlice];
    return self;
}

-(void)didMoveToSuperview {
    UIView* fff = [[UIView alloc]initWithFrame:CGRectMake(self.center.x, 0, 1, 748)];
    fff.backgroundColor= [UIColor whiteColor];
    [self.superview addSubview:fff];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isFocusStatus) {
        [super touchesMoved:touches withEvent:event];
        UITouch* theTouch = [touches anyObject];
        CGPoint previousPoint = [theTouch previousLocationInView:self];
        CGPoint thePoint = [theTouch locationInView:self];
        double rotation =(atan((previousPoint.x-self.center.x)/(previousPoint.y-self.center.y))-atan((thePoint.x-self.center.x)/(thePoint.y-self.center.y)));

        self.rotationAngle += rotation;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isFocusStatus) {
        [self alignSlice];
    }
}

-(void)alignSlice {
    if (self.pointAngles.count == 0) return;
    if (self.pointAngles.count == 1) {
        return;
    }
    NSNumber* pieSlice = self.pointAngles[self.focusPointIndex+1];
    NSNumber* preSlice = self.pointAngles[self.focusPointIndex];
    double targetRotation = (preSlice.doubleValue+pieSlice.doubleValue)/2;
    [UIView animateWithDuration:0.2 animations:^(void){
        self.rotationAngle = targetRotation;
    }];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoint:color:name:)]) {
        [self.delegate highlightPoint:series.energyData[focusPointIndex] color:[series getColorByIndex:focusPointIndex].uiColor name:series.targetNames[focusPointIndex]];
    }
    NSLog(@"%i %@", self.focusPointIndex, series.targetNames[focusPointIndex]);
}

-(void)cancelToolTipStatus {
    self.isFocusStatus = NO;
}

@end
