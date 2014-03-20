//
//  REMUtilMacro.h
//  Blues
//
//  Created by 张 锋 on 3/18/14.
//
//

#ifndef Blues_REMUtilityMacro_h
#define Blues_REMUtilityMacro_h

/**
 *  Empty string macro
 */
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
 *  <#Description#>
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

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

/**
 *  Localized string from Localizable_Common.strings
 *
 *  @param a Key
 *
 *  @return Localized string
 */
#define REMCommonLocalizedString(a) (REMIsNilOrNull(a)? REMEmptyString : NSLocalizedStringFromTable(a,@"Localizable_Common",REMEmptyString))

/**
 *  Localized string from Localizable_IPad.strings
 *
 *  @param a Key
 *
 *  @return Localized string
 */
#define REMIPadLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPad",REMEmptyString)

/**
 *  Localized string from Localizable_IPhone.strings
 *
 *  @param a Key
 *
 *  @return Localized string
 */
#define REMIPhoneLocalizedString(a) NSLocalizedStringFromTable(a,@"Localizable_IPhone",REMEmptyString)

/**
 *  Load image by name
 *
 *  @param a Name
 *
 *  @return UIImage instance
 */
#define REMLoadImageNamed(a) [UIImage imageNamed:(a)]

/**
 *  Load image by resource name
 *
 *  @param a Resource name
 *  @param b Suffix
 *
 *  @return UIImage instance
 */
#define REMLoadImageResource(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]

#define REMOSGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define REMISIOS7 REMOSGreaterThan(@"7.0")

/**
 *  Get current device
 *
 *  @return Current device instance
 */
#define REMCurrentDevice ([UIDevice currentDevice])

/**
 *  Make data access message dictionary
 *
 *  @param noconn Message when no network connection
 *  @param fail   Message when request failed
 *  @param error  Message when server respondes error
 *  @param cancel Message when request is canceled
 *
 *  @return Message dictionary
 */
#define REMDataAccessMessageMake(noconn,fail,error,cancel) (@{@(REMDataAccessNoConnection):REMIPadLocalizedString(noconn), @(REMDataAccessFailed):REMIPadLocalizedString(fail),@(REMDataAccessErrorMessage):REMIPadLocalizedString(error), @(REMDataAccessCanceled):REMIPadLocalizedString(cancel)});

/**
 *  Default message map
 */
#define REMNetworkMessageMap REMDataAccessMessageMake(@"Common_NetServerError",@"Common_NetConnectionFailed",@"Common_NetNoConnection",@"")

#endif
