//
//  REMColor.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"



@interface REMColor : NSObject

+ (UIColor *)colorByHexString:(NSString *)hexString;

+ (CPTColor *)colorByIndex:(uint)index;

@end
