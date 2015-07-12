//
//  CTDynamicHorizontalDragPointView.m
//  StoreHouseDemo
//
//  Created by casa on 7/12/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicHorizontalDragPointView.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicHorizontalDragPointView ()

@property (nonatomic, strong) UIView *ballView;

@end

@implementation CTDynamicHorizontalDragPointView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ballView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.ballView rightInContainer:0 shouldResize:NO];
    [self.ballView centerYEqualToView:self];
}

#pragma mark - getters and setters
- (UIView *)ballView
{
    if (_ballView == nil) {
        _ballView = [[UIView alloc] init];
        _ballView.backgroundColor = [UIColor blueColor];
        _ballView.size = CGSizeMake(16, 16);
        _ballView.layer.cornerRadius = 8;
    }
    return _ballView;
}

@end
