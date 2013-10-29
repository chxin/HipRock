//
//  REMDimensions.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/10/13.
//
//

#ifndef Blues_REMDimensions_h
#define Blues_REMDimensions_h

#import "REMDimensionForSplashScreen.h"
#import "REMDimensionForLogin.h"
#import "REMDimensionForMap.h"
#import "REMDimensionForBuilding.h"
#import "REMDimensionForChart.h"

#pragma mark System const dimensions
//prefix: kDM

#define kDMScreenWidth 1024
#define kDMScreenHeight 768


#pragma mark Common dimensions
//prefix: kDMCommon_

#define kDMCommon_TopLeftButtonLeft 25
#define kDMCommon_TopLeftButtonTop 23
#define kDMCommon_TopLeftButtonWidth 32
#define kDMCommon_TopLeftButtonHeight 32
#define kDMCommon_TopLeftButtonFrame CGRectMake(kDMCommon_TopLeftButtonLeft, kDMCommon_TopLeftButtonTop,kDMCommon_TopLeftButtonWidth,kDMCommon_TopLeftButtonHeight)

#define kDMCommon_CustomerLogoLeft kDMCommon_TopLeftButtonLeft + kDMCommon_TopLeftButtonWidth + 8
#define kDMCommon_CustomerLogoTop 12
#define kDMCommon_CustomerLogoWidth 210
#define kDMCommon_CustomerLogoHeight 50
#define kDMCommon_CustomerLogoFrame CGRectMake(kDMCommon_CustomerLogoLeft,kDMCommon_CustomerLogoTop,kDMCommon_CustomerLogoWidth,kDMCommon_CustomerLogoHeight)

#define kDMCommon_TitleGradientLayerHeight 109
#define kDMCommon_TitleGradientLayerFrame CGRectMake(0,0,kDMScreenWidth,kDMCommon_TitleGradientLayerHeight)



#endif
