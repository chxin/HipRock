//
//  _DCLayerTrashbox.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLayerTrashbox.h"
#import <QuartzCore/QuartzCore.h>
@implementation _DCLayerTrashbox

-(id)init {
    self = [super init];
    if (self) {
        _xToLayerDic = [[NSMutableDictionary alloc]init];
        _trashLayerBox = [[NSMutableArray alloc]init];
//        _trashBoxSize = 1;
    }
    return self;
}

//-(void)clearTrashBox {
//    while (self.trashLayerBox.count > self.trashBoxSize) {
//        CALayer* trashLayer = self.trashLayerBox[self.trashLayerBox.count-1];
//        [trashLayer removeFromSuperlayer];
//        [self.trashLayerBox removeObject:trashLayer];
//    }
//}
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

-(void)clearTrashBox {
    [self.xToLayerDic removeAllObjects];
    [self.trashLayerBox removeAllObjects];
}
@end
