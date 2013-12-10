/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMNumberHelper.h
 * Date Created : tantan on 12/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface REMNumberHelper : NSObject

+ (NSString *) formatStringWithThousandSep:(NSNumber *)number withRoundDigit:(NSUInteger)digit withIsRound:(BOOL)isRound;
+(NSString *)formatDataValueWithCarry:(NSNumber *)number;
@end
