//
//  _DCXYIndicatorLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/27/13.
//
//

#import "_DCLayer.h"

@interface _DCXYIndicatorLayer : _DCLayer

@property (nonatomic, assign) CGFloat symbolLineWidth;
@property (nonatomic, assign) DCLineType symbolLineStyle;
@property (nonatomic, strong) UIColor* symbolLineColor;
@property (nonatomic, assign) CGFloat focusSymbolIndicatorSize;

@property (nonatomic, strong) NSNumber* symbolLineAt;
@end
