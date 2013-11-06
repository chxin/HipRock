/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetSearchModelBase.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnum.h"


@protocol REMWidgetSearchModelInterface <NSObject>

- (NSDictionary *)toSearchParam;

- (void) setModelBySearchParam:(NSDictionary *)param;

@end

@interface REMWidgetSearchModelBase : NSObject<REMWidgetSearchModelInterface>

@property (nonatomic,strong) NSArray *timeRangeArray;

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param;

- (NSNumber *)stepNumberByStep:(REMEnergyStep)stepType;

- (REMEnergyStep)stepTypeByNumber:(NSNumber *)stepNumber;

@end
