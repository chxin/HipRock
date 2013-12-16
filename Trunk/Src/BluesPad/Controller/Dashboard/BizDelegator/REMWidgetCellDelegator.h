/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCellDelegator.h
 * Date Created : tantan on 12/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMWidgetObject.h"
#import "REMWidgetSearchModelBase.h"

@interface REMWidgetCellDelegator : NSObject

+ (REMWidgetCellDelegator *)bizWidgetCellDelegator:(REMWidgetObject *)widgetInfo;

@property (nonatomic,weak) UIView *view;
@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) REMWidgetSearchModelBase *searchModel;

- (void)initBizView;

- (void)initWidgetCellTimeTitle;

- (NSString *)cellTimeTitle;

@end
