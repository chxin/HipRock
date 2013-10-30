//
//  REMLabel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/2/13.
//
//

#import "REMNumberLabel.h"

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
    
    UIFont *customFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
    self.font = customFont;
    
    [super drawRect:rect];
    
    // Drawing code
}


@end
