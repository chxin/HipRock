//
//  DCLabelingTooltipView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/17/13.
//
//

#import <UIKit/UIKit.h>

@interface DCLabelingTooltipView : UIView
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) NSString* stageText;
@property (nonatomic, strong) NSString* labelText;

@property (nonatomic, strong) NSString* fontName;
@property (nonatomic, assign) CGFloat height;

-(CGFloat)getWidth;
@end
