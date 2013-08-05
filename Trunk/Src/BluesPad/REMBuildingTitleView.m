//
//  REMBuildingTitleView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleView.h"

@interface REMBuildingTitleView()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation REMBuildingTitleView



- (id)initWithFrame:(CGRect)frame ByData:(REMBuildingTitleViewData *)data
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initTitle:data.title];
    }
    
    return self;
}

- (void)initTitle:(NSString *)title
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-5, 80)];
    self.titleLabel.text=title;
    self.titleLabel.shadowColor=[UIColor blackColor];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir" size:80];
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
