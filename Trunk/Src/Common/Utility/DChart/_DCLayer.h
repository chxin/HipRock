//
//  DCLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DCContext.h"

@protocol DCLabelLayerProtocal <NSObject>

-(void)relabel;

@end

@protocol DCHorizentalLayerProtocal <NSObject>

-(void)moveHorizental;

@end


@interface _DCLayer : CALayer

@property (nonatomic, weak) DCContext* graphContext;

-(id)initWithContext:(DCContext*)context;

@end
