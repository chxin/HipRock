/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPopNote.m
 * Date Created : 张 锋 on 1/22/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPopNote.h"
#import "REMBuildingConstants.h"

@implementation REMPopNote

CGFloat height=45;
CGFloat bottom=10;
CGFloat margin=50;

- (id)initWithText:(NSString *)text
{
    //UIFont *font = [UIFont fontWithName:@(kBuildingFontSC) size:20];
    UIFont *font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:20];
    CGSize size = [text sizeWithFont:font];
    
    UIImage *backgroundImage = [REMIMG_PopNote resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9) resizingMode:UIImageResizingModeTile];
    
    self = [super initWithImage:backgroundImage];
    if (self) {
        // Initialization code
        self.frame = CGRectMake((kDMScreenWidth-(size.width+margin))/2, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight), size.width+margin, height);
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        
        label.text = text;
        label.font = font;
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        
        [self addSubview:label];
    }
    return self;
}

-(void)show:(void (^)(void))complete
{
    [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-height-bottom, self.frame.size.width,self.frame.size.height)];
    }completion: ^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+height+bottom, self.frame.size.width,self.frame.size.height)];
        }completion:^(BOOL finished){
            if(complete)
                complete();
        }];
    }];
}

@end
