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

- (id)initWithText:(NSString *)text
{
    CGFloat height=40;
    CGFloat margin=50;
    
    UIFont *font = [UIFont fontWithName:@(kBuildingFontSC) size:20];
    CGSize size = [text sizeWithFont:font];
    
    self = [super initWithFrame:CGRectMake((kDMScreenWidth-(size.width+margin))/2, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight), size.width+margin, height)];
    if (self) {
        // Initialization code
        self.text = text;
        self.font = font;
        self.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor redColor];//[UIColor colorWithPatternImage:[REMIMG_PopNote resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)]];
    }
    return self;
}

-(void)show:(void (^)(void))complete
{
    CGFloat height=40;
    CGFloat bottom=10;
    
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
