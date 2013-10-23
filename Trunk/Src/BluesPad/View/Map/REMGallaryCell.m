//
//  REMGallaryCell.m
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import "REMGallaryCell.h"
#import <QuartzCore/QuartzCore.h>

@interface REMGallaryCell()

@property (nonatomic,weak) UIButton *button;
@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation REMGallaryCell{
    REMBuildingModel *_buildingModel;
    UIImage *_backgroundImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor blackColor].CGColor;
//        self.layer.borderWidth = 1.0;
        
        self.clipsToBounds = YES;
//        
//        if(self.backgroundView == nil){
//            UIImageView *defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultBuilding-Small.png"]];
//            defaultImageView.contentMode = UIViewContentModeScaleToFill;
//            
//            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 147, 110)];
//            backgroundView.contentMode = UIViewContentModeScaleToFill;
//            self.backgroundView = backgroundView;
//            
//            [self.backgroundView addSubview:defaultImageView];
//        }
        
        if(self.button == nil){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button = button;
            self.button.frame = CGRectMake(0, 0, 147, 110);
            UIImage *defaultImage = [UIImage imageNamed:@"DefaultBuilding-Small.png"];
            [self.button setImage:defaultImage forState:UIControlStateNormal];
            [self.button setImage:defaultImage forState:UIControlStateHighlighted];
            [self.button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
            self.backgroundImage = defaultImage;
            
            [self addSubview:self.button];
        }
        
        if(self.titleLabel == nil){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 129, 10)];
            self.titleLabel = label;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont systemFontOfSize:10];
            
            [self addSubview:self.titleLabel];
        }
        
    }
    return self;
}

static UIImageView *defaultImageView;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

-(void)setBuildingModel:(REMBuildingModel *)model
{
    _buildingModel = model;
    
    self.titleLabel.text = _buildingModel.name;
}

-(REMBuildingModel *)getBuildingModel
{
    return _buildingModel;
}

-(void)setBackgroundImage:(UIImage *)image
{
    if(_backgroundImage == nil){
        [self.button setImage:image forState:UIControlStateNormal];
        [self.button setImage:image forState:UIControlStateHighlighted];
    }
    else{
        UIImageView *background = [[UIImageView alloc] initWithImage:image];
        background.frame = CGRectMake(0, 0, 147, 110);
        background.contentMode = UIViewContentModeScaleToFill;
        background.alpha = 0.1;
        
        [self.button.imageView addSubview:background];
        
        [UIView animateWithDuration:0.3 animations:^{
            background.alpha = 1;
        } completion:^(BOOL finished) {
            [background removeFromSuperview];
            [self.button setImage:image forState:UIControlStateNormal];
            [self.button setImage:image forState:UIControlStateHighlighted];
        }];
    }
    
    _backgroundImage = image;
}

-(void)tapped
{
    [self.controller gallaryCellTapped:self];
}

@end
