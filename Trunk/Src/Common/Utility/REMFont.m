/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMFont.m
 * Date Created : 张 锋 on 6/19/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMFont.h"

@implementation REMFont

#define kDefaultFontName NSLocalizedStringFromTable(@"Font_DefaultFontName", @"Localizable_Style", REMEmptyStrng)

+(UIFont *)defaultFontOfSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:kDefaultFontName size:size];
    
    return font;
}

@end
