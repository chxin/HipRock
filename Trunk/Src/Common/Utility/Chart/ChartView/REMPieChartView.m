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
@property (nonatomic) double rotationAngle;
@property (nonatomic) double tochBegan;
@end

@implementation REMPieChartView

-(REMPieChartView*)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        _series = config.series;
        self.rotationAngle = 0;
        
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
            [self.pointAngles addObject:@(0)];
            double yCursor = 0;
            for (int i = 0; i < numberOfSlice; i++) {
                NSNumber* yVal = yArray[i];
                yCursor+=yVal.doubleValue;
                [self.pointAngles addObject:@(yCursor/sumY*2*M_PI)];
            }
            [s beforePlotAddToGraph:self.hostedGraph seriesList:self.series selfIndex:0];
            [self.hostedGraph addPlot:[s getPlot]];
            NSLog(@"%@", self.pointAngles);
        }
    }
    //[self alignSlice];
    return self;
}

-(void)didMoveToSuperview {
    
    UIView* fff = [[UIView alloc]initWithFrame:CGRectMake(self.center.x, 0, 1, 748)];
    fff.backgroundColor= [UIColor whiteColor];
    [self.superview addSubview:fff];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* theTouch = [touches anyObject];
    CGPoint previousPoint = [theTouch previousLocationInView:self];
    CGPoint thePoint = [theTouch locationInView:self];
    double rotation =(atan((previousPoint.x-self.center.x)/(previousPoint.y-self.center.y))-atan((thePoint.x-self.center.x)/(thePoint.y-self.center.y)));
    CGAffineTransform transform = self.transform;
    transform = CGAffineTransformRotate(transform, rotation);
    self.transform = transform;
    self.rotationAngle += rotation;
//    NSLog(@"%f %f", self.rotationAngle, rotation);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.tochBegan = self.rotationAngle;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%f %f", self.tochBegan, self.rotationAngle);
    [self alignSlice];
}

-(void)alignSlice {
    int i = 1;
    if (self.rotationAngle == 0) i = 1;
    else {
    for (; i < self.pointAngles.count; i++) {
        NSNumber* pieSlice = self.pointAngles[i];
        if (M_PI*2-self.rotationAngle < pieSlice.doubleValue) {
            NSLog(@"align to Point:%i %f", i, self.rotationAngle);
            break;
        }
    }}
    
    self.rotationAngle = ([self.pointAngles[i-1] doubleValue]-[self.pointAngles[i] doubleValue])/2;
    
    double rotateTo =([self.pointAngles[i-1] doubleValue]-[self.pointAngles[i] doubleValue])/2;
    CGAffineTransform transform = self.transform;
    transform = CGAffineTransformRotate(transform,rotateTo);
    self.transform = transform;
//    self.rotationAngle += rotateTo;
    NSLog(@"align to %f %i %f", self.rotationAngle, i, rotateTo);
}

-(void)setRotationAngle:(double)rotationAngle {
    if (rotationAngle >= M_PI*2) {
        _rotationAngle= rotationAngle - M_PI*2;
    } else if (rotationAngle < 0) {
       _rotationAngle=M_PI*2 + rotationAngle;
    } else {
        _rotationAngle = rotationAngle;
    }
}

-(void)cancelToolTipStatus {
    
}

@end
