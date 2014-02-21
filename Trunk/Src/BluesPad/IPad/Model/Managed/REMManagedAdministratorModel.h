//
//  REMManagedAdministratorModel.h
//  Blues
//
//  Created by tantan on 2/20/14.
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
