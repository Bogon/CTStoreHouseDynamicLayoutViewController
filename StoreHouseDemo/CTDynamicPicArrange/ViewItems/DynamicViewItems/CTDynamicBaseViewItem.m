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
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDidRecognized:)];
        longPressGestureRecognizer.numberOfTapsRequired = 1;
        longPressGestureRecognizer.numberOfTouchesRequired = 1;
        longPressGestureRecognizer.minimumPressDuration = 1;
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedSelf:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

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

#pragma mark - event response
- (void)longPressDidRecognized:(UILongPressGestureRecognizer *)longPressRecognizer
{
    UIGestureRecognizerState state = longPressRecognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        [self activate];
    }
    if (state == UIGestureRecognizerStateChanged) {
    }
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateRecognized) {
        [self deactivate];
    }
}

- (void)didTappedSelf:(UITapGestureRecognizer *)tapGestureRecognizer
{
    self.isSelected = YES;
}

#pragma mark - private methods
- (void)activate
{
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.frame].CGPath;
        self.frame = CGRectMake(self.frame.origin.x - 3, self.frame.origin.y - 3, self.frame.size.width + 6, self.frame.size.height + 6);
    }];
}

- (void)deactivate
{
}

#pragma mark - getters and setters
- (void)makeRandomeSize
{
    NSInteger width = arc4random_uniform(6);
    NSInteger height = arc4random_uniform(6);
    
    self.coordinateWidth = (width < 2) ? 2 : width;
    self.coordinateHeight = (height < 2) ? 2 : height;
}

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
