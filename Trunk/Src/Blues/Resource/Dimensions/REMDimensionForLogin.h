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
#define kDMLogin_PageControlTopOffset (kDMLogin_CardTopOffset + kDMLogin_CardHeight + 81)//122 //142
#define kDMLogin_PageControlHeight 8
#define kDMLogin_PageControlTintColor @"#88c274"
#define kDMLogin_SkipToLoginButtonTopOffset (kDMLogin_PageControlTopOffset + kDMLogin_PageControlHeight + 26)
#define kDMLogin_SkipToLoginButtonWidth 191 //232
#define kDMLogin_SkipToLoginButtonHeight 62
#define kDMLogin_SkipToLoginButtonFontSize 24
#define kDMLogin_SkipToLoginButtonFontColor @"#3f8e1f"
#define kDMLogin_SkipToLoginButtonImageTopShadowHeight 3
#define kDMLogin_SkipToLoginButtonImageBottomShadowHeight 12
#define kDMLogin_SkipToLoginButtonTextTopOffset (kDMLogin_SkipToLoginButtonHeight - kDMLogin_SkipToLoginButtonImageTopShadowHeight - kDMLogin_SkipToLoginButtonImageBottomShadowHeight - kDMLogin_SkipToLoginButtonFontSize) / 2 + kDMLogin_SkipToLoginButtonImageTopShadowHeight

#define kDMLogin_SkipToLoginButtonLeftOffset 31

#define kDMLogin_SkipToTrialButtonFontSize kDMLogin_SkipToLoginButtonFontSize
#define kDMLogin_SkipToTrialButtonFontColor @"#896700"
#define kDMLogin_SkipToTrialButtonImageTopShadowHeight 4
#define kDMLogin_SkipToTrialButtonImageBottomShadowHeight 13
#define kDMLogin_SkipToTrialButtonTextTopOffset (kDMLogin_SkipToLoginButtonHeight - kDMLogin_SkipToTrialButtonImageTopShadowHeight - kDMLogin_SkipToTrialButtonImageBottomShadowHeight - kDMLogin_SkipToTrialButtonFontSize)/2 + kDMLogin_SkipToTrialButtonImageTopShadowHeight



#define kDMLogin_CardTitleBackgroundColor @"#e8e8e8"
#define kDMLogin_CardTitleBackgroundHeight 57
#define kDMLogin_CardTitleBackgroundSeperatorColor @"#e0e0e0"
#define kDMLogin_CardTitleBackgroundSeperatorHeight 2
#define kDMLogin_CardTitleFontSize 24
#define kDMLogin_CardTitleFontColor @"#5b5b5b"
#define kDMLogin_CardTitleTopOffset (kDMLogin_CardTitleBackgroundHeight - kDMLogin_CardTitleFontSize)/2
#define kDMLogin_CardTitleViewHeight kDMLogin_CardTitleBackgroundHeight + kDMLogin_CardTitleBackgroundSeperatorHeight
#define kDMLogin_LoginButtonHeight 50
#define kDMLogin_LoginButtonWidth 330
//#define kDMLogin_LoginButtonTopOffset 220 //relative to title seperator line
#define kDMLogin_LoginButtonLeftOffset (kDMLogin_CardContentWidth - kDMLogin_LoginButtonWidth)/2
#define kDMLogin_LoginButtonFontColor @"#ffffff"
#define kDMLogin_LoginButtonFontSize 24


#define kDMLogin_TrialCardWelcomeTextTopOffset 92
#define kDMLogin_TrialCardWelcomeTextFontSize 21
#define kDMLogin_TrialCardWelcomeTextFontColor @"#383838"

#define kDMLogin_LoginCardPromptLabelLeftOffset kDMLogin_LoginButtonLeftOffset
#define kDMLogin_LoginCardPromptLabelTopOffset 22 //relative to title seperator line
#define kDMLogin_LoginCardPromptLabelWidth kDMLogin_LoginButtonWidth
#define kDMLogin_LoginCardPromptLabelFontSize 15
#define kDMLogin_LoginCardPromptLabelFontColor @"#5b5b5b"
#define kDMLogin_TextBoxWidth kDMLogin_LoginButtonWidth
#define kDMLogin_TextBoxHeight 52
#define kDMLogin_TextBoxFontSize 15
#define kDMLogin_TextBoxFontColor @"#b8b8b8"
#define kDMLogin_ErrorLabelFontSize 12
#define kDMLogin_ErrorLabelFontColor @"#ff0000"
#define kDMLogin_ErrorLabelWidth kDMLogin_LoginButtonWidth


#define kDMLogin_UserNameTextBoxLeftOffset kDMLogin_LoginButtonLeftOffset
#define kDMLogin_UserNameTextBoxTopOffset kDMLogin_LoginCardPromptLabelTopOffset+kDMLogin_LoginCardPromptLabelFontSize+13

#define kDMLogin_UserNameErrorLabelLeftOffset kDMLogin_LoginButtonLeftOffset
#define kDMLogin_UserNameErrorLabelTopOffset kDMLogin_UserNameTextBoxTopOffset+kDMLogin_TextBoxHeight+4


#define kDMLogin_PasswordTextBoxLeftOffset kDMLogin_LoginButtonLeftOffset
#define kDMLogin_PasswordTextBoxTopOffset kDMLogin_UserNameTextBoxTopOffset+kDMLogin_TextBoxHeight+22

#define kDMLogin_PasswordErrorLabelLeftOffset kDMLogin_LoginButtonLeftOffset
#define kDMLogin_PasswordErrorLabelTopOffset kDMLogin_PasswordTextBoxTopOffset+kDMLogin_TextBoxHeight+4

#define kDMLogin_LoginButtonTopOffset kDMLogin_PasswordTextBoxTopOffset + kDMLogin_TextBoxHeight + 22


#endif
