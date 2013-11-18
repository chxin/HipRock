//
//  DCMagicLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/14/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCMagicLayer.h"

@implementation _DCMagicLayer
-(id)init {
    self = [super init];
    if (self) {
        _xToLayerDic = [[NSMutableDictionary alloc]init];
        _trashLayerBox = [[NSMutableArray alloc]init];
        _trashBoxSize = 1;
    }
    return self;
}

-(void)clearTrashBox {
    while (self.trashLayerBox.count > self.trashBoxSize) {
        CALayer* trashLayer = self.trashLayerBox[self.trashLayerBox.count-1];
        [trashLayer removeFromSuperlayer];
        [self.trashLayerBox removeObject:trashLayer];
    }
}
-(void)moveLayerToTrashBox:(CALayer*)layer {
    [self.trashLayerBox addObject:layer];
    layer.hidden = YES;
}
-(CALayer*)popLayerFromTrashBox {
    CALayer* layer = nil;
    if (self.trashLayerBox.count > 0) {
        layer = self.trashLayerBox[self.trashLayerBox.count-1];
        layer.hidden = NO;
        [self.trashLayerBox removeObject:layer];
    }
    return layer;
}
-(void)removeFromSuperlayer {
    [self.xToLayerDic removeAllObjects];
    [self.trashLayerBox removeAllObjects];
    [super removeFromSuperlayer];
}

-(BOOL)isVisableInMyFrame:(CGRect)rect {
    if (rect.origin.x >= self.bounds.size.width || rect.origin.y >= self.bounds.size.height
        || rect.origin.x+rect.size.width <= 0 || rect.origin.y+rect.size.height<=0) return NO;
    return YES;
}
@end
