/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBizDelegatorBase.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetEnergyDelegator.h"
#import "REMWidgetRankingDelegator.h"
#import "REMWidgetLabelingDelegator.h"
#import "REMClientErrorInfo.h"
#import "REMImages.h"
#import "REMPopNote.h"


@interface REMWidgetBizDelegatorBase()

@property (nonatomic,weak) UIView *popupMsgView;
@property (nonatomic,weak) UILabel *serverErrorLabel;

@end


@implementation REMWidgetBizDelegatorBase

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMWidgetBizDelegatorBase *delegator;
    if(widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingCarbon ||
       widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingCost ||
       widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingEnergy){
        delegator=[[REMWidgetRankingDelegator alloc]init];
    }
    else if(widgetInfo.contentSyntax.dataStoreType == REMDSEnergyLabeling){
        delegator=[[REMWidgetLabelingDelegator alloc]init];
    }
    else{
        delegator=[[REMWidgetEnergyDelegator alloc]init];
    }
    
    return delegator;
}

- (REMWidgetSearchModelBase *)tempModel{
    if (_tempModel==nil) {
        _tempModel=[self.model copy];
    }
    
    return _tempModel;
}

- (REMEnergySeacherBase *)searcher
{
    if (_searcher==nil) {
        _searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
        _searcher.loadingType=REMEnergySearcherLoadingTypeLarge;
    }
    
    return _searcher;
}

- (REMWidgetSearchModelBase *)model{
    if (_model==nil) {
        _model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    }
    return _model;
}

- (void)reloadChart{}

- (void)initBizView{}

