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

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *titleLabel;

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
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        self.clipsToBounds = YES;
        
        
        if(self.button == nil){
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button.frame = CGRectMake(0, 0, 220, 150);
            UIImage *defaultImage = [UIImage imageNamed:@"DefaultBuilding-Small.png"];
            [self.button setImage:defaultImage forState:UIControlStateNormal];
            [self.button setImage:defaultImage forState:UIControlStateHighlighted];
            [self.button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:self.button];
        }
        
        if(self.titleLabel == nil){
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 210, 16)];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            
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
    _backgroundImage = image;
    
    [self.button setImage:_backgroundImage forState:UIControlStateNormal];
    [self.button setImage:_backgroundImage forState:UIControlStateHighlighted];
}

-(void)tapped
{
    [self.controller gallaryCellTapped:self];
}

@end
