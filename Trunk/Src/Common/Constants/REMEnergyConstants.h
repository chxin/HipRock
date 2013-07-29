//
//  REMEnergyConstants.h
//  Blues
//
//  Created by 谭 坦 on 7/18/13.
//
//

#import <Foundation/Foundation.h>


const static long REMDAY = 24*3600;
const static long REMWEEK = REMDAY*7;
const static long REMMONTH = REMDAY*31;
const static long REMYEAR = REMDAY*366;




@interface REMEnergyConstants : NSObject

+ (NSDictionary *) sharedRelativeDateDictionary;

@end
