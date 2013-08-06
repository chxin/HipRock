//
//  REMBuildingRankingView.m
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingRankingView.h"

@interface REMBuildingRankingView()

@property (nonatomic,strong) REMNumberLabel *rankingLabel;
@property (nonatomic,strong) REMNumberLabel *totalLabel;

@end

@implementation REMBuildingRankingView

- (id)initWithFrame:(CGRect)frame withData:(REMRankingDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        [self initTitle:title withSize:size];
        [self initTextLabel:data withSize:size];
    }
    
    return self;
}

- (void)initTextLabel:(REMRankingDataModel *)data withSize:(CGFloat)titleSize
{
    self.rankingLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(0, titleSize, 1024, kBuildingCommodityDetailValueFontSize)];
    self.rankingLabel.fontSize=@(kBuildingCommodityDetailValueFontSize);
    self.rankingLabel.textColor=[UIColor whiteColor];
    self.rankingLabel.backgroundColor=[UIColor clearColor];
    
    self.rankingLabel.text=[NSString stringWithFormat:@"%d", data.numerator];
    [self addSubview:self.rankingLabel];
    
    //NSLog(@"font:%@",[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:valueSize]);
    
    CGSize expectedLabelSize = [self.rankingLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:kBuildingCommodityDetailValueFontSize]];
    
    //NSLog(@"valuesize:%f",valueSize);
    self.totalLabel = [[REMNumberLabel alloc]initWithFrame:CGRectMake(expectedLabelSize.width, titleSize+expectedLabelSize.height-kBuildingCommodityDetailValueFontSize, 100, kBuildingCommodityDetailValueFontSize)];
    self.totalLabel.font=[UIFont fontWithName:@(kBuildingFont) size:kBuildingCommodityTotalUomFontSize];
    self.totalLabel.backgroundColor=[UIColor clearColor];
    //self.uomLabel.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    self.totalLabel.textColor=[UIColor whiteColor];
    self.totalLabel.userInteractionEnabled = NO;
    self.totalLabel.text=[NSString stringWithFormat:@"/%d", data.denominator];
    [self addSubview:self.totalLabel];
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
