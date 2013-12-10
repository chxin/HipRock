/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergySeacherBase.m
 * Created      : tantan on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergySeacherBase.h"
#import "REMEnergyMultiTimeSearcher.h"
#import "REMEnergyCostElectricitySearcher.h"



@implementation REMEnergySeacherBase

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType)storeType withWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMEnergySeacherBase *obj;
    if (storeType == REMDSEnergyMultiTimeDistribute ||storeType == REMDSEnergyMultiTimeTrend) {
        obj= [[REMEnergyMultiTimeSearcher alloc]init];
    }
    else if(storeType == REMDSEnergyCostElectricity){
        obj= [[REMEnergyCostElectricitySearcher alloc]init];
    }
    else{
        obj=[[REMEnergySeacherBase alloc]init];
    }
    obj.widgetInfo=widgetInfo;
    return  obj;
}

- (REMBusinessErrorInfo *)beforeSendRequest{
    return nil;
}

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(REMWidgetSearchModelBase *)model withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void (^)(id, REMBusinessErrorInfo *))callback
{
    if (self.loadingView!=nil && self.loadingView.isAnimating==YES) {
        return;
    }
    
    
    self.model=model;
    
    REMBusinessErrorInfo *error=[self beforeSendRequest];
    if(error!=nil){
        callback(nil,error);
        return;
    }
    
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:storeType parameter:[model toSearchParam]];
    //store.maskContainer=maskerContainer;
    
    
   
    //[activitor setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    if(self.loadingView==nil){
        UIActivityIndicatorView *activitor= [[UIActivityIndicatorView alloc] initWithFrame:maskerContainer.bounds];
        [activitor setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        //[activitor setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.8]];
        self.loadingView=activitor;
    }
   

    [maskerContainer addSubview:self.loadingView];
    [self.loadingView startAnimating];
    store.groupName=groupName;
    
    
    NSMutableArray *allConstaints=[NSMutableArray array];
    
    if (self.loadingView.translatesAutoresizingMaskIntoConstraints==NO) {
        NSLayoutConstraint *constraintX=[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *constraintY=[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [maskerContainer addConstraint:constraintX];
        [maskerContainer addConstraint:constraintY];
        [allConstaints addObject:constraintX];
        [allConstaints addObject:constraintY];
        
    }
    
    if (self.loadingBackgroundView!=nil) {
        [maskerContainer addSubview:self.loadingBackgroundView];
        if (self.loadingBackgroundView.translatesAutoresizingMaskIntoConstraints==NO) {
            NSLayoutConstraint *constraintX=[NSLayoutConstraint constraintWithItem:self.loadingBackgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *constraintWidth=[NSLayoutConstraint constraintWithItem:self.loadingBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
            NSLayoutConstraint *constraintY=[NSLayoutConstraint constraintWithItem:self.loadingBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *constraintHeight=[NSLayoutConstraint constraintWithItem:self.loadingBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:maskerContainer attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
            [maskerContainer addConstraint:constraintX];
            [maskerContainer addConstraint:constraintY];
            [maskerContainer addConstraint:constraintWidth];
            [maskerContainer addConstraint:constraintHeight];
            [allConstaints addObject:constraintX];
            [allConstaints addObject:constraintY];
            [allConstaints addObject:constraintWidth];
            [allConstaints addObject:constraintHeight];
        }
    }
    
    
    
    
    
    
    [REMDataAccessor access:store success:^(NSDictionary *data){
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
        [self.loadingBackgroundView removeFromSuperview];
        [maskerContainer removeConstraints:allConstaints];
        if([data isEqual:[NSNull null]]==YES)return ;
        REMEnergyViewData *viewData=[self processEnergyData:data];
        if(callback!=nil){
            callback(viewData,nil);
        }
        
    } error:^(NSError *error,REMBusinessErrorInfo *errorInfo){
        [self.loadingBackgroundView removeFromSuperview];
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
        [maskerContainer removeConstraints:allConstaints];
        callback(nil,errorInfo);
    }];
}


- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    return [[REMEnergyViewData alloc]initWithDictionary:rawData];;
}



@end
