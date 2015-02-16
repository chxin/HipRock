//
//  REMAppMacro.h
//  Blues
//
//  Created by 张 锋 on 3/18/14.
//
//

#ifndef Blues_REMAppMacro_h
#define Blues_REMAppMacro_h

/**
 *  Security key used for request token in AES encrypt
 */
#define REMSecurityTokenKey @"41758bd9d7294737"

/**
 *  Jazz supported commodities
 */

#define REMCommodities @{@(0):@"Common_Commodity_Other",@(1):@"Common_Commodity_Elec",@(2):@"Common_Commodity_Water",@(3):@"Common_Commodity_Gas",@(4):@"Common_Commodity_SoftWater",@(5):@"Common_Commodity_Petrol",@(6):@"Common_Commodity_LowPressureSteam",@(7):@"Common_Commodity_DieselOil",@(8):@"Common_Commodity_HeatQ",@(9):@"Common_Commodity_CoolQ",@(10):@"Common_Commodity_Coal",@(11):@"Common_Commodity_CoalOil",@(12):@"Common_Commodity_AirQuality"}

/**
 *  Jazz supported uoms
 */
#define REMUoms @{ @(1):@"KWH",@(2):@"KVARH",@(3):@"KVAH",@(4):@"KW",@(5):@"m3",@(7):@"ppm",@(8):@"kg",@(9):@"Ton",@(10):@"J",@(11):@"GJ",@(12):@"RMB",@(13):@"m2",@(14):@"h",@(15):@"m",@(16):@"s",@(17):@"oC",@(18):@"kgce",@(19):@"kgCO2",@(20):@"Tree",@(21):@"Person",@(32):@"null",@(33):@"KVA",@(34):@"KVAR",@(35):@"VOLTS",@(36):@"AMPS",@(37):@"μg/m3" }

/**
 *  Province array orderd by showing precedence
 */
#define REMProvinceOrder @[@"北京",@"天津",@"河北",@"山西",@"内蒙古",@"辽宁",@"吉林",@"黑龙江",@"上海",@"江苏",@"浙江",@"安徽",@"福建",@"江西",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"广西",@"海南",@"重庆",@"四川",@"贵州",@"云南",@"西藏",@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",@"香港",@"澳门",@"台湾",@"海外"]
#define REMProvinceKeys @[@"Common_Province_Beijing",@"Common_Province_Tianjin",@"Common_Province_Hebei",@"Common_Province_Shanxi",@"Common_Province_InnerMongolia",@"Common_Province_Liaoning",@"Common_Province_Jilin",@"Common_Province_Heilongjiang",@"Common_Province_Shanghai",@"Common_Province_Jiangsu",@"Common_Province_Zhejiang",@"Common_Province_Anhui",@"Common_Province_Fujian",@"Common_Province_Jiangxi",@"Common_Province_Shandong",@"Common_Province_Henan",@"Common_Province_Hubei",@"Common_Province_Hunan",@"Common_Province_Guangdong",@"Common_Province_Guangxi",@"Common_Province_Hainan",@"Common_Province_Chongqing",@"Common_Province_Sichuan",@"Common_Province_Guizhou",@"Common_Province_Yunnan",@"Common_Province_Tibet",@"Common_Province_Shaanxi",@"Common_Province_Gansu",@"Common_Province_Qinghai",@"Common_Province_Ningxia",@"Common_Province_Xinjiang",@"Common_Province_HongKong",@"Common_Province_Macau",@"Common_Province_Taiwan",@"Common_Province_OutsideChinasBorder"]

/**
 *  User validation regular expressions
 */
#define REMREGEX_UserValidation @[@"^[a-zA-Z0-9_.\u4E00-\u9FFF\-]+$", @"[0-9]+", @"[a-zA-Z]+", @"^[0-9a-zA-Z_!@#$%^&*()][0-9a-zA-Z_!@#$%^&*()]*$", @"[ ]+"]

/**
 *  Decides whether a user name is in valid format
 */
#define REMREGEXMatch_UserName(a) [[NSRegularExpression regularExpressionWithPattern:REMREGEX_UserValidation[0] options:NSRegularExpressionCaseInsensitive error:NULL] firstMatchInString:(a) options:0 range:NSMakeRange(0, (a).length)]

/**
 *  Decides whether a password is in valid format
 */
#define REMREGEXMatch_Password(a,b) [[NSRegularExpression regularExpressionWithPattern:REMREGEX_UserValidation[(b)] options:0 error:NULL] firstMatchInString:(a) options:0 range:NSMakeRange(0, (a).length)]

//#define REMREGEX_Telephone @"^(\\d)+(-(\\d)+)*$"

#endif
