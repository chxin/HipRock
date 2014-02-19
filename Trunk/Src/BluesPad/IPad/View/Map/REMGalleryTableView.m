/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryTableView.m
 * Date Created : 张 锋 on 12/6/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMGalleryTableView.h"
#import "REMGalleryCollectionCell.h"

@implementation REMGalleryTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if(self){
        self.panGestureRecognizer.delegate = self;
    }
    
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"touches:%d, view:%@", gestureRecognizer.numberOfTouches, [gestureRecognizer.view class]);
    
    if(gestureRecognizer.numberOfTouches > 1)
        return NO;
    if([gestureRecognizer.view isKindOfClass:[REMGalleryCollectionCell class]])
        return NO;
    
    return YES;
}

@end
