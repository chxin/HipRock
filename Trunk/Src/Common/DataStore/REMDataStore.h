//
//  REMDataStore.h
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMDataStoreType.h"


@interface REMDataStore : NSObject


@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong, readonly) NSString *url;
@property (nonatomic,strong) id parameter;
@property (nonatomic,readonly) REMServiceResponseType responseType;
//@property (nonatomic,strong) UIView* maskContainer;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSDictionary *messageMap;
@property (nonatomic) BOOL isAccessCache;
@property (nonatomic) BOOL isDisableAlert;
@property (nonatomic,weak) REMDataStore *parentStore;

@end
