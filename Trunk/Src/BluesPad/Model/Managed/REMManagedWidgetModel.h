//
//  REMManagedWidgetModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedDashboardModel;

@interface REMManagedWidgetModel : REMManagedModel

@property (nonatomic, retain) REMManagedDashboardModel *dashboard;

@end
