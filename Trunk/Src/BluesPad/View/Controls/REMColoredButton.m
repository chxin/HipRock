//
//  REMColoredButton.m
//  Blues
//
//  Created by 张 锋 on 8/2/13.
//
//

#import "REMColoredButton.h"

@implementation REMColoredButton

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
    [super drawRect:rect];
    // Drawing code
    
    NSArray *images = [self getColorImages];
    
    // Set the background for any states you plan to use
    [self setBackgroundImage:images[0] forState:UIControlStateNormal];
    [self setBackgroundImage:images[1] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateHighlighted];
}

- (void)setEnabled:(BOOL)enabled
{
    if(enabled==YES)
    {
        UIImage *buttonImage = [self getColorImages][0];
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *buttonImage = [self getDisabledColorImage];
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    
    [super setEnabled:enabled];
}

#pragma mark - private
- (NSArray *)getColorImages
{
    NSString *colorName = @"green";
    switch (self.buttonColor) {
        case REMColoredButtonBlack:
            colorName = @"black";
            break;
        case REMColoredButtonBlue:
            colorName = @"blue";
            break;
        case REMColoredButtonGreen:
            colorName = @"green";
            break;
        case REMColoredButtonOrage:
            colorName = @"orange";
            break;
        case REMColoredButtonTan:
            colorName = @"tan";
            break;
        case REMColoredButtonWhite:
            colorName = @"white";
            break;
            
        default:
            break;
    }
    
    NSString *normalStateImageFile = [NSString stringWithFormat: @"%@Button.png",colorName ];
    NSString *activeStateImageFile = [NSString stringWithFormat:@"%@ButtonHighlight.png",colorName ];
    
    UIImage *buttonImage = [[UIImage imageNamed:normalStateImageFile] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:activeStateImageFile] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    return [NSArray arrayWithObjects:buttonImage,buttonImageHighlight, nil];
}

- (UIImage *)getDisabledColorImage
{
    return [[UIImage imageNamed:@"greyButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
}

@end
