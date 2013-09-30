//
//  REMDashboardCellViewCell.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCellViewCell.h"
#import "REMTrendChart.h"
#import "REMEnergyViewData.h"
#import "REMLineWidget.h"

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
        self.backgroundColor=[UIColor whiteColor];
        //self.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
        //self.layer.cornerRadius=0;
        //self.layer.borderColor=[UIColor yellowColor].CGColor;
        //self.layer.borderWidth=1;
        self.contentMode=UIViewContentModeScaleToFill;
        self.contentView.backgroundColor=[UIColor whiteColor];
        //self.contentView.layer.borderWidth=1;
        //self.contentView.layer.borderColor=[UIColor redColor].CGColor;
       
        
        
        
        REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
        syntax.type = @"line";
        syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];
        
        REMEnergyViewData* energyViewData = [[REMEnergyViewData alloc]init];
        NSMutableArray* sereis = [[NSMutableArray alloc]init];
        for (int sIndex = 0; sIndex < 3; sIndex++) {
            NSMutableArray* energyDataArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < 100; i++) {
                REMEnergyData* data = [[REMEnergyData alloc]init];
                data.quality = REMEnergyDataQualityGood;
                data.dataValue = [NSNumber numberWithInt:i*10*sIndex];
                data.localTime = [NSDate dateWithTimeIntervalSince1970:i*3600];
                [energyDataArray addObject:data];
            }
            REMTargetEnergyData* sData = [[REMTargetEnergyData alloc]init];
            sData.energyData = energyDataArray;
            [sereis addObject:sData];
        }
        energyViewData.targetEnergyData = sereis;
        
        REMLineWidget* lineWidget = [[REMLineWidget alloc]initWithFrame:self.contentView.bounds data:energyViewData widgetContext:syntax];
        
        [self.contentView addSubview:lineWidget.view];
        [lineWidget destroyView];
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
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width, 50)];
    title.text=dashboardInfo.name;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor blackColor];
    [self.contentView addSubview:title];
    
    
    //NSLog(@"splitbar:%@",NSStringFromCGRect(frame));
    CGRect frame1 = CGRectMake(10, 55, frame.size.width-10*2, 2);
    
    CALayer *layer1 = [CALayer layer];
    
    layer1.frame=frame1;
    layer1.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.25].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame1.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [layer1 renderInContext:c];
    
    
    
    UIGraphicsEndImageContext();
    
    
    [self.contentView.layer insertSublayer:layer1 above:self.contentView.layer];
    
    
    UICollectionViewFlowLayout *flowlayout =[[UICollectionViewFlowLayout alloc]init];
    REMWidgetCollectionViewController *controller = [[REMWidgetCollectionViewController alloc]initWithCollectionViewLayout:flowlayout];
    self.collectionController=controller;
    self.collectionController.widgetArray=dashboardInfo.widgets;
    self.collectionController.viewFrame=CGRectMake(10, 70, self.contentView.frame.size.width-10*2, self.contentView.frame.size.height-70);
    [self.contentView addSubview: self.collectionController.collectionView];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
