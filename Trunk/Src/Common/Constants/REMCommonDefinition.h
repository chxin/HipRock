/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCommonDefinition.h
 * Created      : 张 锋 on 10/31/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMCommonDefinition_h
#define Blues_REMCommonDefinition_h

typedef enum _REMCommodity : int{
    REMCommodityElectricity = 1,
    REMCommodityWater = 2,
    REMCommodityGas = 3,
    REMCommoditySoftWater = 4,
} REMCommodity;

#define REMEmptyString @""
#define REMStringNilOrEmpty(a) ((a) == nil || [(a) isEqualToString:REMEmptyString])

#define REMIsNilOrNull(a) ((a)==nil || [(a) isEqual:[NSNull null]])

#define REMRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)];
#define REMHexColor(a) []

#define REMCommonLocalizedString(a) (REMIsNilOrNull(a)? REMEmptyString : NSLocalizedStringFromTable(a,@"Localizable_Common",REMEmptyString))
#define REMIPadLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPad",REMEmptyString)
#define REMIPhoneLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPhone",REMEmptyString)

#define REMLoadImageNamed(a) [UIImage imageNamed:(a)]

#define REMLoadImageResource(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]

#define REMOSGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define REMISIOS7 REMOSGreaterThan(@"7.0")

#define REMUpdateStatusBarAppearenceForIOS7 if(REMISIOS7){ [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)]; }

#define REMCommodities @{@(0):@"其他",@(1):@"电",@(2):@"自来水",@(3):@"天然气",@(4):@"软水",@(5):@"汽油",@(6):@"低压蒸汽",@(7):@"柴油",@(8):@"热量",@(9):@"冷量",@(10):@"煤",@(11):@"煤油",@(12):@"空气"}

#define REMUoms @{ @(1):@"KWH",@(2):@"KVARH",@(3):@"KVAH",@(4):@"KW",@(5):@"m3",@(7):@"ppm",@(8):@"kg",@(9):@"Ton",@(10):@"J",@(11):@"GJ",@(12):@"RMB",@(13):@"m2",@(14):@"h",@(15):@"m",@(16):@"s",@(17):@"oC",@(18):@"kgce",@(19):@"kgCO2",@(20):@"Tree",@(21):@"Person",@(32):@"null",@(33):@"KVA",@(34):@"KVAR",@(35):@"VOLTS",@(36):@"AMPS",@(37):@"μg/m3" }

#define REMProvinceOrder @[@"北京",@"天津",@"河北",@"山西",@"内蒙古",@"辽宁",@"吉林",@"黑龙江",@"上海",@"江苏",@"浙江",@"安徽",@"福建",@"江西",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"广西",@"海南",@"重庆",@"四川",@"贵州",@"云南",@"西藏",@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",@"香港",@"澳门",@"台湾",@"海外"]

#define REMREGEX_UserValidation @[@"^[a-zA-Z0-9_.]+$", @"[0-9]+", @"[a-zA-Z]+", @"^[0-9a-zA-Z_!@#$%^&*()][0-9a-zA-Z_!@#$%^&*()]*$", @"[ ]+"]

#define REMREGEXMatch_UserName(a) [[NSRegularExpression regularExpressionWithPattern:REMREGEX_UserValidation[0] options:NSRegularExpressionCaseInsensitive error:NULL] firstMatchInString:(a) options:0 range:NSMakeRange(0, (a).length)]
#define REMREGEXMatch_Password(a,b) [[NSRegularExpression regularExpressionWithPattern:REMREGEX_UserValidation[(b)] options:0 error:NULL] firstMatchInString:(a) options:0 range:NSMakeRange(0, (a).length)]

#define REMDataAccessMessageMake(noconn,fail,error,cancel) @{@(REMDataAccessNoConnection):REMIPadLocalizedString(noconn), @(REMDataAccessFailed):REMIPadLocalizedString(fail),@(REMDataAccessErrorMessage):REMIPadLocalizedString(error), @(REMDataAccessCanceled):REMIPadLocalizedString(cancel)};

#endif
