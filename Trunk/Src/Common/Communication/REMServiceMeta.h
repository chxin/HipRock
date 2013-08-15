//
//  REMServiceMeta.h
//  Blues
//
//  Created by 张 锋 on 8/13/13.
//
//

#import <Foundation/Foundation.h>

typedef enum _REMServiceResponseType
{
    REMServiceResponseJson,
    REMServiceResponseImage,
} REMServiceResponseType;

@interface REMServiceMeta : NSObject

-(REMServiceMeta *)initWithRelativeUrl:(NSString *)relativeUrl andResponseType:(REMServiceResponseType)responseType;

@property (nonatomic) REMServiceResponseType responseType;
@property (nonatomic,strong) NSString* url;

@end
