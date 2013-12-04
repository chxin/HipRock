//
//  _DCLineSymbolsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCLayer.h"
#import "_DCLine.h"

@interface _DCLineSymbolsLayer : _DCLayer
-(void)drawSymbolsForPoints:(NSArray*)points lines:(NSArray*)lines inSize:(CGSize)plotSize;
@end
