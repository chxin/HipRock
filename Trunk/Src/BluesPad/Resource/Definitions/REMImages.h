//
//  REMImages.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/22/13.
//
//  Warning: Content of this file is maintained by external tool,
//           please do not change its content manually
//
//  To update this file, please goto Tools and execute gen-images.py

#ifndef Blues_REMImages_h
#define Blues_REMImages_h

#define REMLoadImage(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]
#define REMLoadPngImage(a) REMLoadImage((a),@"png")
#define REMLoadJpgImage(a) REMLoadImage((a),@"jpg")


#pragma mark - Definitions

//images in /:
#define REMIMG_Default REMLoadImage(@"Default",@"png")
#define REMIMG_EMOP_App_6 REMLoadImage(@"EMOP_App_6",@"png")
#define REMIMG_EMOP_APP_7 REMLoadImage(@"EMOP_APP_7",@"png")
#define REMIMG_EMOP_Setting REMLoadImage(@"EMOP_Setting",@"png")
#define REMIMG_EMOP_Spotlight_6 REMLoadImage(@"EMOP_Spotlight_6",@"png")
#define REMIMG_EMOP_Spotlight_7 REMLoadImage(@"EMOP_Spotlight_7",@"png")
#define REMIMG_WeiboBana REMLoadImage(@"WeiboBana",@"jpg")

//images in /Building:
#define REMIMG_DefaultBuilding_Small REMLoadImage(@"DefaultBuilding-Small",@"png")
#define REMIMG_DefaultBuilding REMLoadImage(@"DefaultBuilding",@"png")
#define REMIMG_mail REMLoadImage(@"mail",@"jpg")
#define REMIMG_Menu_normal REMLoadImage(@"Menu_normal",@"png")
#define REMIMG_NotOverTarget REMLoadImage(@"NotOverTarget",@"png")
#define REMIMG_OverTarget REMLoadImage(@"OverTarget",@"png")
#define REMIMG_share_mail REMLoadImage(@"share-mail",@"png")
#define REMIMG_share_weibo REMLoadImage(@"share-weibo",@"png")
#define REMIMG_Share_disable REMLoadImage(@"Share_disable",@"png")
#define REMIMG_Share_normal REMLoadImage(@"Share_normal",@"png")
#define REMIMG_weibo REMLoadImage(@"weibo",@"png")

//images in /Building/commodity:
#define REMIMG_Coal_normal REMLoadImage(@"Coal_normal",@"png")
#define REMIMG_Coal_pressed REMLoadImage(@"Coal_pressed",@"png")
#define REMIMG_Electricity_normal REMLoadImage(@"Electricity_normal",@"png")
#define REMIMG_Electricity_pressed REMLoadImage(@"Electricity_pressed",@"png")
#define REMIMG_NaturalGas_normal REMLoadImage(@"NaturalGas_normal",@"png")
#define REMIMG_NaturalGas_pressed REMLoadImage(@"NaturalGas_pressed",@"png")
#define REMIMG_Oil_normal REMLoadImage(@"Oil_normal",@"png")
#define REMIMG_Oil_pressed REMLoadImage(@"Oil_pressed",@"png")
#define REMIMG_PM2_5_normal REMLoadImage(@"PM2.5_normal",@"png")
#define REMIMG_PM2_5_pressed REMLoadImage(@"PM2.5_pressed",@"png")
#define REMIMG_Water_normal REMLoadImage(@"Water_normal",@"png")
#define REMIMG_Water_pressed REMLoadImage(@"Water_pressed",@"png")

//images in /Dashboard:
#define REMIMG_Back REMLoadImage(@"Back",@"png")
#define REMIMG_Down REMLoadImage(@"Down",@"png")
#define REMIMG_Nodata REMLoadImage(@"Nodata",@"png")
#define REMIMG_Up REMLoadImage(@"Up",@"png")

//images in /Login:
#define REMIMG_JumpLogin_Normal REMLoadImage(@"JumpLogin-Normal",@"png")
#define REMIMG_JumpLogin_Pressed REMLoadImage(@"JumpLogin-Pressed",@"png")
#define REMIMG_Login_Disable REMLoadImage(@"Login-Disable",@"png")
#define REMIMG_Login_Normal REMLoadImage(@"Login-Normal",@"png")
#define REMIMG_Login_Pressed REMLoadImage(@"Login-Pressed",@"png")
#define REMIMG_LoginTextField_Focus REMLoadImage(@"LoginTextField-Focus",@"png")
#define REMIMG_LoginTextField REMLoadImage(@"LoginTextField",@"png")
#define REMIMG_Propaganda_1 REMLoadImage(@"Propaganda_1",@"jpg")
#define REMIMG_Propaganda_2 REMLoadImage(@"Propaganda_2",@"jpg")
#define REMIMG_Propaganda_3 REMLoadImage(@"Propaganda_3",@"jpg")
#define REMIMG_SlidePageBackground REMLoadImage(@"SlidePageBackground",@"png")

//images in /Map:
#define REMIMG_CommonPin_Focus REMLoadImage(@"CommonPin_Focus",@"png")
#define REMIMG_CommonPin_Normal REMLoadImage(@"CommonPin_Normal",@"png")
#define REMIMG_Gallery REMLoadImage(@"Gallery",@"png")
#define REMIMG_Map REMLoadImage(@"Map",@"png")
#define REMIMG_MarkerBubble REMLoadImage(@"MarkerBubble",@"png")
#define REMIMG_MarkerBubble_Pressed REMLoadImage(@"MarkerBubble_Pressed",@"png")
#define REMIMG_QualifiedPin_Focus REMLoadImage(@"QualifiedPin_Focus",@"png")
#define REMIMG_QualifiedPin_Normal REMLoadImage(@"QualifiedPin_Normal",@"png")
#define REMIMG_UnqualifiedPin_Focus REMLoadImage(@"UnqualifiedPin_Focus",@"png")
#define REMIMG_UnqualifiedPin_Normal REMLoadImage(@"UnqualifiedPin_Normal",@"png")

//images in /SplashScreen:
#define REMIMG_SplashScreenBackgroud REMLoadImage(@"SplashScreenBackgroud",@"jpg")
#define REMIMG_SplashScreenLogo_common REMLoadImage(@"SplashScreenLogo-common",@"png")
#define REMIMG_SplashScreenLogo_Flash REMLoadImage(@"SplashScreenLogo-Flash",@"png")

#endif