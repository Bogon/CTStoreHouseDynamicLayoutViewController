//
//  CTDynamicLayoutCalculator.m
//  StoreHouseDemo
//
//  Created by casa on 7/9/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicLayoutCalculator.h"
#import "NSMutableDictionary+CTDynamicSpaceMap.h"

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
- (void)addViews:(NSArray *)viewList
{
    [viewList enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *view, NSUInteger idx, BOOL *stop) {
        view.upLeftPoint = [self.spaceMap CTDSM_pointAvailableForView:view];
        [self.spaceMap CTDSM_addView:view];
    }];
}

- (NSArray *)deleteView:(CTDynamicBaseViewItem *)view
{
    [self.spaceMap CTDSM_deleteView:view];
    return [self calculate];
}

- (NSArray *)calculate
{
    NSArray *viewListToRecalculate = [self.spaceMap CTDSM_viewsInMapOrder];
    if ([viewListToRecalculate count] == 0) {
        viewListToRecalculate = self.superView.subviews;
    }
    [self.spaceMap CTDSM_cleanAll];
    [viewListToRecalculate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[CTDynamicBaseViewItem class]]) {
            view.upLeftPoint = [self.spaceMap CTDSM_pointAvailableForView:view];
            [self.spaceMap CTDSM_addView:view];
        }
    }];
    return viewListToRecalculate;
}

- (NSArray *)calculateForView:(CTDynamicBaseViewItem *)view
{
    NSMutableDictionary *originSpaceMap = [self.spaceMap mutableCopy];
    
    NSMutableArray *viewListToRecalculate = [self.spaceMap CTDSM_viewsInMapOrder];
    [viewListToRecalculate removeObject:view];
    [self.spaceMap CTDSM_cleanAll];
    
    __block BOOL shouldRollback = YES;
    [viewListToRecalculate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *viewItem, NSUInteger idx, BOOL *stop) {
        if ([viewItem isKindOfClass:[CTDynamicBaseViewItem class]]) {
            if (shouldRollback) {
                if ([view containsPoint:CGPointZero]) {
                    view.upLeftPoint = CGPointZero;
                    [self.spaceMap CTDSM_addView:view];
                    shouldRollback = NO;
                }
            }
            
            viewItem.upLeftPoint = [self.spaceMap CTDSM_pointAvailableForView:viewItem];
            [self.spaceMap CTDSM_addView:viewItem];
            
            if (shouldRollback) {
                CGPoint upLeftPoint = [self.spaceMap CTDSM_pointAvailableForView:view];

                if ([view containsPoint:upLeftPoint]) {
                    view.upLeftPoint = upLeftPoint;
                    [self.spaceMap CTDSM_addView:view];
                    shouldRollback = NO;
                }
            }
        }
    }];
    
    if (shouldRollback) {
        viewListToRecalculate = [originSpaceMap CTDSM_viewsInMapOrder];
    }
    
    return viewListToRecalculate;
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
















