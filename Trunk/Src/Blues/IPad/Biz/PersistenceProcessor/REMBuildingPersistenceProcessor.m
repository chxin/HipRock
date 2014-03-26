/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingPersistenceProcessor.m
 * Date Created : tantan on 2/25/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingPersistenceProcessor.h"
#import "REMManagedBuildingModel.h"
#import "REMManagedBuildingPictureModel.h"
#import "REMManagedBuildingCommodityUsageModel.h"
#import "REMManagedDashboardModel.h"
#import "REMManagedWidgetModel.h"
#import "REMManagedPinnedWidgetModel.h"
#import "REMManagedSharedModel.h"
#import "REMTimeHelper.h"
#import "REMEnum.h"
#import "REMWidgetContentSyntax.h"
#import "REMBuildingInfoUpdateModel.h"
#import "REMManagedAdministratorModel.h"


@implementation REMBuildingPersistenceProcessor

#pragma mark - DataPersistenceProcessor

- (REMBuildingInfoUpdateModel *)persist:(NSDictionary *)dictionary
{
    [self clean];
    
    //process building
    
    for (int i=0; i<[dictionary[@"BuildingInfo"] count]; ++i) {
        NSDictionary *buildingOverall =dictionary[@"BuildingInfo"][i];
        REMManagedBuildingModel *buildingModel = [self persistBuilding:buildingOverall[@"Building"]];
        buildingModel.isQualified = NULL_TO_NIL(buildingOverall[@"IsQualified"]);
        [self persistCommodity:buildingOverall[@"CommodityArray"] intoBuilding:buildingModel];
        [self persistDashboard:buildingOverall[@"DashboardList"] intoBuilding:buildingModel];
        [self persistPinnedWidget:buildingOverall[@"WidgetRelation"] intoBuilding:buildingModel];
    }
    
    //process customer
    if(!REMIsNilOrNull(dictionary[@"Customers"]) && [dictionary[@"Customers"] count] >0){
        NSArray *oldCustomers = [self fetch:[REMManagedCustomerModel class]];
        for (REMManagedCustomerModel *customer in oldCustomers) {
            [REMDataStore deleteManagedObject:customer];
        }
        
        [self persistCustomers:dictionary[@"Customers"]];
    }
    
    [self save];
    
    return [self fetch];
}

- (REMBuildingInfoUpdateModel *)fetch
{
    REMBuildingInfoUpdateModel *model = [[REMBuildingInfoUpdateModel alloc] init];
    model.buildingInfo = [self fetch:[REMManagedBuildingModel class]];
    model.customers = [self fetch:[REMManagedCustomerModel class]];
    model.status = REMCustomerUserConcurrencyStatusSuccess;
    
    return model;
}

#pragma mark - @private

-(void)clean
{
    for (REMManagedBuildingModel *building in  [self fetch:[REMManagedBuildingModel class]]) {
        [self remove:building];
    }
}


- (void)persistPinnedWidget:(NSArray *)pinnedWidgetArray intoBuilding:(REMManagedBuildingModel *)building{
    if (pinnedWidgetArray!=nil && [pinnedWidgetArray isEqual:[NSNull null]]==NO) {
        
        for (NSDictionary *relation in pinnedWidgetArray) {
            
            for (REMManagedBuildingCommodityUsageModel *commodity in [building.commodities allObjects]) {
                NSNumber *commodityId = relation[@"CommodityId"];
                if ([commodity.id isEqualToNumber:commodityId] == YES) {
                    REMManagedPinnedWidgetModel *pinnedModel = [self create:[REMManagedPinnedWidgetModel class]];
                    
                    pinnedModel.commodity = commodity;
                    pinnedModel.widgetId = relation[@"WidgetId"];
                    pinnedModel.dashboardId = relation[@"DashboardId"];
                    pinnedModel.position =relation[@"Position"];
                    
                    [commodity addPinnedWidgetsObject:pinnedModel];
                }
            }
            
            
        }
    }
}

- (void)persistDashboard:(NSArray *)dashboardArray intoBuilding:(REMManagedBuildingModel *)building{
    
    for (int i=0; i<dashboardArray.count; ++i) {
        NSDictionary *dictionary = dashboardArray[i];
        REMManagedDashboardModel *dashboard = [self create:[REMManagedDashboardModel class]];
        dashboard.id = dictionary[@"Id"];
        dashboard.name=dictionary[@"Name"];
        dashboard.isFavorite=dictionary[@"IsFavorite"];
        dashboard.isRead=dictionary[@"IsRead"];
        dashboard.building=building;
        NSArray *array = (NSArray *) dictionary[@"Widgets"];
        if (!REMIsNilOrNull(array) && array.count>0) {
            [self persistWidget:array intoDashboard:dashboard];
            
        }
        
        
        
        NSDictionary *shareInfo = dictionary[@"SimpleShareInfo"];
        
        if(!REMIsNilOrNull(shareInfo)){
            dashboard.sharedInfo = [self shareModelByDictionary:shareInfo];
            dashboard.sharedInfo.dashboard=dashboard;
        }
        [building addDashboardsObject:dashboard];
    }
    
    
}

