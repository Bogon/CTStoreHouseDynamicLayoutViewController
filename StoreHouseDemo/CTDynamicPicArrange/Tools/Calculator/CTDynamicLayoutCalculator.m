//
//  CTDynamicLayoutCalculator.m
//  StoreHouseDemo
//
//  Created by casa on 7/9/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicLayoutCalculator.h"

NSString * const kCTDynamicLayoutCalculatorInfoKeyView = @"kCTDynamicLayoutCalculatorInfoKeyView";
NSString * const kCTDynamicLayoutCalculatorInfoKeyFrame = @"kCTDynamicLayoutCalculatorInfoKeyFrame";

NSString * const kCTDynamicLayoutCalculatorViewInfoToCommitKeyFrame = @"kCTDynamicLayoutCalculatorViewInfoToCommitKeyFrame";
NSString * const kCTDynamicLayoutCalculatorViewInfoToCommitKeyView = @"kCTDynamicLayoutCalculatorViewInfoToCommitKeyView";
//NSString * const kCTDynamicLayoutCalculatorViewInfoToCommitKeyUpLeftPoint = @"kCTDynamicLayoutCalculatorViewInfoToCommitKeyUpLeftPoint";
//NSString * const kCTDynamicLayoutCalculatorViewInfoToCommitKeyDownRightPoint = @"kCTDynamicLayoutCalculatorViewInfoToCommitKeyDownRightPoint";

NSString * const kCTDynamicLayoutCalculatorViewInfoKeyUpLeftPoint = @"kCTDynamicLayoutCalculatorViewInfoKeyUpLeftPoint";
NSString * const kCTDynamicLayoutCalculatorViewInfoKeyDownRightPoint = @"kCTDynamicLayoutCalculatorViewInfoKeyDownRightPoint";
NSString * const kCTDynamicLayoutCalculatorViewInfoKeyWidth = @"kCTDynamicLayoutCalculatorViewInfoKeyWidth";
NSString * const kCTDynamicLayoutCalculatorViewInfoKeyHeight = @"kCTDynamicLayoutCalculatorViewInfoKeyHeight";
NSString * const kCTDynamicLayoutCalculatorViewInfoKeyView = @"kCTDynamicLayoutCalculatorViewInfoKeyView";

@interface CTDynamicLayoutCalculator ()

@property (nonatomic, assign, readwrite) CGFloat itemGap;
@property (nonatomic, assign, readwrite) CGFloat gridLength;

@property (nonatomic, strong) NSMutableDictionary *roomInfo;

@property (nonatomic, strong) NSMutableDictionary *spaceMap;
@property (nonatomic, strong) NSMutableArray *viewInfoToCommit;

@property (nonatomic, assign) NSInteger minWidth;
@property (nonatomic, assign) NSInteger maxWidth;
@property (nonatomic, assign) NSInteger minHeight;
@property (nonatomic, assign) NSInteger maxHeight;

@end

@implementation CTDynamicLayoutCalculator

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _minWidth = 2;
        _maxWidth = 6;
        _minHeight = 2;
        _maxHeight = 12;
    }
    return self;
}

#pragma mark - public methods

- (void)updateLayoutWithView:(UIView *)view
{
    
}

- (void)addViews:(NSArray *)viewList
{
    
}

- (void)deleteView:(UIView *)view
{
    
}

- (NSArray *)recalculateFromCoordinator:(CGPoint)coordinatorPoint
{
    NSArray *viewListToRecalculate = [self viewsBelowYCoordinator:coordinatorPoint.y];
    [viewListToRecalculate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *viewItem, NSUInteger idx, BOOL *stop) {
        [self removeFromMapWithView:viewItem];
    }];
    [self addViewItemList:viewListToRecalculate fromPoint:coordinatorPoint];
    return viewListToRecalculate;
}

#pragma mark - location methods

- (NSArray *)viewsBelowYCoordinator:(NSInteger)yCoordinator
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [self.superView.subviews enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *viewItem, NSUInteger idx, BOOL *stop) {
        if ([viewItem isKindOfClass:[CTDynamicBaseViewItem class]]) {
            if (viewItem.upLeftPoint.y >= yCoordinator) {
                [mutableArray addObject:viewItem];
            }
        }
    }];
    return mutableArray;
}

