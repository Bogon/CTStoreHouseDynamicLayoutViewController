//
//  CTBaseDynamicViewItem.m
//  StoreHouseDemo
//
//  Created by casa on 7/10/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicBaseViewItem.h"

@implementation CTDynamicBaseViewItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gridLength = [UIScreen mainScreen].bounds.size.width / 6.0f;
        _itemGap = 3;
    }
    return self;
}

- (CGRect)refreshFrame
{
    CGFloat x = self.upLeftPoint.x * self.gridLength + self.itemGap;
    CGFloat y = self.upLeftPoint.y * self.gridLength + self.itemGap;
    CGFloat width = self.width * self.gridLength - self.itemGap * 2;
    CGFloat height = self.height * self.gridLength - self.itemGap * 2;
    return CGRectMake(x, y, width, height);
}

- (void)refreshCoordinator
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.upLeftPoint = CGPointMake((NSInteger)ceil(x / self.gridLength), (NSInteger)ceil(y / self.gridLength));
    self.downRightPoint = CGPointMake(self.upLeftPoint.x + (NSInteger)ceil(width / self.itemGap), self.upLeftPoint.y + (NSInteger)ceil(height / self.itemGap));
    self.width = self.downRightPoint.y - self.upLeftPoint.y;
    self.height = self.downRightPoint.x - self.downRightPoint.x;
}

#pragma mark - getters and setters
- (void)makeRandomeSize
{
    NSInteger width = arc4random_uniform(6);
    NSInteger height = arc4random_uniform(6);
    
    self.width = (width < 2) ? 2 : width;
    self.height = (height < 2) ? 2 : height;
}

- (CGPoint)downRightPoint
{
    return CGPointMake(self.upLeftPoint.x + self.width, self.upLeftPoint.y + self.height);
}

- (void)setDownRightPoint:(CGPoint)downRightPoint
{
    self.width = downRightPoint.x - self.upLeftPoint.x;
    self.height = downRightPoint.y - self.upLeftPoint.y;
}

@end
