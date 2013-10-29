//
//  REMColor.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"



@interface REMColor : NSObject

+ (UIColor *)colorByHexString:(NSString *)hexString;

+ (CPTColor *)colorByIndex:(uint)index;

@end
