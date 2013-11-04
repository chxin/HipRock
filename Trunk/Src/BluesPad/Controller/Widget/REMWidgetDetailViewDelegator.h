//
//  REMWidgetDetailViewDelegator.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMWidgetDetailViewController.h"
@interface REMWidgetDetailViewDelegator : NSObject

@property (nonatomic,weak) REMWidgetDetailViewController *controller;

@property (nonatomic,weak) UIView *view;

@end
