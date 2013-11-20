/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDimensionForMap.h
 * Created      : 张 锋 on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMDimensionForMap_h
#define Blues_REMDimensionForMap_h

#import "REMDimensions.h"

//prefix: kDMMap, kDMGallery
#pragma mark kDMMap_

#define kDMMap_MapEdgeInsetsLeft 80.0f
#define kDMMap_MapEdgeInsets UIEdgeInsetsMake(kDMCommon_TitleGradientLayerHeight*2, kDMMap_MapEdgeInsetsLeft, kDMMap_MapEdgeInsetsLeft, kDMMap_MapEdgeInsetsLeft)

#define kDMMap_BubbleBodyHeight 45
#define kDMMap_BubbleArrowHeight 11
#define kDMMap_BubbleArrowWidth 23
#define kDMMap_BubbleHeight kDMMap_BubbleBodyHeight + kDMMap_BubbleArrowHeight
#define kDMMap_BubbleBottomOffsetToMarker 6

#define kDMMap_BubbleContentTopOffset 6
#define kDMMap_BubbleContentLeftOffset 27
#define kDMMap_BubbleContentMainTitleFontSize 17
#define kDMMap_BubbleContentSubTitleFontSize 11
#define kDMMap_BubbleContentSubTitleTopOffset kDMMap_BubbleContentTopOffset + kDMMap_BubbleContentMainTitleFontSize + 4





#pragma mark kDMGallery_

#define kDMGallery_GalleryGroupViewTopOffset REMDMCOMPATIOS7(109)
#define kDMGallery_GalleryGroupViewWidth (kDMScreenWidth - 2*kDMCommon_ContentLeftMargin)
#define kDMGallery_GalleryGroupViewHeight (kDMScreenHeight - kDMGallery_GalleryGroupViewTopOffset)

#define kDMGallery_GalleryGroupTitleFontSize 16
#define kDMGallery_GalleryGroupTitleFontColor [UIColor whiteColor]

#define kDMGallery_GalleryCollectionViewTopMargin 17
#define kDMGallery_GalleryCollectionViewBottomMargin 18
#define kDMGallery_GalleryCellCountPerRow 6
#define kDMGallery_GalleryCellWidth 157
#define kDMGallery_GalleryCellHeight 118
//#define kDMGallery_GalleryCellHorizontalSpace 10
#define kDMGallery_GalleryCellVerticleSpace 16
#define kDMGallery_GalleryCellTitleTopOffset 9
#define kDMGallery_GalleryCellTitleLeftOffset 9
#define kDMGallery_GalleryCellTitleRightOffset 9
#define kDMGallery_GalleryCellTitleFontSize 14
#define kDMGallery_GalleryCellTitleHeight kDMGallery_GalleryCellTitleFontSize+1


#define kDMGallery_BackgroundColor [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:31.0/255.0 alpha:1]

#define kDMGallery_GalleryTableViewFrame CGRectMake(kDMCommon_ContentLeftMargin, kDMGallery_GalleryGroupViewTopOffset, kDMGallery_GalleryGroupViewWidth, kDMGallery_GalleryGroupViewHeight)

#define kDMGallery_GalleryCollectionViewInsets UIEdgeInsetsMake(kDMGallery_GalleryCollectionViewTopMargin, 0, kDMGallery_GalleryCollectionViewBottomMargin, 0)

#define kDMGallery_GalleryCellFrame CGRectMake(0,0,kDMGallery_GalleryCellWidth,kDMGallery_GalleryCellHeight)

#define kDMGallery_GalleryCellTitleFrame CGRectMake(kDMGallery_GalleryCellTitleLeftOffset, kDMGallery_GalleryCellTitleTopOffset, kDMGallery_GalleryCellWidth - kDMGallery_GalleryCellTitleLeftOffset - kDMGallery_GalleryCellTitleRightOffset, kDMGallery_GalleryCellTitleHeight)

#define kDMGallery_GalleryCellSize CGSizeMake(kDMGallery_GalleryCellWidth,kDMGallery_GalleryCellHeight)

#define kDMGallery_GalleryCellHorizontalSpace 1


#endif
