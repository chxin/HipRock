//
//  REMBuildingDataView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingDataView.h"

@interface REMBuildingDataView()

@property (nonatomic,strong) REMBuildingTitleView *totalLabel;
@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;

@end
@implementation REMBuildingDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *array = @[@"123,2312",@"12312,123",@"435,34534",@"655,464",@"42,678",@"234,3453"];
        int gap=85;
        int i=0;
        for (NSString *str in array) {
            REMNumberLabel *titleLabel = [[REMNumberLabel alloc]initWithFrame:CGRectMake(5, 5+gap*i, frame.size.width, 80)];
            titleLabel.text=str;
            titleLabel.shadowColor=[UIColor blackColor];
            titleLabel.shadowOffset=CGSizeMake(1, 1);
            
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.font = [UIFont fontWithName:@"Avenir" size:80];
            //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
            titleLabel.textColor=[UIColor whiteColor];
            titleLabel.contentMode = UIViewContentModeTopLeft;
            [self addSubview:titleLabel];
            ++i;
        }
        
      
        
        
    }
    return self;
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
