/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMToggleButton.m
 * Created      : Zilong-Oscar.Xu on 8/19/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMToggleButton.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingConstants.h"
#import "REMColor.h"
#import "REMCommonHeaders.h"

@implementation REMToggleButton 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.titleLabel.font = [REMFont defaultFontOfSize:15];
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [self.layer setMasksToBounds:YES];
//        [self.layer setCornerRadius:3.0];
//        [self.layer setBorderWidth:0];
    }
    return self;
}

-(void)setOn:(BOOL)onThis {
    if (onThis == self.on) return;
    
    _on = onThis;
    if (onThis) {
        //[self setTitleColor:[UIColor colorWithRed:83/255.0 green:237/255.0 blue:86/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[REMColor colorByHexString:@"#00ff48"] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
