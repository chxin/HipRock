//
//  REMDimensionForMap.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/8/13.
//
//

#ifndef Blues_REMDimensionForMap_h
#define Blues_REMDimensionForMap_h

#import "REMDimensions.h"

//prefix: kDMMap, kDMGallery
#define kDMMap_MapEdgeInsetsLeft 80.0f
#define kDMMap_MapEdgeInsets UIEdgeInsetsMake(kDMCommon_TitleGradientLayerHeight*2, kDMMap_MapEdgeInsetsLeft, kDMMap_MapEdgeInsetsLeft, kDMMap_MapEdgeInsetsLeft)


#pragma mark kDMGallery
#define kDMGallery_GalleryGroupViewTopOffset 109
#define kDMGallery_GalleryGroupViewWidth (kDMScreenWidth - 2*kDMCommon_ContentLeftMargin)
#define kDMGallery_GalleryGroupViewHeight (kDMScreenHeight - kDMStatusBarHeight - kDMGallery_GalleryGroupViewTopOffset)

#define kDMGallery_GalleryGroupTitleFontSize 16
#define kDMGallery_GalleryGroupTitleFontColor [UIColor whiteColor]

#define kDMGallery_GalleryCollectionViewTopMargin 17
#define kDMGallery_GalleryCollectionViewBottomMargin 18
#define kDMGallery_GalleryCellWidth 154
#define kDMGallery_GalleryCellHeight 110
#define kDMGallery_GalleryCellHorizontalSpace 10
#define kDMGallery_GalleryCellVerticleSpace 16


#define kDMGallery_GalleryTableViewFrame CGRectMake(kDMCommon_ContentLeftMargin, kDMGallery_GalleryGroupViewTopOffset, kDMGallery_GalleryGroupViewWidth, kDMGallery_GalleryGroupViewHeight)
#define kDMGallery_GalleryCollectionViewInsets UIEdgeInsetsMake(kDMGallery_GalleryCollectionViewTopMargin, 0, kDMGallery_GalleryCollectionViewBottomMargin, 0)



#endif
