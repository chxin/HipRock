//
//  REMManagedSharedModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedDashboardModel, REMManagedWidgetModel;

@interface REMManagedSharedModel : NSManagedObject

@property (nonatomic, retain) NSDate * shareTime;
@property (nonatomic, retain) NSString * userRealName;
@property (nonatomic, retain) NSString * userTelephone;
@property (nonatomic, retain) NSNumber * userTitle;
@property (nonatomic, retain) NSString * userTitleComponent;
@property (nonatomic, retain) REMManagedDashboardModel *dashboard;
@property (nonatomic, retain) REMManagedWidgetModel *widget;

@end
