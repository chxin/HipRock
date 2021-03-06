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
#import "REMManagedEnergyDataModel.h"
#import "REMEnergyDataPersistenceProcessor.h"
#import "REMClientErrorInfo.h"
#import "REMWidgetStepEnergyModel.h"


@implementation REMEnergySeacherBase

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType)storeType withWidgetInfo:(REMManagedWidgetModel *)widgetInfo andSyntax:(REMWidgetContentSyntax *)contentSyntax
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
    obj.contentSyntax = contentSyntax;
    obj.disableNetworkAlert=NO;
    return  obj;
}

- (REMBusinessErrorInfo *)beforeSendRequest{
    if(self.contentSyntax.dataStoreType == REMDSEnergyCostElectricity){
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        if(stepModel.step == REMEnergyStepHour){
            REMClientErrorInfo *bizError=[[REMClientErrorInfo alloc] init];
            bizError.code=@"";
            bizError.messageInfo=REMIPadLocalizedString(@"Chart_TouNotSupportHourly");
            
            return bizError;
        }
        if(stepModel.step == REMEnergyStepMinute){
            REMClientErrorInfo *bizError=[[REMClientErrorInfo alloc] init];
            bizError.code=@"";
            bizError.messageInfo=REMIPadLocalizedString(@"Chart_TouNotSupportRaw");
            
            return bizError;
        }
    }
    return nil;
}

- (void)setLoadingType:(REMEnergySearcherLoadingType)loadingType
{
    if (loadingType == REMEnergySearcherLoadingTypeLarge) {
        UIActivityIndicatorView *loader=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loader setColor:[UIColor blackColor]];
        [loader setBackgroundColor:[UIColor clearColor]];
        UIView *image=[[UIView alloc]init];
        [image setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
        image.translatesAutoresizingMaskIntoConstraints=NO;
        self.loadingBackgroundView=image;
//        self.loadingBackgroundView.layer.borderColor=[UIColor redColor].CGColor;
//        self.loadingBackgroundView.layer.borderWidth=1;
        self.loadingView=loader;
        loader.translatesAutoresizingMaskIntoConstraints=NO;
    }
    else{
        UIActivityIndicatorView *activitor= [[UIActivityIndicatorView alloc] init];
        [activitor setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        self.loadingView=activitor;
    }
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
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:storeType parameter:[model toSearchParam] accessCache:YES andMessageMap:nil];
    store.persistenceProcessor = [[REMEnergyDataPersistenceProcessor alloc] init];
    store.isDisableAlert=self.disableNetworkAlert;
   
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
    else{
        if (self.loadingView.translatesAutoresizingMaskIntoConstraints==YES) {
            [self.loadingView setFrame:maskerContainer.bounds];
        }
    }
    
    [store access:^(id data) {
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
        [self.loadingBackgroundView removeFromSuperview];
        [maskerContainer removeConstraints:allConstaints];
        id ret;
        if([data isEqual:[NSNull null]]==YES){
            ret = nil;
        }
        else{
            ret = [self processEnergyData:data];
        }
        if(callback!=nil){
            callback(ret,nil);
        }
    } failure:^(NSError *error, REMDataAccessStatus status, REMBusinessErrorInfo *errorInfo) {
        [self.loadingBackgroundView removeFromSuperview];
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
        [maskerContainer removeConstraints:allConstaints];
        if (status == REMDataAccessFailed) {
            callback(nil,nil);
        }
        else if(errorInfo!=nil){
            callback(nil,errorInfo);
        }
    }];
}


- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    return [[REMEnergyViewData alloc]initWithDictionary:rawData];;
}



@end
