//
//  REMLocalizeKeys.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/22/13.
//
//

#define REMLocalizedString(a) NSLocalizedString(a,@"")


#ifndef Blues_REMLocalizeKeys_h
#define Blues_REMLocalizeKeys_h

#pragma mark Common
//Common, prefix: kLNCommon_
#define kLNCommon_ServerError @"Common_ServerError"


#pragma mark Login
//Login, prefix: kLNLogin_
#define kLNLogin_NoNetwork @"Login_NoNetwork"
#define kLNLogin_NetworkTimeout @"Login_NetworkTimeout"

#define kLNLogin_UserNotExist @"Login_UserNotExist"
#define kLNLogin_WrongPassword @"Login_WrongPassword"
#define kLNLogin_NotAuthorized @"Login_NotAuthorized"
#define kLNLogin_AccountLocked @"Login_AccountLocked"



#pragma mark Map
//Map, prefix: kLNMap_


#pragma mark Gallery
//Gallery, prefix: kLNGallery_


#pragma mark Building
//Building, prefix: kLNBuilding_
#define kLNBuildingChart_NoData @"BuildingChart_NoData"
#define kLNBuildingChart_DataError @"BuildingChart_DataError"


#pragma mark Dashboard
//Dashboard, prefix: kLNDashboard_



//Chart, prefix: kLNChart_

#endif
