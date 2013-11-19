/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetSearchModelBase.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMTimeRange.h"


@protocol REMWidgetSearchModelInterface <NSObject>

- (NSDictionary *)toSearchParam;

- (void) setModelBySearchParam:(NSDictionary *)param;

@end

@interface REMWidgetSearchModelBase : NSObject<REMWidgetSearchModelInterface,NSCopying>

@property (nonatomic,strong) NSArray *timeRangeArray;

@property (nonatomic,strong) NSString *relativeDateComponent;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param;

- (void) setTimeRangeItem:(REMTimeRange *)range AtIndex:(NSUInteger)index;

- (NSArray *)timeRangeToDictionaryArray;


-(NSArray *)timeRangeToModelArray:(NSArray *)array;





@end
