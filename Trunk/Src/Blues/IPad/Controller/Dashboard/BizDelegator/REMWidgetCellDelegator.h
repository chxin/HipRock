/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCellDelegator.h
 * Date Created : tantan on 12/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMWidgetContentSyntax.h"
#import "REMWidgetSearchModelBase.h"
#import "REMManagedWidgetModel.h"
@interface REMWidgetCellDelegator : NSObject

+ (REMWidgetCellDelegator *)bizWidgetCellDelegator:(REMManagedWidgetModel *)widgetInfo andSyntax:(REMWidgetContentSyntax *)contentSyntax;

@property (nonatomic,weak) UIView *view;
@property (nonatomic,weak) REMManagedWidgetModel *widgetInfo;
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) REMWidgetSearchModelBase *searchModel;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
- (void)initBizView;

- (void)initWidgetCellTimeTitle;

- (NSString *)cellTimeTitle;

@end
