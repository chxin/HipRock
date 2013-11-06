/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMJSONObject.h
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
