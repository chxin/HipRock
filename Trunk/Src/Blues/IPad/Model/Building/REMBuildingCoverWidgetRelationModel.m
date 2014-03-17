///*------------------------------Summary-------------------------------------
// * Product Name : EMOP iOS Application Software
// * File Name	: REMBuildingCoverWidgetRelationModel.m
// * Date Created : tantan on 12/27/13.
// * Description  : IOS Application software based on Energy Management Open Platform
// * Copyright    : Schneider Electric (China) Co., Ltd.
//--------------------------------------------------------------------------*/
//#import "REMBuildingCoverWidgetRelationModel.h"
//
//@implementation REMBuildingCoverWidgetRelationModel
//
//- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
//{
//    self.commodityId = dictionary[@"CommodityId"];
//    self.buildingId = dictionary[@"HierarchyId"];
//    self.widgetId = dictionary[@"WidgetId"];
//    self.dashboardId = dictionary[@"DashboardId"];
//    NSNumber *position = dictionary[@"Position"];
//    if ([position integerValue]==0) {
//        self.position=REMBuildingCoverWidgetPositionFirst;
//    }
//    else{
//        self.position=REMBuildingCoverWidgetPositionSecond;
//    }
//}
//
//- (NSDictionary *)updateInnerDictionary{
//    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//    dic[@"CommodityId"] = [self.commodityId copy];
//    dic[@"HierarchyId"] = [self.buildingId copy];
//    dic[@"WidgetId"] = [self.widgetId copy];
//    dic[@"DashboardId"] = [self.dashboardId copy];
//    dic[@"Position"] = @((int)self.position);
//    return dic;
//}
//
//@end
