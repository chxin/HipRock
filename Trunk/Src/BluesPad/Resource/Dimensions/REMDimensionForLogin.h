/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDimensionLogin.h
 * Created      : 张 锋 on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMDimensionLogin_h
#define Blues_REMDimensionLogin_h

#import "REMDimensions.h"

//prefix: kDMLogin
#define kDMLogin_CardTopOffset REMDMCOMPATIOS7(88)
#define kDMLogin_CardWidth 528
#define kDMLogin_CardHeight 380
#define kDMLogin_CardContentWidth 500
#define kDMLogin_CardContentHeight 350
#define kDMLogin_CardContentTopOffset 7 //5
#define kDMLogin_CardContentLeftOffset 14
#define kDMLogin_PageControlTopOffset kDMLogin_CardTopOffset + kDMLogin_CardHeight + 122 //142
#define kDMLogin_PageControlHeight 8
#define kDMLogin_PageControlTintColor @"#88c274"
#define kDMLogin_SkipToLoginButtonTopOffset kDMLogin_PageControlTopOffset + kDMLogin_PageControlHeight + 26
#define kDMLogin_SkipToLoginButtonWidth 160//232
#define kDMLogin_SkipToLoginButtonHeight 50
#define kDMLogin_SkipToLoginButtonFontSize 24
#define kDMLogin_SkipToLoginButtonFontColor @"#3f8e1f"

#define kDMLogin_SkipToTrialButtonLeftOffset 16

#endif
