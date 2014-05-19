//
//  REMManagedCustomerModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedAdministratorModel, REMManagedUserModel;

@interface REMManagedCustomerModel : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSNumber * logoId;
@property (nonatomic, retain) NSData * logoImage;
@property (nonatomic, retain) NSString * manager;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * timezoneId;
@property (nonatomic, retain) NSOrderedSet *administrators;
@property (nonatomic, retain) REMManagedUserModel *user;
@end

@interface REMManagedCustomerModel (CoreDataGeneratedAccessors)

- (void)insertObject:(REMManagedAdministratorModel *)value inAdministratorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAdministratorsAtIndex:(NSUInteger)idx;
- (void)insertAdministrators:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAdministratorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAdministratorsAtIndex:(NSUInteger)idx withObject:(REMManagedAdministratorModel *)value;
- (void)replaceAdministratorsAtIndexes:(NSIndexSet *)indexes withAdministrators:(NSArray *)values;
- (void)addAdministratorsObject:(REMManagedAdministratorModel *)value;
- (void)removeAdministratorsObject:(REMManagedAdministratorModel *)value;
- (void)addAdministrators:(NSOrderedSet *)values;
- (void)removeAdministrators:(NSOrderedSet *)values;
@end