- (REMManagedSharedModel *)shareModelByDictionary:(NSDictionary *)dictionary{
    
    REMManagedSharedModel *shareModel = [self create:[REMManagedSharedModel class]];
    
    shareModel.userRealName=dictionary[@"UserRealName"];
    
    shareModel.userTelephone=dictionary[@"UserTelephone"];
    NSString *time = dictionary[@"ShareTime"];
    long long longTime=[REMTimeHelper longLongFromJSONString:time];
    if (longTime==0) {
        shareModel.shareTime=nil;
    }
    else{
        shareModel.shareTime=[NSDate dateWithTimeIntervalSince1970:longTime/1000];
    }
    
    shareModel.userTitle=dictionary[@"UserTitle"];
    REMUserTitleType userTitle = (REMUserTitleType)[shareModel.userTitle integerValue];
    
    NSString *title;
    /*
     REMUserTitleEEConsultant = 0,
     REMUserTitleTechnician = 1,
     REMUserTitleCustomerAdmin = 2,
     REMUserTitlePlatformAdmin=3,
     REMUserTitleEnergyManager=4,
     REMUserTitleEnergyEngineer=5,
     REMUserTitleDepartmentManager=6,
     REMUserTitleCEO=7,
     REMUserTitleBusinessPersonnel=8,
     REMUserTitleSaleman=9,
     REMUserTitleServiceProviderAdmin=10
     */
    
    if (userTitle == REMUserTitleEEConsultant) {
        title=NSLocalizedString(@"Admin_UserTitleEEConsultant", @"");
    }
    else if(userTitle == REMUserTitleTechnician){
        title=NSLocalizedString(@"Admin_UserTitleTechnician", @"");
    }
    else if(userTitle == REMUserTitleCustomerAdmin){
        title=NSLocalizedString(@"Admin_UserTitleCustomerAdmin", @"");
    }
    else if(userTitle == REMUserTitlePlatformAdmin){
        title=NSLocalizedString(@"Admin_UserTitlePlatformAdmin", @"");
    }
    else if(userTitle == REMUserTitleEnergyManager){
        title=NSLocalizedString(@"Admin_UserTitleEnergyManager", @"");
    }
    else if(userTitle == REMUserTitleEnergyEngineer){
        title=NSLocalizedString(@"Admin_UserTitleEnergyEngineer", @"");
    }
    else if(userTitle == REMUserTitleDepartmentManager){
        title=NSLocalizedString(@"Admin_UserTitleDepartmentManager", @"");
    }
    else if(userTitle == REMUserTitleCEO){
        title=NSLocalizedString(@"Admin_UserTitleCEO", @"");
    }
    else if(userTitle == REMUserTitleBusinessPersonnel){
        title=NSLocalizedString(@"Admin_UserTitleBusinessPersonnel", @"");
    }
    else if(userTitle == REMUserTitleSaleman){
        title=NSLocalizedString(@"Admin_UserTitleSaleman", @"");
    }
    else if(userTitle == REMUserTitleServiceProviderAdmin){
        title=NSLocalizedString(@"Admin_UserTitleServiceProviderAdmin", @"");
    }
    shareModel.userTitleComponent=title;
    
    
    return shareModel;

}

- (void)persistWidget:(NSArray *)widgetArray intoDashboard:(REMManagedDashboardModel *)dashboard{
    for(NSDictionary *dictionary in widgetArray)
    {
        REMWidgetContentSyntax *syntax = [[REMWidgetContentSyntax alloc]initWithJSONString:dictionary[@"ContentSyntax"]];
        NSString *xtype = syntax.xtype;
        REMDiagramType diagramType = REMDiagramTypeLine;
        if([xtype isEqualToString:@"linechartcomponent"] ==YES ||
           [xtype isEqualToString:@"multitimespanlinechartcomponent"]==YES)
        {
            diagramType =REMDiagramTypeLine;
        }
        else if([xtype isEqualToString:@"columnchartcomponent"]== YES ||
                [xtype isEqualToString:@"multitimespancolumnchartcomponent"]==YES)
        {
            diagramType =REMDiagramTypeColumn;
        }
        else if([xtype rangeOfString:@"grid"].location!=NSNotFound)
        {
            diagramType =REMDiagramTypeGrid;
        }
        else if([xtype isEqualToString:@"piechartcomponent"]== YES)
        {
            diagramType =REMDiagramTypePie;
        }
        else if([xtype isEqualToString:@"rankcolumnchartcomponent"]== YES)
        {
            diagramType =REMDiagramTypeRanking;
        }
        else if([xtype isEqualToString:@"stackchartcomponent"]== YES)
        {
            diagramType =REMDiagramTypeStackColumn;
        }
        else if([xtype isEqualToString:@"labelingchartcomponent"]==YES){
            diagramType=REMDiagramTypeLabelling;
        }

        if (diagramType ==REMDiagramTypeGrid) {
            continue;
        }
        
        REMManagedWidgetModel *widget = [self create:[REMManagedWidgetModel class]];
        widget.id=dictionary[@"Id"];
        widget.name=dictionary[@"Name"];
        widget.isRead=dictionary[@"IsRead"];
        widget.contentSyntax = dictionary[@"ContentSyntax"];
        widget.diagramType=@(diagramType);
        NSDictionary *shareInfo = dictionary[@"SimpleShareInfo"];
        
        if(!REMIsNilOrNull(shareInfo)){
            widget.sharedInfo = [self shareModelByDictionary:shareInfo];
            widget.sharedInfo.widget=widget;
        }
        widget.dashboard=dashboard;
        [dashboard addWidgetsObject:widget];

    }
    

}

