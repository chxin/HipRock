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

extern NSUInteger const kDCLineLayerCells;

@interface _DCLinesLayer : _DCSeriesLayer
-(void)setSymbolsHidden:(BOOL)hidden;
@property (nonatomic, weak) _DCLineSymbolsLayer* symbolsLayer;
@end
