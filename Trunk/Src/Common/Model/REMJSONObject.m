//
//  REMJSONObject.m
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMJSONHelper.h"

@interface REMJSONObject()

@property (nonatomic,strong) NSDictionary *innerDictionary;

@end

@implementation REMJSONObject

- (id)initWithJSONString:(NSString *)jsonString
{
    
    NSDictionary *dic=[REMJSONHelper dictionaryByJSONString:jsonString];
    
    return [self initWithDictionary:dic];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        
        self.innerDictionary=dictionary;
        
        if(dictionary == nil || [dictionary isEqual:[NSNull null]])
        {
            self = nil;
        }
        else
        {
            [self assembleCustomizedObjectByDictionary:dictionary];
        }
    }
    
    return self;
}

- (id)valueForKey:(NSString *)key
{
    id value=[self.innerDictionary objectForKey:key];
    if(value){
        return value;
    }
    else{
        return [super valueForKey:key];
    }
}


- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    
}

- (NSString *)serialize
{
    return [REMJSONHelper stringByDictionary:self.innerDictionary];
}

@end
