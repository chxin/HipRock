/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSegues.h
 * Created      : 张 锋 on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMSegues_h

#define Blues_REMSegues_h

#pragma mark - Segue names
//Prefix: kSegue

#define kSegue_LoginToCustomer @"loginCustomerSegue"

#define kSegue_SplashToLogin @"splashToLoginSegue"
#define kSegue_SplashToMap @"splashToMapSegue"

#define kSegue_MapToBuilding @"mapToBuildingSegue"
#define kSegue_BuildingToMap @"buildingToMapSegue"

#define kSegue_MapToGallery @"mapToGallerySegue"
#define kSegue_GalleryToMap @"galleryToMapSegue"

#define kSegue_GalleryToBuilding @"galleryToBuildingSegue"
#define kSegue_BuildingToGallery @"buildingToGallerySegue"

#define kSegue_ToSettings @"settingsSegue"

#define kSegue_BuildingToSharePopover @"buildingToSharePopover"


#pragma mark - Storyboard IDs
//Prefix: kStoryboard_

#define kStoryboard_SettingsPage @"settingsPage"


#pragma mark - cell identifiers
//Prefix: kCellIdentifier_

#define kCellIdentifier_GalleryGroupCell @"galleryGroupCellIdentifier"
#define kCellIdentifier_GalleryCollectionCell @"galleryCollectionCellIdentifier"

#endif
