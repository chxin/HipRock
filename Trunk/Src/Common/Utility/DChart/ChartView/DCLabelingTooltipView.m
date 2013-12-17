//
//  DCLabelingTooltipView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/17/13.
//
//

#import "DCLabelingTooltipView.h"
@interface DCLabelingTooltipView()
@property (nonatomic, strong) CAShapeLayer* triangleLayer;
@property (nonatomic, strong) CAShapeLayer* dotLayer;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UILabel* stageLabel;
@property (nonatomic, strong) UILabel* labelTextLabel;

@property (nonatomic, assign) CGFloat triangleSize;
@property (nonatomic, assign) CGFloat iconSize;

@property (nonatomic, assign) CGFloat width;
@end



@implementation DCLabelingTooltipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 2;
        self.cornerRadius = 10;
        // Initialization code
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.triangleLayer = [[CAShapeLayer alloc]init];
        self.triangleLayer.fillColor = [UIColor whiteColor].CGColor;
        self.triangleLayer.contentsScale = [UIScreen mainScreen].scale;
        self.triangleLayer.lineWidth = self.borderWidth;
        [self.layer addSublayer:self.triangleLayer];
        
        self.dotLayer = [[CAShapeLayer alloc]init];
        [self.layer addSublayer:self.dotLayer];
        
        self.stageLabel = [[UILabel alloc]init];
        self.stageLabel.textColor = [UIColor whiteColor];
        self.stageLabel.backgroundColor = [UIColor clearColor];
        self.stageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.stageLabel];
        self.labelTextLabel = [[UILabel alloc]init];
        self.labelTextLabel.backgroundColor = [UIColor clearColor];
        self.labelTextLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.labelTextLabel];
    }
    return self;
}

-(void)setStageText:(NSString *)stageText {
    _stageText = stageText;
    self.stageLabel.text = stageText;
}

-(void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    self.labelTextLabel.text = labelText;
    [self resize];
}

-(void)resize {
    CGFloat selfHeight = self.height;
    self.triangleSize = selfHeight * 0.3;
    self.iconSize = selfHeight * 0.25;
    self.stageLabel.frame = CGRectMake(self.triangleSize + selfHeight/2-self.iconSize, 0, self.iconSize*2, selfHeight);
    
    
    [self.labelTextLabel sizeToFit];
    self.labelTextLabel.frame = CGRectMake(self.triangleSize + self.height, (self.height - self.labelTextLabel.frame.size.height) / 2,
                                           self.labelTextLabel.frame.size.width, self.labelTextLabel.frame.size.height);
    CGRect fff = self.labelTextLabel.frame;
    self.width = self.triangleSize + self.iconSize * 5 + self.labelTextLabel.frame.size.width;
}

-(CGFloat)getWidth {
    return self.width;
}

-(void)setColor:(UIColor *)color {
    _color = color;
    
    self.triangleLayer.strokeColor = color.CGColor;
    CGFloat selfHeight = self.height;
    CGFloat selfWidth = self.width;
    CGFloat triangleSize = self.triangleSize;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = self.borderWidth;
    
    [aPath moveToPoint:CGPointMake(triangleSize, selfHeight*0.5 - triangleSize*0.5)];
    [aPath addLineToPoint:CGPointMake(self.borderWidth, selfHeight*0.5)];
    [aPath addLineToPoint:CGPointMake(triangleSize, selfHeight*0.5 + triangleSize*0.5)];
    [aPath addLineToPoint:CGPointMake(triangleSize, selfHeight-self.cornerRadius)];
    [aPath addQuadCurveToPoint:CGPointMake(triangleSize+self.cornerRadius,selfHeight-self.borderWidth/2) controlPoint:CGPointMake(triangleSize, selfHeight-self.borderWidth/2)];
    [aPath addLineToPoint:CGPointMake(selfWidth-self.borderWidth/2-self.cornerRadius,selfHeight-self.borderWidth/2)];
    [aPath addQuadCurveToPoint:CGPointMake(selfWidth,selfHeight-self.cornerRadius) controlPoint:CGPointMake(selfWidth, selfHeight)];
    [aPath addLineToPoint:CGPointMake(selfWidth,self.cornerRadius)];
    [aPath addQuadCurveToPoint:CGPointMake(selfWidth-self.cornerRadius,self.borderWidth/2) controlPoint:CGPointMake(selfWidth, 0)];
    [aPath addLineToPoint:CGPointMake(self.cornerRadius+triangleSize,self.borderWidth/2)];
    [aPath addQuadCurveToPoint:CGPointMake(triangleSize,self.borderWidth/2+self.cornerRadius) controlPoint:CGPointMake(triangleSize, 0)];
    [aPath closePath];
    self.triangleLayer.path = aPath.CGPath;
    
    CGFloat radius = self.iconSize;
    UIBezierPath* round = [UIBezierPath bezierPathWithArcCenter:CGPointMake(triangleSize + selfHeight/2, selfHeight/2) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    self.dotLayer.fillColor = color.CGColor;
    self.dotLayer.path = round.CGPath;
    
    self.labelTextLabel.textColor = color;
}

@end
