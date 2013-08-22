//
//  REMBuildingTitleLabelView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleLabelView.h"

@interface REMBuildingTitleLabelView()

@property (nonatomic,weak) REMEnergyUsageDataModel *data;
@property (nonatomic,strong) REMNumberLabel *textLabel;
@property (nonatomic,strong) UILabel *uomLabel;

@end

@implementation REMBuildingTitleLabelView

- (id)initWithFrame:(CGRect)frame
           withData:(REMEnergyUsageDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size
            withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        [self initTitle:title withSize:size];
        [self initTextLabel:data withTitleSize:size withValueFontSize:valueSize withUomFontSize:uomSize];
    }
    
    return self;
}



- (void)initTextLabel:(REMEnergyUsageDataModel *)data withTitleSize:(CGFloat)titleSize withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize
{
    self.textLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(0, titleSize, 1024, valueSize)];
    self.textLabel.fontSize=@(valueSize);
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.backgroundColor=[UIColor clearColor];
    
    self.textLabel.text=[NSString stringWithFormat:@"%@", data.dataValue];
    [self addSubview:self.textLabel];

    //NSLog(@"font:%@",[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:valueSize]);
    
    CGSize expectedLabelSize = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@(kBuildingFont) size:valueSize]];
    
    //NSLog(@"valuesize:%f",valueSize);
    self.uomLabel = [[UILabel alloc]initWithFrame:CGRectMake(expectedLabelSize.width+5, titleSize+expectedLabelSize.height-valueSize, 200, valueSize)];
    self.uomLabel.font=[UIFont fontWithName:@(kBuildingFontLight) size:uomSize];
    self.uomLabel.backgroundColor=[UIColor clearColor];
    //self.uomLabel.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    self.uomLabel.textColor=[UIColor whiteColor];
    self.uomLabel.userInteractionEnabled =NO;
    self.uomLabel.text=data.uom.code;
    [self addSubview:self.uomLabel];
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
