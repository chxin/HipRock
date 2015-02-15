/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: NSStringExtension.h
 * Date Created : 张 锋 on 2/15/15.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface NSString (Sizes)

- (CGSize)sizeWithFont:(UIFont *)font;

- (void)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

@end
