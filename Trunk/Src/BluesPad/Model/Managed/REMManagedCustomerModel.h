//
//  REMManagedCustomerModel.h
//  Blues
//
//  Created by tantan on 2/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedAdministratorModel, REMManagedUserModel;

@interface REMManagedCustomerModel : REMManagedModel

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * logoId;
@property (nonatomic, retain) NSString * manager;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * timezoneId;
@property (nonatomic, retain) NSSet *administrators;
@property (nonatomic, retain) REMManagedUserModel *user;
@end

@interface REMManagedCustomerModel (CoreDataGeneratedAccessors)

- (void)addAdministratorsObject:(REMManagedAdministratorModel *)value;
- (void)removeAdministratorsObject:(REMManagedAdministratorModel *)value;
- (void)addAdministrators:(NSSet *)values;
- (void)removeAdministrators:(NSSet *)values;

@end
