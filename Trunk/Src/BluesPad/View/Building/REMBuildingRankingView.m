/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingRankingView.m
 * Created      : tantan on 8/6/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingRankingView.h"

@interface REMBuildingRankingView()

@property (nonatomic,strong) UILabel *totalLabel;

@end

@implementation REMBuildingRankingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        
    }
    
    return self;
}

- (void)setData:(REMRankingDataModel *)data{
    [self initTextLabel:data withSize:self.titleFontSize  withTitleMargin:self.titleMargin withLeftMargin:self.leftMargin];
}

- (void)initTextLabel:(REMRankingDataModel *)data withSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin
{
    if(data==nil ||[data isEqual:[NSNull null]]==YES ){
        [self initEmptyTextLabelWithTitleSize:titleSize withTitleMargin:self.emptyTextMargin withLeftMargin:leftMargin withOrigFontSize:kBuildingCommodityDetailValueFontSize];
        return;
    }
    else{
        if(data.numerator<0){
            [self initEmptyTextLabelWithTitleSize:titleSize withTitleMargin:self.emptyTextMargin withLeftMargin:leftMargin withOrigFontSize:kBuildingCommodityDetailValueFontSize];
            return;
        }
    }
    
    int marginTop=titleSize+margin;
    REMNumberLabel *rankingLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(leftMargin, marginTop, 1024, kBuildingCommodityDetailValueFontSize)];
    rankingLabel.fontSize=@(kBuildingCommodityDetailValueFontSize);
    rankingLabel.textColor=[UIColor whiteColor];
    rankingLabel.backgroundColor=[UIColor clearColor];
    rankingLabel.shadowOffset=CGSizeMake(1, 1);
    rankingLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    rankingLabel.text=[NSString stringWithFormat:@"%d", data.numerator];
    [self addSubview:rankingLabel];
    self.textLabel=rankingLabel;
    //NSLog(@"font:%@",[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:valueSize]);
    
    CGSize expectedLabelSize = [rankingLabel.text sizeWithFont:[UIFont fontWithName:@(kBuildingFontLight) size:kBuildingCommodityDetailValueFontSize]];
    
    //NSLog(@"valuesize:%f",valueSize);
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(expectedLabelSize.width+leftMargin, marginTop+expectedLabelSize.height-kBuildingCommodityDetailValueFontSize, 200, kBuildingCommodityDetailValueFontSize)];
    //self.totalLabel.fontSize=@(kBuildingCommodityDetailUomFontSize);
    self.totalLabel.font=[UIFont fontWithName:@(kBuildingFontLight) size:kBuildingCommodityDetailUomFontSize];
    //self.totalLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:kBuildingCommodityTotalUomFontSize];
    self.totalLabel.backgroundColor=[UIColor clearColor];
    //self.uomLabel.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    self.totalLabel.textColor=[UIColor whiteColor];
    self.totalLabel.userInteractionEnabled = NO;
    self.totalLabel.text=[NSString stringWithFormat:@"/%d", data.denominator];
    self.totalLabel.shadowOffset=CGSizeMake(1, 1);
    self.totalLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
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
