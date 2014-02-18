//
//  REMManagedAdministratorModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedCustomerModel;

@interface REMManagedAdministratorModel : REMManagedModel

@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) REMManagedCustomerModel *customer;

@end
