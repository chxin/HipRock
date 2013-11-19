//
//  _DCLayerTrashbox.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import <Foundation/Foundation.h>

@interface _DCLayerTrashbox : NSObject
@property (nonatomic, strong) NSMutableArray* trashLayerBox;
@property (nonatomic, strong) NSMutableDictionary* xToLayerDic;
//@property (nonatomic, assign) NSUInteger trashBoxSize;

-(void)clearTrashBox;
-(void)moveLayerToTrashBox:(CALayer*)layer;
-(CALayer*)popLayerFromTrashBox;

-(BOOL)isFrame:(CGRect)rect visableIn:(CGRect)outter;
@end
