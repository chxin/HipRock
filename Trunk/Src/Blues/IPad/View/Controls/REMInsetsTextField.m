/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMInsetsTextField.m
 * Created      : 张 锋 on 8/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMInsetsTextField.h"

@interface REMInsetsTextField()

@property (nonatomic) UIEdgeInsets insets;

@end

@implementation REMInsetsTextField

-(id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.insets = insets;
    }
    return self;
}


//控制 placeHolder 的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat x = bounds.origin.x + self.insets.left;
    CGFloat y = bounds.origin.y + self.insets.top;
    CGFloat width = bounds.size.width - (self.insets.left + self.insets.right);
    CGFloat height = bounds.size.height - (self.insets.top + self.insets.bottom);
    
    return CGRectMake(x,y,width,height);
}

// 控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGFloat x = bounds.origin.x + self.insets.left;
    CGFloat y = bounds.origin.y + self.insets.top;
    CGFloat width = bounds.size.width - (self.insets.left + self.insets.right);
    CGFloat height = bounds.size.height - (self.insets.top + self.insets.bottom);
    
    return CGRectMake(x,y,width,height);
}

@end
