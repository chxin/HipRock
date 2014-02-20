/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginPersistenceProcessor.m
 * Date Created : tantan on 2/18/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginPersistenceProcessor.h"
#import "REMUserValidationModel.h"
@implementation REMLoginPersistenceProcessor

- (id)persistData:(NSDictionary *)data
{
    REMUserValidationStatus status = (REMUserValidationStatus)[data[@"ValidationStatus"] intValue];
    if (status!=REMUserValidationSuccess) {
        REMUserValidationModel *model= [[REMUserValidationModel alloc]init];
        model.status = status;
        return model;
    }
    else{
        return [self persistUserModel:data[@"User"]];
    }
}

- (id)persistUserModel:(NSDictionary *)user{
    return nil;
}

@end
