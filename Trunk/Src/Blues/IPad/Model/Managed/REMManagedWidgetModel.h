//
//  REMManagedWidgetModel.h
//  Blues
//
//  Created by tantan on 2/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedDashboardModel, REMManagedSharedModel;

@interface REMManagedWidgetModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * diagramType;
@property (nonatomic, retain) NSString * contentSyntax;
@property (nonatomic, retain) REMManagedDashboardModel *dashboard;
@property (nonatomic, retain) REMManagedSharedModel *sharedInfo;

@end
