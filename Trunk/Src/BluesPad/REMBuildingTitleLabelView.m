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
           withData:(REMEnergyUsageDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size withTitleMargin:(CGFloat)margin
            withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        [self initTitle:title withSize:size];
        [self initTextLabel:data withTitleSize:size withTitleMargin:margin withValueFontSize:valueSize withUomFontSize:uomSize];
    }
    
    return self;
}



- (void)initTextLabel:(REMEnergyUsageDataModel *)data withTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize
{
    int marginTop=titleSize+margin ;
    self.textLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(0, marginTop, 1024, valueSize)];
    self.textLabel.fontSize=@(valueSize);
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.backgroundColor=[UIColor clearColor];
    
    self.textLabel.text=[self addThousandSeparator:data.dataValue];
    [self addSubview:self.textLabel];

    //NSLog(@"font:%@",[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:valueSize]);
    
    CGSize expectedLabelSize = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@(kBuildingFontLight) size:valueSize]];
    
    //NSLog(@"valuesize:%f",valueSize);
    self.uomLabel = [[UILabel alloc]initWithFrame:CGRectMake(expectedLabelSize.width+5, marginTop+expectedLabelSize.height-valueSize, 200, valueSize)];
    self.uomLabel.font=[UIFont fontWithName:@(kBuildingFontLight) size:uomSize];
    self.uomLabel.backgroundColor=[UIColor clearColor];
    //self.uomLabel.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    self.uomLabel.textColor=[UIColor whiteColor];
    self.uomLabel.userInteractionEnabled =NO;
    self.uomLabel.text=data.uom.code;
    
    [self plainStringToAttributedUnits];
    [self addSubview:self.uomLabel];
}

- (void)plainStringToAttributedUnits
{
    NSString *string = self.uomLabel.text;
    unichar c= [string characterAtIndex:string.length-1];
    
    if(c>=48 && c<=59){

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        
        [attString beginEditing];
        [attString addAttribute:NSFontAttributeName value:(smallFont) range:NSMakeRange(string.length - 1, 1)];
        [attString addAttribute:(NSString*)kCTSuperscriptAttributeName value:@"1" range:NSMakeRange(string.length - 1, 1)];

        [attString endEditing];
        self.uomLabel.attributedText=attString;
    }
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
