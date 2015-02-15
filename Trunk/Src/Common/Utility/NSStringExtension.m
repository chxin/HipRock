/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: NSStringExtension.m
 * Date Created : 张 锋 on 2/15/15.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "NSStringExtension.h"

@implementation NSString (Sizes)

- (CGSize)sizeWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize adjustedSize = CGSizeMake(ceil(size.width), ceil(size.height));
    
    return adjustedSize;
}

- (void)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = lineBreakMode;
    textStyle.alignment = alignment;
    
    NSDictionary *attrsDictionary = @{NSFontAttributeName:font, NSParagraphStyleAttributeName : textStyle };
    
    [self drawInRect:rect withAttributes:attrsDictionary];
}

@end
