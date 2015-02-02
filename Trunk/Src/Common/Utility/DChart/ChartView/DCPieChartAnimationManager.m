//
//  DCPieChartAnimationManager.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import "DCPieChartAnimationManager.h"
#import "DCPieChartView.h"


typedef struct _DCPieSlice {
    CGFloat sliceBegin; // 饼图Slice的起始角度，值域为[0-2)
    CGFloat sliceCenter; // 饼图Slice的起始角度和终止角度的均值，值域为(0-2)
    CGFloat sliceEnd; // 饼图Slice的终止角度的均值，值域为(0-2]
}DCPieSlice;

@interface DCPieChartAnimationManager()
@property (nonatomic, weak) DCPieChartView* view;
@property (nonatomic,strong) NSTimer* animationTimer;   // 播放旋转、增长等动画的Timer(不包含隐藏/显示扇区）

/*
 * 包含显隐扇区时的Timer。每个Timer播放结束后都会从数组中移除并销毁。
 * 播放显隐动画时，实际上是修改self.pointValueDics的中，单个点得valueKey并重绘。
 */
@property (nonatomic,strong) NSMutableArray* hiddenShowTimers;

/***
 * 一个字典数组。为方便饼图的显示/隐藏扇区动画，为序列中的每个点建立了如下数据结构
 * { 
 *     @"point": DCPoint, 每个点的索引
 *     @"valueKey": NSNumber或者Null。每个点的值，当点的Type不为DCDataPointTypeNormal时，为Null。当点隐藏时为0。
 *     @"step": 显隐动画时，Timer给扇区加值时的步长。
 * }
 ***/
@property (nonatomic,strong) NSMutableArray* pointValueDics;

/*
 * 一个数组，存储数个_DCPieSlice结构，表示每个点对应扇区的起始角度、终结角度以及中线角度。
 */
@property (nonatomic, strong) NSArray* pieSlices;
@property (nonatomic,assign) double sumVisableValue;
@end

const NSString* pointKey = @"point";
const NSString* valueKey = @"value";
const NSString* stepKey = @"step";

@implementation DCPieChartAnimationManager
-(id)initWithPieView:(DCPieChartView *)view {
    self = [super init];
    if (self) {
        _view = view;
        _hiddenShowTimers = [[NSMutableArray alloc]init];
        self.pointValueDics = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setSeries:(DCPieSeries *)series {
    _series = series;
    [self.pointValueDics removeAllObjects];
    if (!REMIsNilOrNull(series)) {
        for (DCPieDataPoint* point in series.datas) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:point forKey:pointKey];
            if (point.pointType == DCDataPointTypeNormal) {
                [dic setObject: point.hidden ? @(0) : point.value forKey:valueKey];
                [dic setObject:@(point.value.doubleValue/kDCAnimationDuration/kDCFramesPerSecord) forKey:stepKey];
            } else {
                [dic setObject:[NSNull null] forKey:valueKey];
                [dic setObject:[NSNull null] forKey:stepKey];
            }
            [self.pointValueDics addObject:dic];
        }
    }
    [self updateSumValueAndSlices];
}

// 计算从a到b的所有整数的等差数列的和值
-(int)sumFrom:(NSUInteger)a to:(NSUInteger)b {
    if (a > b) {
        NSUInteger c = a;
        a = b;
        b = c;
    }
    return (b + a) * (b - a + 1) / 2;
}

