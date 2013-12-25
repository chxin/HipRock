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


@interface REMWidgetBizDelegatorBase()

@property (nonatomic,weak) UIView *popupMsgView;


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

- (void)initBizView{}

- (void)showChart{
    if (self.energyData) {
        [self processEnergyDataInnerError:self.energyData];
    }
    
}

-(void)releaseChart{}

- (void)rollbackWithError:(REMBusinessErrorInfo *)error{
    
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
            
            [self mergeTempModel];
            
            [self reloadChart];
            
            [self processEnergyDataInnerError:data];
            
        }
        else{
            if (error == nil) { //timeout
                REMBusinessErrorInfo *bizInfo=[[REMBusinessErrorInfo alloc]init];
                bizInfo.code=@"timeout";
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
                    [self rollbackWithError:error];
                }
            }
        }
    }];

}

- (void)processEnergyDataInnerError:(REMEnergyViewData *)data{
    if (data.error!=nil && [data.error isEqual:[NSNull null]]==NO && data.error.count>0) {
        REMEnergyError *error= data.error[0];
        if (error!=nil && [error isEqual:[NSNull null]]==NO) {
            NSString *errorCode= [error.errorCode substringFromIndex:7];
            errorCode=[NSString stringWithFormat:@"Energy_%@",errorCode];
            NSString *showText= NSLocalizedString(errorCode, @"");
            if ([errorCode isEqualToString:showText]==YES) {
                return;
            }
            if (error.params!=nil && [error.params isEqual:[NSNull null]]==NO && error.params.count>0) {
                
            }
            [self showPopupMsg:showText];
        }
    }
}

- (void) showPopupMsg:(NSString *)msg{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
    label.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:20];
    [label setBackgroundColor:[UIColor grayColor]];
    label.text=msg;
    label.textAlignment=NSTextAlignmentCenter;
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font];
    CGFloat height=50;
    CGFloat margin=50;
    CGFloat bottom=10;
    
    [label setFrame:CGRectMake((kDMScreenWidth-(expectedLabelSize.width+margin))/2, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight), expectedLabelSize.width+margin, height)];
    [self.view addSubview:label];
    self.popupMsgView=label;
    [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y-height-bottom, label.frame.size.width,label.frame.size.height)];
    }completion: ^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+height+bottom, label.frame.size.width,label.frame.size.height)];
        }completion:^(BOOL finished){
            [self hidePopupMsg];
        }];
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
