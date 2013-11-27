//
//  DCPieChartAnimationFrame.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import <Foundation/Foundation.h>

@interface DCPieChartAnimationFrame : NSObject
@property (nonatomic,strong) NSNumber* radius;            // 圆形区域半径
@property (nonatomic,strong) NSNumber* radiusForShadow;   // 投影半径
@property (nonatomic,strong) NSNumber* rotationAngle;     // 扇图已经旋转的角度，值域为[0-2)，例如需要旋转90°，rotationAngle=0.5
@property (nonatomic,strong) NSNumber* fullAngle;         // 扇图的总体的角度和，值域为[0-2]，例如如果只需要画半圆，fullAngle=1
@property (nonatomic,strong) NSNumber* indicatorAlpha;
@end
