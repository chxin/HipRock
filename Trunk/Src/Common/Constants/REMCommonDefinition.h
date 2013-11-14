/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCommonDefinition.h
 * Created      : 张 锋 on 10/31/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMCommonDefinition_h
#define Blues_REMCommonDefinition_h

#define REMEmptyString @""

#define REMIsNilOrNull(a) ((a)==nil || [(a) isEqual:[NSNull null]])

#define REMRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)];
#define REMHexColor(a) []

#define REMLocalizedString(a) NSLocalizedString((a),@"")

#define REMLoadImage(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]
#define REMLoadPngImage(a) REMLoadImage((a),@"png")
#define REMLoadJpgImage(a) REMLoadImage((a),@"jpg")

#define REMOSGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define REMISIOS7 REMOSGreaterThan(@"7.0")


#endif
