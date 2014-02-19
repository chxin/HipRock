/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboardObj.h
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMWidgetObject.h"
#import "REMShareInfo.h"

@interface REMDashboardObj : REMJSONObject

@property (nonatomic,strong) NSNumber *dashboardId;
@property (nonatomic,strong) NSNumber *hierarchyId;
@property (nonatomic,strong) NSString *hierarchyName;
@property (nonatomic) BOOL isFavorate;
@property  (nonatomic) BOOL isRead;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *widgets;
@property (nonatomic,strong) REMShareInfo *shareInfo;

- (NSArray *)trendWidgetArray;

@end
