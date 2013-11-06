/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMYFormatter.m
 * Created      : Zilong-Oscar.Xu on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMYFormatter {
    NSNumberFormatter *numberFormatter;
}
-(REMYFormatter*)init {
    self = [super init];
    if (self) {
        self.yScale = @(1);
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}
-(NSString *)formatNumber:(NSNumber *)number withMinDigits:(int) minDigits andMaxDigits:(int)maxDigits
{
    [numberFormatter setMinimumFractionDigits:minDigits];
    [numberFormatter setMaximumFractionDigits:maxDigits];
    return [numberFormatter stringFromNumber:number];
}
- (NSString *)stringForObjectValue:(id)obj {
    NSNumber* number = (NSNumber*)obj;
    double numberValue = number.doubleValue * self.yScale.doubleValue;
    number = [NSNumber numberWithDouble:numberValue];
    
    if(numberValue == 0){
        return @"0";
    }
    if(numberValue < 1000){
        return [self formatNumber:number withMinDigits:2 andMaxDigits:2];
    }
    if(numberValue < 1000000){
        return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
    }
    if(numberValue < 100000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@k", text];
    }
    if(numberValue < 100000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@M", text];
    }
    if(numberValue < 100000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@G", text];
    }
    if(numberValue < 100000000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@T", text];
    }
    
    return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
}
@end