- (void)removeFromMapWithView:(CTDynamicBaseViewItem *)viewItem
{
    NSInteger xStartIndex = viewItem.upLeftPoint.x;
    NSInteger yStartIndex = viewItem.upLeftPoint.y;
    NSInteger xEndIndex = xStartIndex + viewItem.coordinateWidth;
    NSInteger yEndIndex = yStartIndex + viewItem.coordinateHeight;
    
    for (NSInteger xIndex = xStartIndex; xStartIndex <= xEndIndex; xStartIndex++) {
        for (NSInteger yIndex = yStartIndex; yStartIndex <= yEndIndex; yStartIndex++) {
            NSValue *key = [NSValue valueWithCGPoint:CGPointMake(xIndex, yIndex)];
            [self.spaceMap removeObjectForKey:key];
        }
    }
}

- (void)markWithView:(CTDynamicBaseViewItem *)view
{
    CGPoint upLeftCoordinator = view.upLeftPoint;
    for (NSInteger xIndex = 0; xIndex < view.coordinateWidth; xIndex++) {
        for (NSInteger yIndex = 0; yIndex < view.coordinateHeight; yIndex++) {
            NSValue *key = [NSValue valueWithCGPoint:CGPointMake(xIndex+upLeftCoordinator.x, yIndex+upLeftCoordinator.y)];
            self.spaceMap[key] = view;
        }
    }
}

- (void)addViewItemList:(NSArray *)viewItemList fromPoint:(CGPoint)fromPoint
{
    for (CTDynamicBaseViewItem *viewItem in viewItemList) {
        viewItem.upLeftPoint = [self pointForView:viewItem fromPoint:fromPoint];
        [self markWithView:viewItem];
    }
}

- (CGPoint)pointForView:(CTDynamicBaseViewItem *)viewItem fromPoint:(CGPoint)fromPoint
{
    CGPoint resultUpLeftPoint;
    
    BOOL shouldBreak = NO;
    for (NSInteger yIndex = fromPoint.y; true; yIndex++) {
        for (NSInteger xIndex = 0; xIndex < 6; xIndex++) {
            resultUpLeftPoint = CGPointMake(xIndex, yIndex);
            if ([self isFitForView:viewItem atPoint:resultUpLeftPoint]) {
                shouldBreak = YES;
                break;
            }
        }
        if (shouldBreak) {
            break;
        }
    }
    
    return resultUpLeftPoint;
}

- (BOOL)isFitForView:(CTDynamicBaseViewItem *)view atPoint:(CGPoint)point
{
    
    NSInteger xEndIndex = point.x + view.coordinateWidth;
    NSInteger yEndIndex = point.y + view.coordinateHeight;
    
    if (xEndIndex > 6) {
        return NO;
    }
    
    BOOL isFit = YES;
    for (NSInteger yIndex = point.y; yIndex <= yEndIndex; yIndex++) {
        for (NSInteger xIndex = point.x; xIndex <= xEndIndex; xIndex++) {
            NSValue *key = [NSValue valueWithCGPoint:CGPointMake(xIndex, yIndex)];
            if (self.spaceMap[key]) {
                isFit = NO;
                break;
            }
        }
        if (!isFit) {
            break;
        }
    }
    
    return isFit;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)spaceMap
{
    if (_spaceMap == nil) {
        _spaceMap = [[NSMutableDictionary alloc] init];
    }
    return _spaceMap;
}

- (NSMutableDictionary *)roomInfo
{
    if (_roomInfo == nil) {
        _roomInfo = [[NSMutableDictionary alloc] init];
    }
    return _roomInfo;
}

- (NSMutableArray *)viewInfoToCommit
{
    if (_viewInfoToCommit == nil) {
        _viewInfoToCommit = [[NSMutableArray alloc] init];
    }
    return _viewInfoToCommit;
}

- (CGFloat)itemGap
{
    return 3;
}

- (CGFloat)gridLength
{
    if (_gridLength == 0) {
        _gridLength = self.superView.frame.size.width / 6.0f;
    }
    return _gridLength;
}
@end
















