//
//  REMTrend.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/4/13.
//
//

#import "REMTrend.h"
#import <QuartzCore/QuartzCore.h>
@interface REMTrend ()
@property (nonatomic) NSMutableArray* yAxisLabelsArray;
@property (nonatomic) NSMutableArray* xAxisLabelArray;
@property (nonatomic) CALayer* hGridlines;
@property (nonatomic) NSMutableArray* series;
@property (nonatomic, assign) NSUInteger xLength;
@property (nonatomic, assign) NSUInteger xLocation;
@property (nonatomic) CALayer* plotLayer;
@end

@implementation REMTrend

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xLength = 30;
        self.xLocation = 0;
        self.yAxisLabelsArray = [[NSMutableArray alloc]init];
        self.xAxisLabelArray = [[NSMutableArray alloc]init];
        self.hGridlines = [[CALayer alloc]init];
        
        CATextLayer* t = [[CATextLayer alloc]init];
        [t setString:@"fsadfa"];
        [t setFontSize:20];
        t.frame = CGRectMake(0, 0, 100, 30);
        self.backgroundColor = [UIColor blackColor];
        [t setAlignmentMode:kCAAlignmentRight];
        [t setForegroundColor:[UIColor redColor].CGColor];
        [self.layer addSublayer:t];
        
        self.series = [[NSMutableArray alloc]init];
        NSMutableArray* series0 = [[NSMutableArray alloc]init];
        [self.series addObject:series0];
        
        for (NSUInteger i = 0; i < self.xLength; i++) {
            CALayer* bar = [[CALayer alloc]init];
            bar.backgroundColor = [UIColor whiteColor].CGColor;
            CGFloat height = i*20+20;
            bar.frame = CGRectMake(i*30, self.frame.size.height-height, 20, height);
            [series0 addObject:bar];
            [self.layer addSublayer:bar];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCH BEGAN");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* theTouch = [touches anyObject];
    CGPoint previousPoint = [theTouch previousLocationInView:self];
    CGPoint thePoint = [theTouch locationInView:self];
    
    CGFloat xMovement = thePoint.x - previousPoint.x;
    
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES] ;
    for (NSMutableArray* seriesImages in self.series) {
        NSUInteger barCount = seriesImages.count;
        for (NSUInteger i = 0; i < barCount; i++) {
            CALayer* bar = seriesImages[i];
            CGFloat x = bar.frame.origin.x + xMovement;
            if (x<0) {
                [bar setPosition:CGPointMake(bar.position.x+xMovement+900, bar.position.y)];
            } else if (bar.position.x+xMovement+bar.bounds.size.width>900) {
                [bar setPosition:CGPointMake(bar.position.x+xMovement-900, bar.position.y)];
            } else {
                [bar setPosition:CGPointMake(bar.position.x+xMovement, bar.position.y)];
            }
            //[bar setPosition:CGPointMake(bar.position.x+xMovement, bar.position.y)];
        }
    }
    [CATransaction setDisableActions:caTransationState];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCH ENDED");
    
}


-(void)removeFromSuperview {
    for (NSMutableArray* seriesImages in self.series) {
        for (CALayer* bar in seriesImages) {
            [bar removeFromSuperlayer];
            [bar removeAllAnimations];
        }
        [seriesImages removeAllObjects];
    }
    [self.series removeAllObjects];
    self.series = nil;
    
    
    [super removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
