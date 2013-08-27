//
//  REMBuildingTitleView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleView.h"

@interface REMBuildingTitleView()


@end

@implementation REMBuildingTitleView


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
    
    [view setFrame:CGRectMake(expectedLabelSize.width+5+kBuildingCommodityDetailTextMargin, titleFrame.origin.y, 18, 14)];
    
    [self insertSubview:view aboveSubview:self.titleLabel];
}

- (void)initTitle:(NSString *)text withSize:(CGFloat)size withLeftMargin:(CGFloat)leftMargin
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 0, kBuildingCommodityDetailWidth, size)];
    self.titleLabel.text=text;
    self.titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@(kBuildingFontSC) size:size];
    //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor=[UIColor whiteColor];
    //NSLog(@"font:%@",[UIFont fontWithName:@(kBuildingFontSC) size:size]);
    //CGSize expectedLabelSize = [text sizeWithFont:[UIFont fontWithName:@(kBuildingFontSC) size:size]];
    
    //NSLog(@"valuesize:%@",NSStringFromCGSize(expectedLabelSize));
    //self.titleLabel.contentMode = UIViewContentModeTopLeft;
    [self addSubview:self.titleLabel];
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