-(void)animateToFrame:(DCPieChartAnimationFrame*)targetFrame callback:(DCPieAnimationCallback)callback {
    if (self.view == Nil) return;
    
    double frames = kDCAnimationDuration * kDCFramesPerSecord;
    
    double radiusStep = 0;
    double shadowRadiusStep = 0;
    double rotationAngleStep = 0;
    double fullAngleStep = 0;
    double indicatorAlphaStep = 0;
    int stepDiv = [self sumFrom:0 to:frames];
    if (targetFrame.radius) {
        radiusStep = (targetFrame.radius.doubleValue - self.view.radius) / stepDiv;
    }
    if (targetFrame.radiusForShadow) {
        shadowRadiusStep = (targetFrame.radiusForShadow.doubleValue - self.view.radiusForShadow) / stepDiv;
    }
    if (targetFrame.rotationAngle) {
        rotationAngleStep = (targetFrame.rotationAngle.doubleValue - self.view.rotationAngle) / stepDiv;
    }
    if (targetFrame.fullAngle) {
        fullAngleStep = (targetFrame.fullAngle.doubleValue - self.view.fullAngle) / stepDiv;
    }
    if (targetFrame.indicatorAlpha) {
        indicatorAlphaStep = (targetFrame.indicatorAlpha.doubleValue - self.view.indicatorAlpha) / stepDiv;
    }
    
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    for (int i = 0; i < frames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        int stepMulti = [self sumFrom:frames - i to:frames] ;
        if (targetFrame.radius) {
            aframe.radius = @(self.view.radius + stepMulti * radiusStep);
        }
        if (targetFrame.radiusForShadow) {
            aframe.radiusForShadow = @(self.view.radiusForShadow + stepMulti * shadowRadiusStep);
        }
        if (targetFrame.rotationAngle) {
            aframe.rotationAngle = @(self.view.rotationAngle + stepMulti * rotationAngleStep);
        }
        if (targetFrame.fullAngle) {
            aframe.fullAngle = @(self.view.fullAngle + stepMulti * fullAngleStep);
        }
        if (targetFrame.indicatorAlpha) {
            aframe.indicatorAlpha = @(self.view.indicatorAlpha + stepMulti * indicatorAlphaStep);
        }
        [animationFrames addObject:aframe];
    }
    [animationFrames addObject:targetFrame];
    [self playFrames:animationFrames callback:callback];
}

// 把一个数Mod2
-(double)abs2:(double)v {
    int a = (v)/2;
    if (v < 0) {
        v -= 2*(a-1);
    } else if (a > 0) {
        v -= 2*a;
    }
    return v;
}

-(NSArray*)getAngleTurningFramesFrom:(double)from to:(double)to {
    if (from == to) return nil;
    int frames = kDCAnimationDuration * kDCFramesPerSecord;
    int halfFrames = frames / 2;
    int stepDiv = [self sumFrom:0 to:halfFrames];
    double rotationAngleStep = (to - from) / 2 / stepDiv;
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    
    double currentRotation = from;
    double currentSpeed = 0;
    for (int i = 0; i < halfFrames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        currentSpeed+= rotationAngleStep;
        currentRotation += currentSpeed;
        aframe.rotationAngle = @(currentRotation);
        [animationFrames addObject:aframe];
    }
    for (int i = halfFrames; i < frames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        currentRotation += currentSpeed;
        aframe.rotationAngle = @(currentRotation);
        [animationFrames addObject:aframe];
        currentSpeed-= rotationAngleStep;
    }
    DCPieChartAnimationFrame* targetFrame = [[DCPieChartAnimationFrame alloc]init];
    targetFrame.rotationAngle = @(to);
    [animationFrames addObject:targetFrame];
    return animationFrames;
}

-(void)rotateWithInitialSpeed:(double)speed {
    if (self.view == Nil) return;
    
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    
    double theSpeed = speed;
    double rotation = self.view.rotationAngle;
    double speedDown = 0.9;
    theSpeed *= speedDown;
    NSMutableArray* speedArray = [[NSMutableArray alloc]init];
    while (fabs(theSpeed) > 0.00001) {
        rotation += theSpeed;
        [speedArray addObject:@(theSpeed)];
        theSpeed*=speedDown;
    }
    double estimatedRotationAngle = self.view.rotationAngle;
    for (int i = 0; i < speedArray.count;i++) {
        DCPieChartAnimationFrame* frame = [[DCPieChartAnimationFrame alloc]init];
        estimatedRotationAngle+=[speedArray[i] doubleValue];
        frame.rotationAngle = @(estimatedRotationAngle);
        [animationFrames addObject:frame];
    }
    double lastFrameAlignedRotation = [self abs2:estimatedRotationAngle];
    double targetRotation = 2 - [self findNearbySliceCenter:lastFrameAlignedRotation];  // 预计对准的扇区的中线位置
    [animationFrames addObjectsFromArray:[self getAngleTurningFramesFrom:lastFrameAlignedRotation to:targetRotation]];
    // 应用动画
    [self playFrames:animationFrames callback:nil];
    
    return;
    
}

