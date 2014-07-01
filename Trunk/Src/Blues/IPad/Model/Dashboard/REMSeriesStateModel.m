/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSeriesStateModel.m
 * Date Created : 张 锋 on 7/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSeriesStateModel.h"


@implementation REMSeriesStateModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.key = dictionary[@"seriesKey"];
    self.availableType = [dictionary[@"availableType"] shortValue];
    self.type = (REMWidgetSeriesType)[dictionary[@"type"] shortValue];
    self.suppressible = [dictionary[@"suppressible"] boolValue];
    self.visible = [dictionary[@"visible"] boolValue];
}

@end
