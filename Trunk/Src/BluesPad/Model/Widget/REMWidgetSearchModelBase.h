//
//  REMWidgetSearchModelBase.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMTimeRange.h"


@protocol REMWidgetSearchModelInterface <NSObject>

- (NSDictionary *)toSearchParam;

- (void) setModelBySearchParam:(NSDictionary *)param;

@end

@interface REMWidgetSearchModelBase : NSObject<REMWidgetSearchModelInterface,NSCopying>

@property (nonatomic,strong) NSArray *timeRangeArray;

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param;

- (void) setTimeRangeItem:(REMTimeRange *)range AtIndex:(NSUInteger)index;

- (NSArray *)timeRangeToDictionaryArray;


-(NSArray *)timeRangeToModelArray:(NSArray *)array;





@end
