//
//  CTBaseDynamicViewItem.m
//  StoreHouseDemo
//
//  Created by casa on 7/10/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicBaseViewItem.h"

@interface CTDynamicBaseViewItem ()


@end

@implementation CTDynamicBaseViewItem

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _gridLength = [UIScreen mainScreen].bounds.size.width / 6.0f;
        _itemGap = 3;
        self.layer.zPosition = FLT_MIN + 1;
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDidRecognized:)];
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedSelf:)];
        [tapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

#pragma mark - public methods
- (CGRect)refreshFrame
{
    CGFloat x = self.upLeftPoint.x * self.gridLength + self.itemGap;
    CGFloat y = self.upLeftPoint.y * self.gridLength + self.itemGap;
    CGFloat width = self.coordinateWidth * self.gridLength - self.itemGap * 2;
    CGFloat height = self.coordinateHeight * self.gridLength - self.itemGap * 2;
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
    self.coordinateWidth = self.downRightPoint.y - self.upLeftPoint.y;
    self.coordinateHeight = self.downRightPoint.x - self.downRightPoint.x;
}

- (void)makeRandomeSize
{
    NSInteger width = arc4random_uniform(6);
    NSInteger height = arc4random_uniform(6);
    
    self.coordinateWidth = (width < 2) ? 2 : width;
    self.coordinateHeight = (height < 2) ? 2 : height;
}

- (BOOL)containsPoint:(CGPoint)point
{
    BOOL result = NO;
    
    NSInteger minX = (NSInteger)ceil(self.frame.origin.x / self.gridLength);
    NSInteger minY = (NSInteger)ceil(self.frame.origin.y / self.gridLength);
    NSInteger maxX = minX + self.coordinateWidth;
    NSInteger maxY = minY + self.coordinateHeight;
    
    if (minX > 0) {
        minX-=2;
    }
    
    if (minY > 0) {
        minY-=2;
    }
    
    maxX+=2;
    maxY+=2;
    
    if (point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY) {
        result = YES;
    }
    return result;
}

#pragma mark - event response
- (void)longPressDidRecognized:(UILongPressGestureRecognizer *)longPressRecognizer
{
    UIGestureRecognizerState state = longPressRecognizer.state;
    
    if (state == UIGestureRecognizerStateBegan) {
        [self activate];
    }
    
    if (state == UIGestureRecognizerStateChanged) {
        self.layer.zPosition = FLT_MAX;
        self.center =[longPressRecognizer locationInView:self.superview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemDidChangedPosition:)]) {
            [self.delegate dynamicViewItemDidChangedPosition:self];
        }
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateRecognized) {
        [self deactivate];
    }
}

- (void)didTappedSelf:(UIGestureRecognizer *)gestureRecognizer
{
    self.isSelected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemShowEditBar:)]) {
        [self.delegate dynamicViewItemShowEditBar:self];
    }
}

#pragma mark - private methods
- (void)activate
{
    self.isSelected = YES;
    self.layer.zPosition = FLT_MAX;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemDidChangedSelect:)]) {
        [self.delegate dynamicViewItemDidChangedSelect:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemHideEditBar:)]) {
        [self.delegate dynamicViewItemHideEditBar:self];
    }

    CGRect newFrame = self.frame;
    newFrame.origin.x -= 5;
    newFrame.origin.y -= 5;
    newFrame.size.width += 10;
    newFrame.size.height += 10;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.frame = newFrame;
    }];
}

- (void)deactivate
{
    CGRect newFrame = self.frame;
    newFrame.origin.x += 5;
    newFrame.origin.y += 5;
    newFrame.size.width -= 10;
    newFrame.size.height -= 10;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.shadowColor = [[UIColor clearColor] CGColor];
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0.0;
        self.frame = [self refreshFrame];
    } completion:^(BOOL finished) {
        self.layer.zPosition = FLT_MIN + 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemShowEditBar:)]) {
            [self.delegate dynamicViewItemShowEditBar:self];
        }
    }];
}

#pragma mark - getters and setters
- (CGPoint)downRightPoint
{
    return CGPointMake(self.upLeftPoint.x + self.coordinateWidth, self.upLeftPoint.y + self.coordinateHeight);
}

- (void)setDownRightPoint:(CGPoint)downRightPoint
{
    self.coordinateWidth = downRightPoint.x - self.upLeftPoint.x;
    self.coordinateHeight = downRightPoint.y - self.upLeftPoint.y;
}

- (void)setIsSelected:(BOOL)isSelected
{
    BOOL shouldDelegate = YES;
    if (_isSelected == isSelected) {
        shouldDelegate = NO;
    }
    
    _isSelected = isSelected;

    if (shouldDelegate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemDidChangedSelect:)]) {
            [self.delegate dynamicViewItemDidChangedSelect:self];
        }
    }
    
}

@end
