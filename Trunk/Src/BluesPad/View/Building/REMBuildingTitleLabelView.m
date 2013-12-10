//
//  REMBuildingTitleLabelView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleLabelView.h"
#import "REMNumberHelper.h" 


@interface REMBuildingTitleLabelView()

@property (nonatomic,strong) UILabel *uomLabel;


@end

@implementation REMBuildingTitleLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
    }
    
    return self;

}


- (void)setData:(REMEnergyUsageDataModel *)data{
    
    [self initTextLabel:data withTitleSize:self.titleFontSize withTitleMargin:self.titleMargin withLeftMargin:self.leftMargin withValueFontSize:self.valueFontSize withUomFontSize:self.uomFontSize];
}



- (void)initTextLabel:(REMEnergyUsageDataModel *)data withTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize
{
    
    if(data==nil || data.dataValue==nil||[data.dataValue isEqual:[NSNull null]]==YES){
        [self initEmptyTextLabelWithTitleSize:titleSize withTitleMargin:self.emptyTextMargin withLeftMargin:leftMargin withOrigFontSize:valueSize];
        return;
    }
    else{
        if([data.dataValue isLessThan:@(0)] ==YES){
            [self initEmptyTextLabelWithTitleSize:titleSize withTitleMargin:self.emptyTextMargin withLeftMargin:leftMargin withOrigFontSize:valueSize];
            return;
        }
    }
    
    
    int marginTop=titleSize+margin ;
    REMNumberLabel *textLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(leftMargin, marginTop, self.textWidth, valueSize)];
    textLabel.clipsToBounds=YES;
    textLabel.fontSize=@(valueSize);
    textLabel.textColor=[UIColor whiteColor];
    textLabel.backgroundColor=[UIColor clearColor];
    textLabel.shadowOffset=CGSizeMake(1, 1);
    textLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    textLabel.text=[REMNumberHelper formatStringWithThousandSep:data.dataValue withRoundDigit:0 withIsRound:YES];
    [self addSubview:textLabel];
    self.textLabel=textLabel;
    //NSLog(@"font:%@",[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:valueSize]);
    
    CGSize expectedLabelSize = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@(kBuildingFontLight) size:valueSize]];
    
    //NSLog(@"valuesize:%f",valueSize);
    self.uomLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+expectedLabelSize.width, marginTop+expectedLabelSize.height-valueSize, 200, valueSize)];
    self.uomLabel.font=[UIFont fontWithName:@(kBuildingFontLight) size:uomSize];
    self.uomLabel.backgroundColor=[UIColor clearColor];
    //self.uomLabel.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    self.uomLabel.textColor=[UIColor whiteColor];
    self.uomLabel.shadowOffset=CGSizeMake(1, 1);
    self.uomLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

    self.uomLabel.userInteractionEnabled =NO;
    self.uomLabel.text=data.uom.code;
    
    [self plainStringToAttributedUnits:(uomSize-8)];
    [self addSubview:self.uomLabel];
}

- (void)plainStringToAttributedUnits:(CGFloat)size
{
    NSString *string = self.uomLabel.text;
    unichar c= [string characterAtIndex:string.length-1];
    
    if(c>=48 && c<=59){

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSString *scriptType;
        if([string rangeOfString:@"CO2"].location==NSNotFound){
            scriptType=@"1";
        }
        else{
            scriptType=@"-1";
        }
        
        UIFont *smallFont = [UIFont systemFontOfSize:size];
        
        [attString beginEditing];
        [attString addAttribute:NSFontAttributeName value:(smallFont) range:NSMakeRange(string.length - 1, 1)];
        [attString addAttribute:(NSString*)kCTSuperscriptAttributeName value:scriptType range:NSMakeRange(string.length - 1, 1)];

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
