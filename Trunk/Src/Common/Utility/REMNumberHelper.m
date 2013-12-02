/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMNumberHelper.m
 * Date Created : tantan on 12/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMNumberHelper.h"

@implementation REMNumberHelper

+ (NSString *)formatStringWithThousandSep:(NSNumber *)number withRoundDigit:(NSUInteger)digit
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:digit];
    if(digit==0){
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    }
    
    NSString *theString = [numberFormatter stringFromNumber:number];
    
    return theString;
}

@end
