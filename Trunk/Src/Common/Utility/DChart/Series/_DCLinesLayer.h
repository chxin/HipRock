//
//  _DCLineLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCSeriesLayer.h"
#import "DCContext.h"
#import "_DCLineSymbolsLayer.h"
#import "_DCLine.h"

extern NSUInteger const kDCLineLayerCells;

@interface _DCLinesLayer : _DCSeriesLayer
-(NSArray*)getSymbols;
-(NSArray*)getLines;
//@property (nonatomic, weak) _DCLineSymbolsLayer* symbolsLayer;
@end

