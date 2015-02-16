/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDimensions.h
 * Created      : 张 锋 on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMDimensions_h
#define Blues_REMDimensions_h

#import "REMUtilityMacro.h"

#import "REMDimensionForSplashScreen.h"
#import "REMDimensionForLogin.h"
#import "REMDimensionForMap.h"
#import "REMDimensionForBuilding.h"
#import "REMDimensionForChart.h"

#pragma mark System const dimensions

#define REMDMCOMPATIOS7(d) (REMISIOS7 ? ((d) + kDMStatusBarHeight) : (d))

//prefix: kDM

#define kDMScreenWidth 1024
#define kDMScreenHeight 768
#define kDMStatusBarHeight 20
#define kDMDefaultViewFrame (REMISIOS7 ? CGRectMake(0,0,kDMScreenWidth,kDMScreenHeight) : CGRectMake(0,0,kDMScreenWidth,kDMScreenHeight-kDMStatusBarHeight))
#define kDMButtonExtending 12



#pragma mark Common dimensions
//prefix: kDMCommon_

#define kDMCommon_ContentLeftMargin 25

#define kDMCommon_ContentWidth kDMScreenWidth - (2 * kDMCommon_ContentLeftMargin)

#define kDMCommon_TopLeftButtonLeft kDMCommon_ContentLeftMargin

#define kDMCommon_TopLeftButtonTop 23

#define kDMCommon_TopLeftButtonWidth 26
#define kDMCommon_TopLeftButtonHeight 32

#define kDMCommon_CustomerLogoLeft kDMCommon_TopLeftButtonLeft + kDMCommon_TopLeftButtonWidth + 8

#define kDMCommon_CustomerLogoTop 18



#define kDMCommon_CustomerLogoWidth 187
#define kDMCommon_CustomerLogoHeight 40
//#define kDMCommon_CustomerLogoFrame CGRectMake(kDMCommon_CustomerLogoLeft,kDMCommon_CustomerLogoTop,kDMCommon_CustomerLogoWidth,kDMCommon_CustomerLogoHeight)

#define kDMCommon_TitleGradientLayerHeight REMDMCOMPATIOS7(109)
#define kDMCommon_TitleGradientLayerFrame CGRectMake(0,0,kDMScreenWidth,kDMCommon_TitleGradientLayerHeight)

#define kDMCommon_ImageScale 1.02


#endif
