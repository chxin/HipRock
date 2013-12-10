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
    
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    
    NSString *theString = [numberFormatter stringFromNumber:number];
    
    return theString;
}



+(NSString *)formatDataValueWithCarry:(NSNumber *)number
{
    if (number == nil || [number isEqual:[NSNull null]]==YES) {
        return @"";
    }
    
    double numberValue = [number doubleValue];
    
    if(numberValue == 0){
        return @"0";
    }
    if(numberValue < 1000){
        return [REMNumberHelper formatStringWithThousandSep:number withRoundDigit:10];
    }
    if(numberValue < 1000000){
        return [REMNumberHelper formatStringWithThousandSep:number withRoundDigit:0];
    }
    if(numberValue < 100000000){
        NSString *text = [REMNumberHelper formatStringWithThousandSep:[NSNumber numberWithDouble:numberValue/1000] withRoundDigit:0];
        return [NSString stringWithFormat:@"%@k", text];
    }
    if(numberValue < 100000000000){
        NSString *text = [REMNumberHelper formatStringWithThousandSep:[NSNumber numberWithDouble:numberValue/1000000] withRoundDigit:0];
        return [NSString stringWithFormat:@"%@M", text];
    }
    if(numberValue < 100000000000000){
        NSString *text = [REMNumberHelper formatStringWithThousandSep:[NSNumber numberWithDouble:numberValue/1000000000] withRoundDigit:0];
        return [NSString stringWithFormat:@"%@G", text];
    }
    if(numberValue < 100000000000000000){
        NSString *text = [REMNumberHelper formatStringWithThousandSep:[NSNumber numberWithDouble:numberValue/1000000000000] withRoundDigit:0];
        return [NSString stringWithFormat:@"%@T", text];
    }
    
    return [REMNumberHelper formatStringWithThousandSep:number withRoundDigit:0];

}

@end
