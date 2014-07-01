/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSeriesStateModel.h
 * Date Created : 张 锋 on 7/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

typedef enum _REMWidgetSeriesType : NSUInteger{
    Line = 1,
    StackedLine = 2,
    Column = 4,
    StackedColumn = 8,
} REMWidgetSeriesType;

@interface REMSeriesStateModel : REMJSONObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic) REMWidgetSeriesType type;
@property (nonatomic) NSUInteger availableType;
@property (nonatomic) BOOL suppressible, visible;

@end
