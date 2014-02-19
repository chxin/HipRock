/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetSyntaxObject.h
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMWidgetContentSyntax.h"
#import "REMShareInfo.h"
#import "REMEnum.h"


@interface REMWidgetObject : REMJSONObject

@property (nonatomic,strong) NSNumber *widgetId;
@property (nonatomic,strong) NSNumber *dashboardId;
@property (nonatomic) BOOL isRead;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *layoutSyntax;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
@property (nonatomic) REMDiagramType diagramType;
@property (nonatomic,strong) REMShareInfo *shareInfo;

@end
