/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginTitledCard.m
 * Date Created : 张 锋 on 11/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginTitledCard.h"
#import "REMCommonHeaders.h"

@interface REMLoginTitledCard ()

@property (nonatomic,weak) UIView *titleView;

@end

@implementation REMLoginTitledCard

- (id)initWithTitle:(NSString *)title andContentView:(UIView *)contentView
{
    UIView *titleView = [self renderTitleView:title];
    UIView *superContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDMLogin_CardContentWidth, kDMLogin_CardContentHeight)];
    [superContentView addSubview:titleView];
    contentView.frame = CGRectMake(0, kDMLogin_CardTitleViewHeight, kDMLogin_CardContentWidth, kDMLogin_CardContentHeight-kDMLogin_CardTitleViewHeight);
    [superContentView addSubview:contentView];
    
    self = [super initWithContentView:superContentView];
    if (self) {
        // Initialization code
    }
    return self;
}


-(UIView *)renderTitleView:(NSString *)title
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDMLogin_CardContentWidth, kDMLogin_CardTitleViewHeight)];
    
    
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDMLogin_CardContentWidth, kDMLogin_CardTitleBackgroundHeight)];
    titleBackground.backgroundColor = [REMColor colorByHexString:kDMLogin_CardTitleBackgroundColor];
    
    UIView *titleSeperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleBackground.frame.size.height, kDMLogin_CardContentWidth, kDMLogin_CardTitleBackgroundSeperatorHeight)];
    titleBackground.backgroundColor = [REMColor colorByHexString:kDMLogin_CardTitleBackgroundSeperatorColor];
    
    NSString *titleText = title;//REMLocalizedString(@"Login_TrialCardTitle");
    UIFont *titleFont = [REMFont defaultFontOfSize:24];
    CGSize titleLabelSize = [titleText sizeWithFont:titleFont];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDMLogin_CardContentWidth-titleLabelSize.width)/2, (kDMLogin_CardTitleBackgroundHeight-titleLabelSize.height)/2, titleLabelSize.width, titleLabelSize.height)];
    titleLabel.text = titleText;
    titleLabel.font = titleFont;
    titleLabel.textColor = [REMColor colorByHexString:kDMLogin_CardTitleFontColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [titleView addSubview:titleBackground];
    [titleView addSubview:titleSeperateLine];
    [titleView addSubview:titleLabel];
    
    return titleView;
}

@end