-(void)playFrames:(NSArray*)frames callback:(DCPieAnimationCallback)callback {
    if (frames == nil || frames.count == 0) {
        [self.view showPercentageTexts];
        if (!REMIsNilOrNull(callback)) {
            callback();
        }
    } else {
        [self.view hidePercentageTexts];
        if (self.animationTimer && [self.animationTimer isValid]) [self.animationTimer invalidate];
        NSDictionary* userInfo;
        if (REMIsNilOrNull(callback)) {
            userInfo = @{@"frames": frames.mutableCopy};
        } else {
            userInfo = @{@"callback": callback, @"frames": frames.mutableCopy};
        }
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animationTimerTarget) userInfo:userInfo repeats:YES];
    }
}

-(void)animationTimerTarget {
    if (self.view == nil) {
        [self stopTimer];
        return;
    }
    if (self.animationTimer && [self.animationTimer isValid]) {
        NSDictionary* userInfo = self.animationTimer.userInfo;
        NSMutableArray* frames = userInfo[@"frames"];
        if (frames.count == 0) {
            [self stopTimer];
            [self.view showPercentageTexts];
            DCPieAnimationCallback callback = userInfo[@"callback"];
            if (!REMIsNilOrNull(callback)) callback();
        } else {
            DCPieChartAnimationFrame* theFrame = frames[0];
            [frames removeObjectAtIndex:0];
            if (theFrame.radius) {
                self.view.radius = theFrame.radius.doubleValue;
            }
            if (theFrame.radiusForShadow) {
                self.view.radiusForShadow = theFrame.radiusForShadow.doubleValue;
            }
            if (theFrame.rotationAngle) {
                self.view.rotationAngle = theFrame.rotationAngle.doubleValue;
            }
            if (theFrame.fullAngle) {
                self.view.fullAngle = theFrame.fullAngle.doubleValue;
            }
            if (theFrame.indicatorAlpha) {
                self.view.indicatorAlpha = theFrame.indicatorAlpha.doubleValue;
            }
            [self.view redraw];
        }
    }
}

-(void)stopTimer {
    if (self.animationTimer && [self.animationTimer isValid]) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}











-(void)updateSumValueAndSlices {
    double sum = 0;
    NSMutableArray* previesSum = [[NSMutableArray alloc]init];
    NSMutableArray* slices = [[NSMutableArray alloc]init];
        int index = 0;
        for (DCPieDataPoint* point in self.series.datas) {
            [previesSum addObject:[NSNumber numberWithDouble:sum]];
            if (point.pointType == DCDataPointTypeNormal) {
                sum += [self getVisableValueOfPoint:point];
            }
            index++;
        }
    index = 0;
    for (DCPieDataPoint* point in self.series.datas) {
        double pointVal = [self getVisableValueOfPoint:point];
        if (point.pointType == DCDataPointTypeNormal && sum != 0 && pointVal != 0) {
            DCPieSlice slice;
            double p = ((NSNumber*)previesSum[index]).doubleValue;
            slice.sliceBegin = p * 2 / sum;
            slice.sliceEnd = slice.sliceBegin + pointVal * 2 / sum;
            slice.sliceCenter = (slice.sliceBegin + slice.sliceEnd) / 2;
            [slices addObject:[NSValue value:&slice withObjCType:@encode(DCPieSlice)]];
        } else {
            [slices addObject:[NSNull null]];
        }
        index++;
    }
    _pieSlices = slices;
    _sumVisableValue = sum;
}

