//
//  REMJSONObject.h
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONHelper.h"

@interface REMJSONObject : NSObject

- (id) initWithJSONString:(NSString *)jsonString;

- (id) initWithDictionary:(NSDictionary *)dictionary;

- (void) assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary;


@end
