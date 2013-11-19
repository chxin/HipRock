/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginCard.m
 * Date Created : 张 锋 on 11/19/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginCard.h"

@interface REMLoginCard()

@property (nonatomic,weak) UIView *backgroundView;

@end

@implementation REMLoginCard

- (id)initWithContentView:(UIView *)contentView
{
    self = [super initWithFrame:kDMDefaultViewFrame];
    if (self) {
        // Initialization code
        [self renderBackground];
        
        contentView.frame = CGRectMake(kDMLogin_CardContentLeftOffset, kDMLogin_CardContentTopOffset, kDMLogin_CardContentWidth, kDMLogin_CardContentHeight);
        
        [self.backgroundView addSubview:contentView];
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

-(void)renderBackground
{
    UIImage *backgroundImage = [REMIMG_SlidePageBackground resizableImageWithCapInsets:UIEdgeInsetsMake(9,21,26,21)];
    
    CGRect backgroundFrame = CGRectMake((kDMScreenWidth - kDMLogin_CardWidth) / 2, kDMLogin_CardTopOffset, kDMLogin_CardWidth, kDMLogin_CardHeight);
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:backgroundFrame];
    [backgroundView setImage:backgroundImage];
    [backgroundView setUserInteractionEnabled:YES];
    
    [self addSubview: backgroundView];
    self.backgroundView = backgroundView;
}

@end
