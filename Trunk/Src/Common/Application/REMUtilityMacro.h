//
//  REMUtilMacro.h
//  Blues
//
//  Created by 张 锋 on 3/18/14.
//
//

#ifndef Blues_REMUtilityMacro_h
#define Blues_REMUtilityMacro_h


#define REMEmptyString @""

/**
 *  Decides whether a string is nil or empty
 *
 *  @param a The string to be validated
 *
 *  @return BOOL value
 */
#define REMStringNilOrEmpty(a) ((a) == nil || [(a) isEqualToString:REMEmptyString])

/**
 *  Decides whether an object is nil or Null
 *
 *  @param a The object to be validated
 *
 *  @return BOOL value
 */
#define REMIsNilOrNull(a) ((a)==nil || [(a) isEqual:[NSNull null]])

/**
 *  Shortcut for make color from RGBA
 *
 *  @param r Red in 0~255
 *  @param g Green in 0~255
 *  @param b Blue in 0~255
 *  @param a Alpha in 0~1
 *
 *  @return Constructed UIColor instance
 */
#define REMRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)];


#define REMCommonLocalizedString(a) (REMIsNilOrNull(a)? REMEmptyString : NSLocalizedStringFromTable(a,@"Localizable_Common",REMEmptyString))
#define REMIPadLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPad",REMEmptyString)
#define REMIPhoneLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPhone",REMEmptyString)

#define REMLoadImageNamed(a) [UIImage imageNamed:(a)]

#define REMLoadImageResource(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]

#define REMOSGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define REMISIOS7 REMOSGreaterThan(@"7.0")

#define REMCurrentDevice ([UIDevice currentDevice])

/**
 *  <#Description#>
 *
 *  @param noconn <#noconn description#>
 *  @param fail   <#fail description#>
 *  @param error  <#error description#>
 *  @param cancel <#cancel description#>
 *
 *  @return <#return value description#>
 */
#define REMDataAccessMessageMake(noconn,fail,error,cancel) (@{@(REMDataAccessNoConnection):REMIPadLocalizedString(noconn), @(REMDataAccessFailed):REMIPadLocalizedString(fail),@(REMDataAccessErrorMessage):REMIPadLocalizedString(error), @(REMDataAccessCanceled):REMIPadLocalizedString(cancel)});

/**
 *  <#Description#>
 */
#define REMNetworkMessageMap REMDataAccessMessageMake(@"Common_NetServerError",@"Common_NetConnectionFailed",@"Common_NetNoConnection",@"")

#endif
