//
//  REMBuildingTrendView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/8/13.
//
//

#import "REMBuildingTrendView.h"

@implementation REMBuildingTrendView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    const int buttonHeight = 30;
    const int buttonWidth = 50;
    const int buttonMargin = 5;
    if (self) {
        self.todayButton = [self makeButton:@"今天" rect:CGRectMake(0, 0, buttonWidth,buttonHeight)];
        self.yestodayButton = [self makeButton:@"昨天" rect:CGRectMake(buttonMargin + buttonWidth,0,buttonWidth,buttonHeight)];
        self.thisMonthButton = [self makeButton:@"本月" rect:CGRectMake((buttonMargin + buttonWidth)*2,0,buttonWidth,buttonHeight)];
        self.lastMonthButton = [self makeButton:@"上月" rect:CGRectMake((buttonMargin + buttonWidth)*3,0,buttonWidth,buttonHeight)];
        self.thisYearButton = [self makeButton:@"今年" rect:CGRectMake((buttonMargin + buttonWidth)*4,0,buttonWidth,buttonHeight)];
        self.lastYearButton = [self makeButton:@"去年" rect:CGRectMake((buttonMargin + buttonWidth)*5,0,buttonWidth,buttonHeight)];
        
        
        
    }
    return self;
}

- (UIButton*) makeButton:(NSString*)buttonText rect:(CGRect)rect{
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [btn setFrame:rect];
    [btn setTitle:buttonText forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    return btn;
}

- (void)intervalChanged:(UIButton *)button {
    NSLog(@"bbbb");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
