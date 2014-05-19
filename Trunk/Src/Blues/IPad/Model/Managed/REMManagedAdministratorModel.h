//
//  REMManagedAdministratorModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedCustomerModel;

@interface REMManagedAdministratorModel : NSManagedObject

@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) REMManagedCustomerModel *customer;

@end
