//
//  REMWidgetBizDelegatorBase.m
//  Blues
//
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetEnergyDelegator.h"

@implementation REMWidgetBizDelegatorBase

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMWidgetBizDelegatorBase *base=[[REMWidgetEnergyDelegator alloc]init];
    
    
    return base;
}

@end
