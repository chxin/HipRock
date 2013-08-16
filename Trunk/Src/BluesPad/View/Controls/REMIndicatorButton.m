//
//  REMIndicatorButton.m
//  Blues
//
//  Created by 张 锋 on 8/5/13.
//
//

#import "REMIndicatorButton.h"

@interface REMIndicatorButton()
@property (nonatomic) BOOL indicatorStatus;
@property (nonatomic,strong) NSString *backupTitle;

@end

@implementation REMIndicatorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)startIndicator
{
    if(self.indicator==nil)
    {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat halfButtonHeight = self.bounds.size.height / 2;
        CGFloat buttonWidth = self.bounds.size.width;
        self.indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
        [self addSubview:self.indicator];
    }
    
    [self.indicator startAnimating];
    
    [self setEnabled:NO];
    [self setTitleForAllStatus:self.loadingText];
    
    self.indicatorStatus = YES;
}

-(void)stopIndicator
{
    if(self.indicator != nil)
    {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        self.indicator = nil;
    }
    
    [self setEnabled:YES];
    [self setTitleForAllStatus:self.backupTitle];
    
    self.indicatorStatus = NO;
}

-(void)setTitleForAllStatus:(NSString *)title
{
    self.backupTitle = self.titleLabel.text;
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

@end
