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




- (void)initTitle:(NSString *)text withSize:(CGFloat)size
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kBuildingCommodityDetailWidth, size)];
    self.titleLabel.text=text;
    self.titleLabel.shadowColor=[UIColor blackColor];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@(kBuildingFont) size:size];
    //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.contentMode = UIViewContentModeTopLeft;
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
