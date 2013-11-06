/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMInsetsTextField.m
 * Created      : 张 锋 on 8/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMInsetsTextField.h"

@implementation REMInsetsTextField

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
    // Drawing code
    [super drawRect:rect];
}


//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds , 15 , 0 );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds , 15 , 0 );
}

@end
