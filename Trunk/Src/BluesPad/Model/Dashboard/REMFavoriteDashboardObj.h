//
//  REMFavoriteDashboardObj.h
//  Blues
//
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
