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
@property (nonatomic, readonly, strong) NSArray* series;
-(id)initWithContext:(DCContext*)context series:(NSArray*)series;
@end
