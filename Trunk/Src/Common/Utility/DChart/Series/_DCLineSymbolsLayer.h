//
//  _DCLineSymbolsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCLayer.h"

@interface _DCLineSymbolsLayer : _DCLayer
-(void)drawSymbolsForPoints:(NSArray*)points inSize:(CGSize)plotSize;
@end
