//
//  REMCommonDefinition.h
//  Blues
//
//  Created by 张 锋 on 10/31/13.
//
//

#ifndef Blues_REMCommonDefinition_h
#define Blues_REMCommonDefinition_h

#define REMEmptyString @""

#define REMIsNilOrNull(a) ((a)==nil || [(a) isEqual:[NSNull null]])

#define REMLocalizedString(a) NSLocalizedString((a),@"")

#define REMLoadImage(a,b) [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(a) ofType:(b)]]
#define REMLoadPngImage(a) REMLoadImage((a),@"png")
#define REMLoadJpgImage(a) REMLoadImage((a),@"jpg")

#endif
