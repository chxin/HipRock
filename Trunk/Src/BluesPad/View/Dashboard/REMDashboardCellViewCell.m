//
//  REMDashboardCellViewCell.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCellViewCell.h"
#import "REMEnergyViewData.h"

@interface REMDashboardCellViewCell()

@property (nonatomic,weak) REMDashboardObj *dashboardInfo;

@property (nonatomic,strong) REMWidgetCollectionViewController *collectionController;

@end

@implementation REMDashboardCellViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
        //self.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
        //self.layer.cornerRadius=0;
        //self.layer.borderColor=[UIColor yellowColor].CGColor;
        //self.layer.borderWidth=1;
        self.contentMode=UIViewContentModeScaleToFill;
        self.contentView.backgroundColor=self.backgroundColor;
        self.backgroundView=[[UIView alloc]initWithFrame:self.contentView.frame];
        self.accessoryView=nil;
        //self.contentView.layer.borderWidth=1;
        //self.contentView.layer.borderColor=[UIColor redColor].CGColor;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(
                                        0,
                                        self.contentView.frame.origin.y,
                                        self.frame.size.width,
                                        self.contentView.frame.size.height
                                        );
}


- (void)initWidgetCollection:(REMDashboardObj *)dashboardInfo
{
    
    //NSLog(@"contentview:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"cellview:%@",NSStringFromCGRect(self.frame));
    
    
    
    CGRect frame=self.contentView.frame;
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width, 35)];
    title.text=dashboardInfo.name;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    [self.contentView addSubview:title];
    
    
    //NSLog(@"splitbar:%@",NSStringFromCGRect(frame));
    CGRect frame1 = CGRectMake(10, title.frame.size.height+5, frame.size.width-10*2, 2);
    
    CALayer *layer1 = [CALayer layer];
    
    layer1.frame=frame1;
    layer1.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.25].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame1.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [layer1 renderInContext:c];
    
    
    
    UIGraphicsEndImageContext();
    
    
    [self.contentView.layer insertSublayer:layer1 above:self.contentView.layer];
    
    
    UICollectionViewFlowLayout *flowlayout =[[UICollectionViewFlowLayout alloc]init];
    REMWidgetCollectionViewController *controller = [[REMWidgetCollectionViewController alloc]initWithCollectionViewLayout:flowlayout];
    self.collectionController=controller;
    self.collectionController.widgetArray=dashboardInfo.widgets;
    self.collectionController.viewFrame=CGRectMake(10, frame1.origin.y+5, self.contentView.frame.size.width-10*2, self.contentView.frame.size.height-45);
    [self.contentView addSubview: self.collectionController.collectionView];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
