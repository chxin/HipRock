//
//  REMUser.h
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONObject.h"

@interface REMUserModel : REMJSONObject

@property (nonatomic) long long userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *customers;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *realname;
@property (nonatomic,strong) NSString *telephone;
@property (nonatomic) NSInteger title;
@property (nonatomic,strong) NSString *userTypeName;
@property (nonatomic,strong) NSNumber *version;
@property (nonatomic) long long spId;


- (void)save;
- (void)kill;
+ (REMUserModel *)getCached;

@end
