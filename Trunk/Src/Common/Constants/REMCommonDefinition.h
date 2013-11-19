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

#define REMLoadImageNamed(a) [UIImage imageNamed:(a)]

#define REMLoadImageResource(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]

#define REMOSGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define REMISIOS7 REMOSGreaterThan(@"7.0")

#define REMUpdateStatusBarAppearenceForIOS7 if(REMISIOS7){ [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)]; }

#define REMCommodities @{@(0):@"其他",@(1):@"电",@(2):@"自来水",@(3):@"天然气",@(4):@"软水",@(5):@"汽油",@(6):@"低压蒸汽",@(7):@"柴油",@(8):@"热量",@(9):@"冷量",@(10):@"煤",@(11):@"煤油",@(12):@"空气"}
#define REMUoms @{}


#endif
