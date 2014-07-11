/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMConstants.h
 * Created      : 张 锋 on 10/31/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMConstants_h
#define Blues_REMConstants_h

typedef enum _REMCommodity : int{
    REMCommodityElectricity = 1,
    REMCommodityWater = 2,
    REMCommodityGas = 3,
    REMCommoditySoftWater = 4,
} REMCommodity;

const static long REMDAY = 24*3600;
const static long REMWEEK = REMDAY*7;
const static long REMMONTH = REMDAY*31;
const static long REMYEAR = REMDAY*366;







#endif
