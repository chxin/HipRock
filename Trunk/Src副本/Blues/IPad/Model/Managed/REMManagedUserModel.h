//
//  REMManagedUserModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedCustomerModel;

@interface REMManagedUserModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isDemo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSNumber * spId;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * title;
@property (nonatomic, retain) NSString * userTypeName;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSOrderedSet *customers;
@end

@interface REMManagedUserModel (CoreDataGeneratedAccessors)

- (void)insertObject:(REMManagedCustomerModel *)value inCustomersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCustomersAtIndex:(NSUInteger)idx;
- (void)insertCustomers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCustomersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCustomersAtIndex:(NSUInteger)idx withObject:(REMManagedCustomerModel *)value;
- (void)replaceCustomersAtIndexes:(NSIndexSet *)indexes withCustomers:(NSArray *)values;
- (void)addCustomersObject:(REMManagedCustomerModel *)value;
- (void)removeCustomersObject:(REMManagedCustomerModel *)value;
- (void)addCustomers:(NSOrderedSet *)values;
- (void)removeCustomers:(NSOrderedSet *)values;
@end
