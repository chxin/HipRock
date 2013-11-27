//
//  _DCLineSymbolsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCLayer.h"

@interface _DCLineSymbolsLayer : _DCLayer
@property (nonatomic, assign) CGFloat symbolLineWidth;
@property (nonatomic, assign) DCLineType symbolLineStyle;
@property (nonatomic, strong) UIColor* symbolLineColor;
-(void)drawSymbolsForPoints:(NSArray*)points symbolLineAt:(NSNumber*)symbolLineX inSize:(CGSize)plotSize;
@end
