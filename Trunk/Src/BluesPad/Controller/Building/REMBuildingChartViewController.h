/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartViewController.h
 * Date Created : tantan on 11/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMBuildingCommodityViewController.h"


@interface REMBuildingChartViewController : UIViewController

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) Class chartHandlerClass;
@property (nonatomic,weak) NSNumber *buildingId;
@property (nonatomic,weak) NSNumber *commodityId;

@end
