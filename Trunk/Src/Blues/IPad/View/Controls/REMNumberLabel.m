/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLabel.m
 * Created      : 张 锋 on 8/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMNumberLabel.h"
#import "REMCommonHeaders.h"

@implementation REMNumberLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Helvetica Neue UltraLight 60.0
    //self.textColor = [UIColor redColor];
    
    float fontSize = 0;
    if(self.fontSize != nil)
    {
        fontSize = [self.fontSize floatValue];
    }
    else
    {
        if(self.font!=nil){
            fontSize = self.font.pointSize;
        }
        else{
            fontSize = [UIFont systemFontSize];
        }
    }
    
    UIFont *customFont = [REMFont numberLabelFontOfSize:fontSize];
    self.font = customFont;
    
    [super drawRect:rect];
    
    // Drawing code
}


@end