- (BOOL) shouldPinToBuildingCover{
    if (self.widgetInfo.diagramType == REMDiagramTypeColumn ||
        self.widgetInfo.diagramType == REMDiagramTypeLine ||
        self.widgetInfo.diagramType == REMDiagramTypeRanking ||
        self.widgetInfo.diagramType == REMDiagramTypeStackColumn) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldEnablePinToBuildingCoverButton
{
    if (self.ownerController.buildingInfo.commodityArray.count!=0) {
        return YES;
    }
    else{
        return NO;
    }
}

- (CGFloat)xPositionForPinToBuildingCoverButton
{
    return 750;
}

- (void)showChart{
    
    if (self.energyData) {
        [self processEnergyDataInnerError:self.energyData];
    }
    if (self.ownerController.serverError!=nil) {
        if ([self.ownerController.serverError.code isEqualToString:@"1"]==YES) {
            [self generateServerErrorLabel:NSLocalizedString(@"Common_ServerError", @"")];
        }
        else{
            NSString *showText=[self processServerError:self.ownerController.serverError.code];
            if (showText!=nil) {
                [self showPopupMsg:showText];
            }
        }
    }
    if (self.ownerController.isServerTimeout==YES) {
        [self generateServerErrorLabel:NSLocalizedString(@"Common_ServerTimeout", @"")];
    }
    
}

- (void)generateServerErrorLabel:(NSString *)msg{
    if (self.serverErrorLabel!=nil) {
        self.serverErrorLabel.text=msg;
        return;
    }
    UILabel *label=[[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints=NO;
    label.textColor=[UIColor blackColor];
    label.text=msg;
    [label setBackgroundColor:[UIColor clearColor]];
    UIView *container = self.view;
    if (self.chartContainer!=nil) {
        container=self.chartContainer;
    }
    NSLayoutConstraint *constraintX=[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *constraintY=[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [container addSubview:label];
    [container addConstraint:constraintX];
    [container addConstraint:constraintY];
    self.serverErrorLabel=label;
    
}

-(void)releaseChart{}

- (void)rollbackWithError:(REMBusinessErrorInfo *)error{
    NSString *showText= [self processServerError:error.code];
    if (showText == nil) {
        return;
    }
    [self showPopupMsg:showText];
}
- (void)mergeTempModel{
    NSMutableArray *searchTimeRange=[NSMutableArray array];
    
    for (int i=0; i<self.tempModel.timeRangeArray.count; ++i) {
        REMTimeRange *range=self.tempModel.timeRangeArray[i];
        [searchTimeRange addObject:[range copy]];
    }
    
    self.tempModel.searchTimeRangeArray=searchTimeRange;
    self.model=[self.tempModel copy];
}
- (void)searchData:(REMWidgetSearchModelBase *)model
{
    [self doSearchWithModel:model callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            self.energyData=data;
            
            if (self.serverErrorLabel!=nil) {
                [self.serverErrorLabel removeFromSuperview];
                self.serverErrorLabel=nil;
            }
            
            [self mergeTempModel];
            
            [self reloadChart];
            
            [self processEnergyDataInnerError:data];
            
        }
        else{
            if (error == nil) { //timeout or server error
                REMBusinessErrorInfo *bizInfo=[[REMBusinessErrorInfo alloc]init];
                bizInfo.code=@"timeout";
                if (self.serverErrorLabel!=nil) {
                    [self generateServerErrorLabel:NSLocalizedString(@"Common_ServerTimeout", @"")];
                }
                [self rollbackWithError:bizInfo];
            }
            else{
                if([error isKindOfClass:[REMClientErrorInfo class]]==YES){
                    REMClientErrorInfo *err=(REMClientErrorInfo *)error;
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:err.messageInfo delegate:nil cancelButtonTitle:NSLocalizedString(@"Common_OK", @"") otherButtonTitles:nil, nil];
                    [alert show];
                    REMBusinessErrorInfo *bizInfo=[[REMBusinessErrorInfo alloc]init];
                    bizInfo.code=@"clienterror";
                    [self rollbackWithError:bizInfo];
                }
                else{
                    if ([error.code isEqualToString:@"1"]==YES) {
                        if (self.serverErrorLabel!=nil) {
                            [self generateServerErrorLabel:NSLocalizedString(@"Common_ServerError", @"")];
                        }
                    }
                
                    [self rollbackWithError:error];
                }
            }
        }
    }];

}

- (NSString *)processServerError:(NSString *)errorCode {
    if(errorCode.length>7){
        NSString *errorCode1= [errorCode substringFromIndex:7];
        errorCode1=[NSString stringWithFormat:@"Energy_%@",errorCode1];
        NSString *showText= NSLocalizedString(errorCode1, @"");
        if ([errorCode1 isEqualToString:showText]==YES) {
            return nil;
        }
        return showText;
    }
    return nil;
}

- (void)processEnergyDataInnerError:(REMEnergyViewData *)data{
    if (data.error!=nil && [data.error isEqual:[NSNull null]]==NO && data.error.count>0) {
        REMEnergyError *error= data.error[0];
        if (error!=nil && [error isEqual:[NSNull null]]==NO) {
            NSString *showText= [self processServerError:error.errorCode];
            if (showText == nil) {
                return;
            }
            if (error.params!=nil && [error.params isEqual:[NSNull null]]==NO && error.params.count>0) {
                
            }
            [self showPopupMsg:showText];
        }
    }
}

- (void) showPopupMsg:(NSString *)msg{
    [self hidePopupMsg];
    
    REMPopNote *pop = [[REMPopNote alloc] initWithText:msg];
    
    [self.view addSubview:pop];
    self.popupMsgView=pop;
    
    [pop show:^{
        [self hidePopupMsg];
    }];
}

- (void) hidePopupMsg{
    [self.popupMsgView removeFromSuperview];
}

- (void)doSearchWithModel:(REMWidgetSearchModelBase *)model callback:(void (^)(REMEnergyViewData *, REMBusinessErrorInfo *))callback
{
    
    [self.searcher queryEnergyDataByStoreType:self.widgetInfo.contentSyntax.dataStoreType andParameters:model withMaserContainer:self.maskerView  andGroupName:self.groupName callback:^(REMEnergyViewData *energyData,REMBusinessErrorInfo *errorInfo){
        
        //self.energyData=energyData;
        if(self.view!=nil){
            if(callback!=nil){
                callback(energyData,errorInfo);
            }
        }
            
    }];
}


@end
