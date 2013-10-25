//
//  REMBuildingTitleView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleView.h"
#import "REMMaskManager.h"
@interface REMBuildingTitleView()

@property (nonatomic,strong) REMMaskManager *masker;
@end

@implementation REMBuildingTitleView

- (void)setEmptyText:(NSString *)emptyText withSize:(CGFloat)size
{
    if(self.emptyLabel!=nil){
        self.emptyLabel.text=emptyText;
        //self.emptyLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:size];
        
        //[self.emptyLabel setFont:[UIFont fontWithName:@(kBuildingFontSC) size:size]];
    }
}

- (void)showTitle
{
    [self initTitle:self.title withSize:self.titleFontSize withLeftMargin:self.leftMargin];
}

- (void)showLoading{
    if(self.masker==nil){
        self.masker =[[REMMaskManager alloc]initWithContainer:self];
        [self.masker.mask setBackgroundColor:[UIColor clearColor]];
        [self.masker.mask setFrame:CGRectMake(45, self.masker.mask.frame.origin.y+50, 50, 50)];
        
    }
    [self.masker showMask];
}

- (void)hideLoading{
    [self.masker hideMask];
}

- (void)initEmptyTextLabelWithTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin withOrigFontSize:(CGFloat)fontSize{
    int marginTop=titleSize+margin+fontSize/4 ;
    int fs=ceil(fontSize/4+10);
    
    UIImage *image=[UIImage imageNamed:@"Nodata"];
    
    UIImageView *icon=[[UIImageView alloc]initWithImage:image];
    
    [icon setFrame:CGRectMake(leftMargin, marginTop, 32, 32)];
    
    [self addSubview:icon];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin+32, marginTop, 1000, fs)];
    emptyLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:fs];
    emptyLabel.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.6];
    if(self.emptyText ==nil){
        self.emptyText=NSLocalizedString(@"Building_LabelNoData", @"");
    }
    emptyLabel.text=self.emptyText;
    emptyLabel.backgroundColor=[UIColor clearColor];
    emptyLabel.shadowOffset=CGSizeMake(1, 1);
    emptyLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    [self addSubview:emptyLabel];
    
    self.emptyLabel=emptyLabel;
}

- (NSString *)addThousandSeparator:(NSNumber *)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *theString = [numberFormatter stringFromNumber:number];
    
    return theString;
}

- (void)setTitleIcon:(UIImage *)image
{
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    
    CGRect titleFrame = self.titleLabel.frame;
    
    
    
    CGSize expectedLabelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    
    [view setFrame:CGRectMake(expectedLabelSize.width+5+kBuildingCommodityDetailTextMargin, titleFrame.origin.y, 16, 16)];
    
    [self insertSubview:view aboveSubview:self.titleLabel];
}

- (void)initTitle:(NSString *)text withSize:(CGFloat)size withLeftMargin:(CGFloat)leftMargin
{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, kBuildingCommodityDetailWidth, size)];
    titleLabel.text=text;
    titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@(kBuildingFontSC) size:size];
    //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    //NSLog(@"font:%@",[UIFont fontWithName:@(kBuildingFontSC) size:size]);
    //CGSize expectedLabelSize = [text sizeWithFont:[UIFont fontWithName:@(kBuildingFontSC) size:size]];
    
    //NSLog(@"valuesize:%@",NSStringFromCGSize(expectedLabelSize));
    //self.titleLabel.contentMode = UIViewContentModeTopLeft;
    [self addSubview:titleLabel];
    self.titleLabel=titleLabel;
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
