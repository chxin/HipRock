//
//  REMManagedUserModel.h
//  Blues
//
//  Created by tantan on 2/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedCustomerModel;

@interface REMManagedUserModel : REMManagedModel

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isDemo;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSNumber * spId;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * title;
@property (nonatomic, retain) NSString * userTypeName;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *customers;
@end

@interface REMManagedUserModel (CoreDataGeneratedAccessors)

- (void)addCustomersObject:(REMManagedCustomerModel *)value;
- (void)removeCustomersObject:(REMManagedCustomerModel *)value;
- (void)addCustomers:(NSSet *)values;
- (void)removeCustomers:(NSSet *)values;

@end
