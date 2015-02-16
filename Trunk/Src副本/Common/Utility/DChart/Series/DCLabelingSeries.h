//
//  DCLabelingSeries.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import <Foundation/Foundation.h>
#import "DCLabelingStage.h"

@interface DCLabelingSeries : NSObject
@property (nonatomic, strong) NSArray* stages;
@property (nonatomic, strong) NSArray* labels;
@property (nonatomic, strong) NSString* benchmarkText;
@end
