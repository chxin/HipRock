//
//  REMBuildingTitleView.h
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingConstants.h"


@interface REMBuildingTitleView : UIView


@property (nonatomic,copy) NSString *title;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat titleMargin;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat valueFontSize;
@property (nonatomic) CGFloat uomFontSize;

@property (nonatomic,copy) NSString *emptyText;
@property (nonatomic) CGFloat emptyTextFontSize;
@property (nonatomic,copy) NSString *emptyTextFont;
@property (nonatomic) CGFloat textWidth;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic) CGFloat emptyTextMargin;
@property (nonatomic,weak) UILabel *emptyLabel;

- (void)initTitle:(NSString *)text withSize:(CGFloat)size withLeftMargin:(CGFloat)leftMargin;

- (NSString *)addThousandSeparator:(NSNumber *)number;

- (void) setTitleIcon:(UIImage *)image;

- (void)showLoading;

-(void)hideLoading;

- (void)showTitle;

@property (nonatomic,strong) UILabel *textLabel;

- (void)setEmptyText:(NSString *)emptyText withSize:(CGFloat)size;

- (void)initEmptyTextLabelWithTitleSize:(CGFloat)titleSize withTitleMargin:(CGFloat)margin withLeftMargin:(CGFloat)leftMargin withOrigFontSize:(CGFloat)fontSize;
@end
