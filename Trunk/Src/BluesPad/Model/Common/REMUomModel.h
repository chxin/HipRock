//
//  REMUomModel.h
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

@interface REMUomModel : REMJSONObject

@property (nonatomic,strong) NSNumber *uomId;
@property (nonatomic,strong) NSString *name,*code,*comment;


@end
