//
//  DCMagicLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/14/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_DCLayer.h"

@interface _DCMagicLayer : _DCLayer
@property (nonatomic, strong) NSMutableArray* trashLayerBox;
@property (nonatomic, strong) NSMutableDictionary* xToLayerDic;
@property (nonatomic, assign) NSUInteger trashBoxSize;

-(void)clearTrashBox;
-(void)moveLayerToTrashBox:(CALayer*)layer;
-(CALayer*)popLayerFromTrashBox;

-(BOOL)isVisableInMyFrame:(CGRect)rect;

@end
