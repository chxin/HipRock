//
//  REMBusinessError.h
//  Blues
//
//  Created by 张 锋 on 9/5/13.
//
//

#import "REMJSONObject.h"

@interface REMBusinessErrorInfo : REMJSONObject

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSArray *messages;

@end
