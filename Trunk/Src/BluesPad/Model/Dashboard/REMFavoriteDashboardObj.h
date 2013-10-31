//
//  REMFavoriteDashboardObj.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMDashboardObj.h"
#import "REMWidgetObject.h"

@interface REMFavoriteDashboardObj : REMJSONObject

@property (nonatomic,strong) REMDashboardObj *dashboard;
@property (nonatomic,strong) NSArray *widgets;

@end
