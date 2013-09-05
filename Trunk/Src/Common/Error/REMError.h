//
//  REMError.h
//  Blues
//
//  Created by 张 锋 on 9/5/13.
//
//

#import <Foundation/Foundation.h>
#import "REMBusinessErrorInfo.h"

@interface REMError : NSError

-(REMError *)initWithErrorInfo:(REMBusinessErrorInfo *)errorInfo;

@property (nonatomic,strong) REMBusinessErrorInfo *errorInfo;

@end
