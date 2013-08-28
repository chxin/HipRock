//
//  REMIndicatorButton.h
//  Blues
//
//  Created by 张 锋 on 8/5/13.
//
//


@interface REMIndicatorButton : UIButton

//true for loading, false for not loading
@property (nonatomic,readonly) BOOL indicatorStatus;
@property (nonatomic,strong) NSString *loadingText;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

-(void)startIndicator;
-(void)stopIndicator;
-(void)setTitleForAllStatus:(NSString *)title;

@end
