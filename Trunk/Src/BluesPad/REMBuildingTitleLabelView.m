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
@property (nonatomic,strong) UILabel *emptyLabel;

@end

@implementation REMBuildingTitleLabelView

- (id)initWithFrame:(CGRect)frame
           withData:(REMEnergyUsageDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin
            withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        [self initTitle:title withSize:size withLeftMargin:leftMargin];
        [self initTextLabel:data withTitleSize:size withTitleMargin:margin withLeftMargin:leftMargin withValueFontSize:valueSize withUomFontSize:uomSize];
    }
    
    return self;
}

- (void)setEmptyText:(NSString *)emptyText withSize:(CGFloat)size
{
    if(self.emptyLabel!=nil){
        self.emptyLabel.text=emptyText;
        self.emptyLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:size];
    }
}

- (void)initEmptyTextLabelWithTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin{
    int marginTop=titleSize+margin ;
    int fontsize=24;
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, marginTop, 1000, fontsize)];
    self.emptyLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:fontsize];
    self.emptyLabel.textColor=[UIColor lightGrayColor];
    self.emptyLabel.text=@"无数据";
    self.emptyLabel.backgroundColor=[UIColor clearColor];
    self.emptyLabel.shadowOffset=CGSizeMake(1, 1);
    self.emptyLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
   
    [self addSubview:self.emptyLabel];
}

- (void)initTextLabel:(REMEnergyUsageDataModel *)data withTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin withValueFontSize:(CGFloat)valueSize withUomFontSize:(CGFloat) uomSize
{
    
    if(data==nil || data.dataValue==nil||[data.dataValue isEqual:[NSNull null]]==YES){
        [self initEmptyTextLabelWithTitleSize:titleSize withTitleMargin:margin withLeftMargin:leftMargin];
        return;
    }
    
    
    int marginTop=titleSize+margin ;
    self.textLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(leftMargin, marginTop, 1000, valueSize)];
    self.textLabel.fontSize=@(valueSize);
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.textLabel.shadowOffset=CGSizeMake(1, 1);
    self.textLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.textLabel.text=[self addThousandSeparator:data.dataValue];
    [self addSubview:self.textLabel];

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
        
        
        
        UIFont *smallFont = [UIFont systemFontOfSize:size];
        
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
