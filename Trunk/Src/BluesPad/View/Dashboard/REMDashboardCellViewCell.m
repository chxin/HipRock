//
//  REMDashboardCellViewCell.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCellViewCell.h"
#import "REMEnergyViewData.h"
#import "REMBuildingConstants.h"


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
        self.backgroundColor=[UIColor clearColor];
        //self.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
        //self.layer.cornerRadius=0;
        //self.layer.borderColor=[UIColor yellowColor].CGColor;
        //self.layer.borderWidth=1;
        self.contentMode=UIViewContentModeScaleToFill;
        self.contentView.backgroundColor=self.backgroundColor;
        self.backgroundView=[[UIView alloc]initWithFrame:self.contentView.frame];
        self.accessoryView=nil;
        self.contentView.layer.borderWidth=1;
        self.contentView.layer.borderColor=[UIColor redColor].CGColor;
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


- (void)initWidgetCollection:(REMDashboardObj *)dashboardInfo withGroupName:(NSString *)groupName
{
    if(self.collectionController!=nil) return;
    
    //NSLog(@"contentview:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"cellview:%@",NSStringFromCGRect(self.frame));
    CGRect frame=self.contentView.frame;
    CGRect shareFrame;
    if(dashboardInfo.shareInfo!=nil && [dashboardInfo.shareInfo isEqual:[NSNull null]]== NO && [dashboardInfo.shareInfo.userRealName isEqual:[NSNull null]]==NO){
        shareFrame = CGRectMake(0, 11, frame.size.width, 11-4);
        UILabel *shareName=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x, 11, frame.size.width, 11)];
        shareName.textColor=[UIColor whiteColor];
        shareName.text=dashboardInfo.shareInfo.userRealName;
        [self.contentView addSubview:shareName];
    }
    else{
       shareFrame = CGRectMake(0, 0, frame.size.width, 0);
    }
    
    
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x,shareFrame.origin.y+shareFrame.size.height, frame.size.width, 16)];
    title.text=dashboardInfo.name;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:14];
    [self.contentView addSubview:title];
    
    
    //NSLog(@"splitbar:%@",NSStringFromCGRect(frame));
    /*
    CGRect frame1 = CGRectMake(0, title.frame.origin.y+title.frame.size.height+7, frame.size.width, 1);
    CGRect frame2 = CGRectMake(0, frame1.origin.y+1, frame1.size.width, frame1.size.height);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CALayer *layer1 = [CALayer layer];
    
    layer1.frame=frame1;
    layer1.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.38].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame1.size, NO, 0.0);
   
    
    [layer1 renderInContext:c];
    
    CALayer *layer2=[CALayer layer];
    
    layer2.frame=frame2;
    layer2.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.1].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame2.size, NO, 0.0);
    
    
    [layer2 renderInContext:c];
    
    
    
    UIGraphicsEndImageContext();
    
    
    [self.contentView.layer insertSublayer:layer1 above:self.contentView.layer];
    [self.contentView.layer insertSublayer:layer2 above:self.contentView.layer];
    */
    
    UICollectionViewFlowLayout *flowlayout =[[UICollectionViewFlowLayout alloc]init];
    REMWidgetCollectionViewController *controller = [[REMWidgetCollectionViewController alloc]initWithCollectionViewLayout:flowlayout];
    controller.groupName=groupName;
    self.collectionController=controller;
    self.collectionController.buildingController=self.buildingController;
    self.collectionController.widgetArray=dashboardInfo.widgets;
    self.collectionController.viewFrame=CGRectMake(0, title.frame.origin.y+title.frame.size.height+14, frame.size.width, self.contentView.frame.size.height-(title.frame.origin.y+title.frame.size.height+14));
    [self.contentView addSubview: self.collectionController.collectionView];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