- (void)persistCommodity:(NSArray *)commodityArray intoBuilding:(REMManagedBuildingModel *)building{
    for (int i=0; i<commodityArray.count; ++i) {
        REMManagedBuildingCommodityUsageModel *commodity = [self create:[REMManagedBuildingCommodityUsageModel class]];
        NSDictionary *dictionary = commodityArray[i];
        commodity.id = dictionary[@"Id"];
        commodity.name = NULL_TO_NIL(dictionary[@"Name"]);
        commodity.code = dictionary[@"Code"];
        commodity.comment = dictionary[@"Comment"];
        commodity.building = building;
        [building addCommoditiesObject:commodity];
    }
}

- (REMManagedBuildingModel *)persistBuilding:(NSDictionary *)dictionary{
    REMManagedBuildingModel *building = [self create:[REMManagedBuildingModel class]];
    building.id = dictionary[@"Id"];
    building.parentId = dictionary[@"ParentId"];
    building.timezoneId = dictionary[@"TimezoneId"];
    building.name = dictionary[@"Name"];
    building.code = dictionary[@"Code"];
    building.comment =  NULL_TO_NIL(dictionary[@"Comment"]);
    building.path = NULL_TO_NIL(dictionary[@"Path"]);
    building.pathLevel = dictionary[@"PathLevel"];
    building.hasDataPrivilege = dictionary[@"HasDataPrivilege"];
    building.latitude = dictionary[@"Latitude"] ;
    building.longitude = dictionary[@"Longitude"];
    building.province = NULL_TO_NIL(dictionary[@"Province"]);
    
    NSArray *pictures=dictionary[@"PictureIds"];
    
    if (!REMIsNilOrNull(pictures) && pictures.count>0) {
        for (NSNumber *pictureId in pictures) {
            REMManagedBuildingPictureModel *picModel = [self create:[REMManagedBuildingPictureModel class]];
            picModel.id =pictureId;
            picModel.building = building;
            [building addPicturesObject:picModel];
        }
    }
    
    NSDictionary *electricityUsageThisMonth = dictionary[@"ElectricUsageThisMonth"];
    
    if (!REMIsNilOrNull(electricityUsageThisMonth)) {
        REMManagedBuildingCommodityUsageModel *elecModel = [self create:[REMManagedBuildingCommodityUsageModel class]];
        elecModel.id = electricityUsageThisMonth[@"Id"];
        elecModel.name = NULL_TO_NIL(electricityUsageThisMonth[@"Name"]);
        elecModel.code = electricityUsageThisMonth[@"Code"];
        elecModel.comment = electricityUsageThisMonth[@"Comment"];
        building.electricityUsageThisMonth =elecModel;
    }
    
    return building;

}



- (void)persistCustomers:(NSArray *)customers{
    REMManagedUserModel *user = [[self fetch:[REMManagedUserModel class]] lastObject];// [[REMDataStore fetchManagedObject:] lastObject];
    
//    for(REMManagedCustomerModel *old in user.customers.allObjects){
//        [REMDataStore deleteManagedObject:old];
//    }
    
    for(NSDictionary *customer in customers){
        REMManagedCustomerModel *customerObject= (REMManagedCustomerModel *)[REMDataStore createManagedObject:[REMManagedCustomerModel class]];
        
        customerObject.id = customer[@"Id"];
        customerObject.name=customer[@"Name"];
        customerObject.code=customer[@"Code"];
        customerObject.address=customer[@"Address"];
        customerObject.email=customer[@"Email"];
        customerObject.manager=customer[@"Manager"];
        customerObject.telephone=customer[@"Telephone"];
        customerObject.comment= NULL_TO_NIL(customer[@"Comment"]);
        customerObject.timezoneId=customer[@"TimezoneId"];
        customerObject.logoId=customer[@"logoId"];
        long long time=[REMTimeHelper longLongFromJSONString:customer[@"StartTime"]];
        customerObject.startTime= [NSDate dateWithTimeIntervalSince1970:time/1000 ];
        
        NSArray *administrators=customer[@"Administrators"];
        
        for (NSDictionary *admin in administrators) {
            REMManagedAdministratorModel *adminObject= (REMManagedAdministratorModel *)[REMDataStore createManagedObject:[REMManagedAdministratorModel class]];
            adminObject.realName=admin[@"RealName"];
            adminObject.customer=customerObject;
            [customerObject addAdministratorsObject:adminObject];
        }
        
        [user addCustomersObject:customerObject];
    }
}


@end
