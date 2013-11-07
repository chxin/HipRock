/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMultiTimespanDelegator.m
 * Date Created : tantan on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetMultiTimespanDelegator.h"
#import "REMEnergyMultiTimeSearcher.h"



@implementation REMWidgetMultiTimespanDelegator



- (void)changeStep:(REMEnergyStep)newStep
{
    [super changeStep:newStep];
    REMEnergyMultiTimeSearcher *searcher=(REMEnergyMultiTimeSearcher *)self.searcher;
    searcher.step=newStep;
}

@end
