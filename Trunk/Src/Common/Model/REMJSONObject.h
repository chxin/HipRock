//
//  REMJSONObject.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONHelper.h"

@interface REMJSONObject : NSObject

@property (nonatomic,strong) NSDictionary *innerDictionary;

- (id) initWithJSONString:(NSString *)jsonString;

- (id) initWithDictionary:(NSDictionary *)dictionary;

- (void) assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary;

- (NSString *)serialize;

-(NSDictionary *)updateInnerDictionary;

@end
