/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMFont.h
 * Date Created : 张 锋 on 6/19/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

#define kSystemFontSize 17.0
#define REMNavigationItemFontAttribute @{ NSFontAttributeName: [REMFont defaultFontOfSize:kSystemFontSize], }
#define REMNavigationTitleFontAttribute @{ NSFontAttributeName: [REMFont defaultFontOfSize:kSystemFontSize], }

@interface REMFont : NSObject
+(UIFont *)defaultFontOfSize:(CGFloat)size;
+(UIFont *)defaultFont;
+(UIFont *)defaultFontSystemSize;
+(UIFont *)numberLabelFontOfSize:(CGFloat)size;

//+(UIFont *)fontWithKey:(NSString *)key size:(CGFloat)size;
@end
