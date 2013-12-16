//
//  DCLabelingLabel.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface DCLabelingLabel : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) NSString* stageText;
@property (nonatomic, strong) NSString* labelText;
@property (nonatomic, assign) NSUInteger stage;
@end
