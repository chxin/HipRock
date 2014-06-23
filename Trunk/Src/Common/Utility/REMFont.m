/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMFont.m
 * Date Created : 张 锋 on 6/19/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMFont.h"

@implementation REMFont

#define REMLocalizedStyleString(a) NSLocalizedStringFromTable((a), @"Localizable_Style", REMEmptyString)
#define kDefaultFontNameKey @"Font_DefaultFontName"
#define kDefaultFontSize 14


+(UIFont *)defaultFontOfSize:(CGFloat)size
{
    return [REMFont fontWithKey:kDefaultFontNameKey size:size];
}
+(UIFont *)defaultFontSize
{
    return [REMFont defaultFontOfSize:kDefaultFontSize];
}
+(UIFont *)fontWithKey:(NSString *)key size:(CGFloat)size
{
    NSString *fontName = REMLocalizedStyleString(key);
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    
    return font;
}

@end
