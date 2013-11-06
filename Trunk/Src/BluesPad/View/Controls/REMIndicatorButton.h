/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMIndicatorButton.h
 * Created      : 张 锋 on 8/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///


@interface REMIndicatorButton : UIButton

//true for loading, false for not loading
@property (nonatomic,readonly) BOOL indicatorStatus;
@property (nonatomic,strong) NSString *loadingText;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

-(void)startIndicator;
-(void)stopIndicator;
-(void)setTitleForAllStatus:(NSString *)title;

@end
