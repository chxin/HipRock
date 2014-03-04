/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginButton.m
 * Date Created : 张 锋 on 11/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginButton.h"


@interface REMLoginButton()

@property (nonatomic,strong) NSDictionary *statusTexts;

@end

@implementation REMLoginButton

-(id)initWithFrame:(CGRect)frame andStatusTexts:(NSDictionary *)statusTexts
{
    self = [super initWithFrame:frame];
    if (self) {
        self.statusTexts = statusTexts;
        
        UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 6.0, 0, 6.0);
        
        [self setBackgroundImage:[REMIMG_Login_Normal resizableImageWithCapInsets:imageInsets] forState:UIControlStateNormal];
        [self setBackgroundImage:[REMIMG_Login_Pressed resizableImageWithCapInsets:imageInsets] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[REMIMG_Login_Disable resizableImageWithCapInsets:imageInsets] forState:UIControlStateDisabled];
        
        [self setTitle:self.statusTexts[@(REMLoginButtonNormalStatus)] forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setLoginButtonStatus:(REMLoginButtonStatus)status
{
    [self setTitle:self.statusTexts[@(status)] forState:UIControlStateNormal];
    [self setTitle:self.statusTexts[@(status)] forState:UIControlStateDisabled];
    
    switch (status) {
        case REMLoginButtonNormalStatus:
            [super stopIndicator];
            [self setEnabled:YES];
            break;
        case REMLoginButtonWorkingStatus:
            [super startIndicator];
            [self setEnabled:NO];
            break;
        case REMLoginButtonDisableStatus:
            [super stopIndicator];
            [self setEnabled:NO];
            break;
            
        default:
            break;
    }
}

@end
