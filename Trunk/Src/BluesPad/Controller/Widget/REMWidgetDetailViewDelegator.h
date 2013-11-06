/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetDetailViewDelegator.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMWidgetDetailViewController.h"
@interface REMWidgetDetailViewDelegator : NSObject

@property (nonatomic,weak) REMWidgetDetailViewController *controller;

@property (nonatomic,weak) UIView *view;

@end
