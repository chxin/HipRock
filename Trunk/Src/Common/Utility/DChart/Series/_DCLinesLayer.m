//
//  _DCLineLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLinesLayer.h"
#import "_DCLineLayerCell.h"
#import "REMColor.h"
#import "DCUtility.h"

NSUInteger const kDCLineLayerCells = 10;

@interface _DCLinesLayer()
@property (nonatomic, strong) NSMutableArray* cellList;
@end

@implementation _DCLinesLayer
-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem {
    self = [super initWithCoordinateSystem:coordinateSystem];
    if (self) {
        self.cellList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateCellsFrameNRange];
}

-(void)updateCellsFrameNRange {
    CGFloat cellWidth = self.frame.size.width / (kDCLineLayerCells - 1);
    if (self.cellList.count == 0) {
        for (int i = 0; i < kDCLineLayerCells; i++) {
            _DCLineLayerCell *cell = [[_DCLineLayerCell alloc]initWithContext:self.graphContext];
            cell.frame = CGRectMake(i*cellWidth, 0, (i+1)*cellWidth, self.frame.size.height);
//            cell.backgroundColor = [REMColor colorByIndex:i].cgColor;
            [self addSublayer:cell];
            [self.cellList addObject:cell];
        }
    }
    BOOL needReRange = (((_DCLineLayerCell *)self.cellList[0]).xRange == nil && self.xRange != nil);
    if (needReRange) {
        double rangeCell = self.xRange.length / (kDCLineLayerCells - 1);
        for (int i = 0; i < kDCLineLayerCells; i++) {
            _DCLineLayerCell *cell = self.cellList[i];
            cell.xRange = [[DCRange alloc]initWithLocation:self.xRange.location+i*rangeCell length:rangeCell];
            cell.frame = CGRectMake(self.frame.size.width * (cell.xRange.location - self.xRange.location) / self.xRange.length, 0, cellWidth, self.frame.size.height);
        }
    }
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCLineSeries class]];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (self.xRange == nil) {
        [super didHRangeChanged:oldRange newRange:newRange];
        [self updateCellsFrameNRange];
    } else {
        [super didHRangeChanged:oldRange newRange:newRange];
        CGFloat cellWidth = self.frame.size.width / (kDCLineLayerCells - 1);
        BOOL caTransationState = CATransaction.disableActions;
        [CATransaction setDisableActions:YES];
        for (int i = 0; i < kDCLineLayerCells; i++) {
            _DCLineLayerCell *cell = self.cellList[i];
            CGRect toFrame = CGRectMake(self.frame.size.width * (cell.xRange.location - self.xRange.location) / self.xRange.length, 0, cellWidth, self.frame.size.height);
            if ([DCUtility isFrame:toFrame visableIn:self.bounds]) {
                cell.frame = toFrame;
            } else {
                DCRange* newRange;
                if (toFrame.origin.x < 0) {
                    newRange = [[DCRange alloc]initWithLocation:cell.xRange.location + self.xRange.length + cell.xRange.length length:cell.xRange.length];
                } else {
                    newRange = [[DCRange alloc]initWithLocation:cell.xRange.location - self.xRange.length - cell.xRange.length length:cell.xRange.length];
                }
                
                cell.xRange = newRange;
                cell.hidden = YES;
                toFrame = CGRectMake(self.frame.size.width * (cell.xRange.location - self.xRange.location) / self.xRange.length, 0, cellWidth, self.frame.size.height);
                cell.frame = toFrame;
                if ([newRange isVisableIn:self.graphContext.globalHRange]) {
                    [cell setNeedsDisplay];
                }
            }
        }
        [CATransaction setDisableActions:caTransationState];
    }
}
-(void)didYRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [super didYRangeChanged:oldRange newRange:newRange];
    [self setNeedsDisplay];
}

-(void)setNeedsDisplay {
    for (int i = 0; i < kDCLineLayerCells; i++) {
        _DCLineLayerCell *cell = self.cellList[i];
        [cell setNeedsDisplay];
    }
}
@end
