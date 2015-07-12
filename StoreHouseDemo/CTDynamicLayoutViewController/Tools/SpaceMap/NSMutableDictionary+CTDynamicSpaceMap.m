//
//  NSMutableDictionary+CTDynamicSpaceMap.m
//  StoreHouseDemo
//
//  Created by casa on 15/7/11.
//  Copyright (c) 2015年 casa. All rights reserved.
//

#import "NSMutableDictionary+CTDynamicSpaceMap.h"

@implementation NSMutableDictionary (CTDynamicSpaceMap)

#pragma mark - public methods
- (void)CTDSM_addView:(CTDynamicBaseViewItem *)view
{
    CGPoint upLeftCoordinator = view.upLeftPoint;
    for (NSInteger xIndex = 0; xIndex < view.coordinateWidth; xIndex++) {
        for (NSInteger yIndex = 0; yIndex < view.coordinateHeight; yIndex++) {
            NSNumber *x = @((NSInteger)xIndex+upLeftCoordinator.x);
            NSNumber *y = @((NSInteger)yIndex+upLeftCoordinator.y);
            if (self[x] == nil) {
                self[x] = [[NSMutableDictionary alloc] init];
            }
            self[x][y] = view;
        }
    }
}

- (void)CTDSM_cleanAll
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableDictionary *item, BOOL *stop) {
        [item removeAllObjects];
    }];
    [self removeAllObjects];
}

- (void)CTDSM_deleteView:(CTDynamicBaseViewItem *)view
{
    for (NSInteger yIndex = 0; yIndex < view.coordinateHeight; yIndex++) {
        for (NSInteger xIndex = 0; xIndex < view.coordinateWidth; xIndex++) {
            [self[@(xIndex+view.upLeftPoint.x)] removeObjectForKey:@(yIndex+view.upLeftPoint.y)];
        }
    }
}

- (CTDynamicBaseViewItem *)CTDSM_viewForPoint:(CGPoint)point
{
    return self[@((NSInteger)point.x)][@((NSInteger)point.y)];
}

- (CGPoint)CTDSM_pointAvailableForView:(CTDynamicBaseViewItem *)view
{
    CGPoint pointAvailable;
    
    BOOL isAvailable = NO;
    for (NSInteger yIndex = 0; true; yIndex++) {
        for (NSInteger xIndex = 0; xIndex < 6; xIndex++) {
            isAvailable = [self isFitForView:view xIndex:xIndex yIndex:yIndex];
            if (isAvailable) {
                pointAvailable = CGPointMake(xIndex, yIndex);
                break;
            }
        }
        if (isAvailable) {
            break;
        }
    }
    
    return pointAvailable;
}

- (NSMutableArray *)CTDSM_viewsInMapOrder
{
    return [self CTDSM_ViewsBelowPoint:CGPointZero];
}

- (NSMutableArray *)CTDSM_ViewsBelowPoint:(CGPoint)point
{
    NSMutableArray *viewList = [[NSMutableArray alloc] init];
    
    BOOL shouldBreak = NO;
    for (NSInteger yIndex = point.y; true; yIndex++) {
        NSInteger emptyCount = 0;
        for (NSInteger xIndex = 0; xIndex < 6; xIndex++) {
            CTDynamicBaseViewItem *view = self[@(xIndex)][@(yIndex)];
            if (view == nil) {
                emptyCount++;
                if (emptyCount >= 6) {
                    shouldBreak = YES;
                    break;
                }
            }
            if (view && ![viewList containsObject:view]) {
                [viewList addObject:view];
            }
        }
        if (shouldBreak) {
            break;
        }
    }
    return viewList;
}

#pragma mark - private methods
- (BOOL)isFitForView:(CTDynamicBaseViewItem *)view xIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    BOOL isFit = YES;
    
    NSInteger width = view.coordinateWidth;
    NSInteger height = view.coordinateHeight;
    
    if (xIndex + width > 6) {
        return NO;
    }
    
    for (NSInteger y = 0; y < height; y++) {
        for (NSInteger x = 0; x < width; x++) {
            if (self[@(x+xIndex)][@(y+yIndex)] != nil) {
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

@end