-(void)setPoint:(DCPieDataPoint *)point hidden:(BOOL)hidden {
    if (point.pointType != DCDataPointTypeNormal) {
        point.hidden = hidden;
        return;
    }
    if (REMIsNilOrNull(point.value) || [point.value isEqualToNumber:@(0)]) return;
    [self.view hidePercentageTexts];
    for (NSMutableDictionary* valueDic in self.pointValueDics) {
        if (valueDic[pointKey] == point) {
            NSNumber* step = valueDic[stepKey];
            if ([step isLessThan:@(0)] != hidden) {
                [valueDic setObject:@(step.doubleValue*-1) forKey:stepKey];
            }
            break;
        }
    }
    NSTimer* theTimer = nil;
    for (NSTimer* timer in self.hiddenShowTimers) {
        if (![timer isValid]) continue;
        if (point == timer.userInfo) {
            theTimer = timer;
            break;
        }
    }
    if (!theTimer) {
        [self.hiddenShowTimers addObject:[NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(showOrHidePointTarget:) userInfo:point repeats:YES]];
    }
}

-(void)showOrHidePointTarget:(NSTimer*)timer {
    if (REMIsNilOrNull(self.view)) {
        [timer invalidate];
        [self.hiddenShowTimers removeObject:timer];
        return;
    }
    if ([timer isValid]) {
        DCPieDataPoint* point = timer.userInfo;
        BOOL isInHidden = NO;   //正在进行隐藏
        double step = 0;
        double to = 0;
        double value = 0;
        NSMutableDictionary* vDic;
        for (NSMutableDictionary* valueDic in self.pointValueDics) {
            if (valueDic[pointKey] == point) {
                step = [valueDic[stepKey] doubleValue];
                vDic = valueDic;
                value = [valueDic[valueKey] doubleValue];
                if (step <= 0) {
                    to = 0;
                    isInHidden = YES;
                } else {
                    to = point.value.doubleValue;
                }
                break;
            }
        }
        BOOL willStop = NO;
        value += step;
        if (isInHidden) {
            if (value <= 0) {
                willStop = YES;
                value = 0;
            }
        } else {
            if (value > to) {
                willStop = YES;
                value = to;
            }
        }
        [vDic setObject:@(value) forKey:valueKey];
        [self updateSumValueAndSlices];
        [self.view redraw];
        if (willStop) {
            [timer invalidate];
            point.hidden = isInHidden;
            [self.hiddenShowTimers removeObject:timer];
            
            if (self.sumVisableValue > 0) {
                [self playFrames:[self getAngleTurningFramesFrom:self.view.rotationAngle to:2-[self findNearbySliceCenter:self.view.rotationAngle]] callback:nil];
            }
        }
    }
}

/*
 * 获取所有可见点的角度值之和。
 */
-(double)getVisableSliceSum {
    return self.sumVisableValue;
}

/*
 * 用一个Point查找该点当前应绘制的角度大小。
 */
-(double)getVisableValueOfPoint:(DCPieDataPoint*)point {
    double angle = 0;
    if (point.pointType == DCDataPointTypeNormal) {
        for (NSMutableDictionary* dic in self.pointValueDics) {
            if (point == dic[pointKey]) {
                angle = [dic[valueKey] doubleValue];
            }
        }
    }
    return angle;
}

/*
 * 用一个角度值，获取最近扇区的Index
 */
-(NSUInteger)findIndexOfSlide:(CGFloat)angle {
    if (angle != 0) {
        angle = 2 - angle;
    }
    NSUInteger index = 0;
    for (int i = 0; i < self.pieSlices.count; i++) {
        if (REMIsNilOrNull(self.pieSlices) || REMIsNilOrNull(self.pieSlices[i])) continue;
        DCPieSlice slice;
        [self.pieSlices[i] getValue:&slice];
        if (slice.sliceEnd > angle) {
            index = i;
            break;
        }
    }
    return index;
}
/*
 * 用一个角度值，获取最近的扇区的中轴角度。
 */
-(CGFloat)findNearbySliceCenter:(CGFloat)angle {
    DCPieSlice slice;
    NSUInteger index = [self findIndexOfSlide:angle];
    NSValue* val = self.pieSlices[index];
    if (!REMIsNilOrNull(val)) {
        [val getValue:&slice];
        return slice.sliceCenter;
    } else {
        return 0;
    }
}

@end
