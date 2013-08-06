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
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UILabel *uomLabel;

@end

@implementation REMBuildingTitleLabelView

- (id)initWithFrame:(CGRect)frame withData:(REMEnergyUsageDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initTitle:title withSize:size];
        [self initTextLabel:data];
    }
    
    return self;
}

- (void)initTextLabel:(REMEnergyUsageDataModel *)data
{
    self.textLabel = [[REMNumberLabel alloc] initWithFrame:CGRectMake(5, 0, 100, 80)];
    self.textLabel.text=[NSString stringWithFormat:@"%@", data.dataValue];
    [self addSubview:self.textLabel];
    self.uomLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 50, 50)];
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
