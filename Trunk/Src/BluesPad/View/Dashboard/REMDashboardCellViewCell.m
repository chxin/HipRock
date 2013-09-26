//
//  REMDashboardCellViewCell.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCellViewCell.h"

@implementation REMDashboardCellViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        //self.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
        //self.layer.cornerRadius=0;
        self.contentView.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}


- (void)initWidgetCollection{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
