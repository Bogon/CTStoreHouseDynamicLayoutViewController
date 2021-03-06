//
//  CTDynamicPicViewItem.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicImageViewItem.h"
#import "UIView+LayoutMethods.h"

#import "CTDynamicHorizontalDragPointView.h"
#import "CTDynamicVerticalDragPointView.h"
#import "CTDynamicCornerDragPointView.h"

@interface CTDynamicImageViewItem () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CTDynamicHorizontalDragPointView *horizontalDragPointView;
@property (nonatomic, strong) CTDynamicVerticalDragPointView *verticalDragPointView;
@property (nonatomic, strong) CTDynamicCornerDragPointView *cornerDragPointView;

@end

@implementation CTDynamicImageViewItem

#pragma mark - life cycle
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.upLeftPoint = CGPointZero;
        self.imageView.image = image;
        [self addSubview:self.imageView];
        [self addSubview:self.horizontalDragPointView];
        [self addSubview:self.verticalDragPointView];
        [self addSubview:self.cornerDragPointView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.imageView leftInContainer:5 shouldResize:YES];
    [self.imageView rightInContainer:5 shouldResize:YES];
    [self.imageView topInContainer:5 shouldResize:YES];
    [self.imageView bottomInContainer:5 shouldResize:YES];
    
    self.horizontalDragPointView.size = CGSizeMake(20, self.gridLength);
    [self.horizontalDragPointView rightInContainer:0 shouldResize:NO];
    [self.horizontalDragPointView centerYEqualToView:self];
    
    self.verticalDragPointView.size = CGSizeMake(self.gridLength, 20);
    [self.verticalDragPointView bottomInContainer:0 shouldResize:NO];
    [self.verticalDragPointView centerXEqualToView:self];
    
    self.cornerDragPointView.size = CGSizeMake(self.gridLength / 2.0f + 20, self.gridLength / 2.0f + 20);
    [self.cornerDragPointView rightInContainer:0 shouldResize:NO];
    [self.cornerDragPointView bottomInContainer:0 shouldResize:NO];
}

#pragma mark - event response
- (void)horizontalPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIGestureRecognizerState state = panGestureRecognizer.state;
    
    if (state == UIGestureRecognizerStateBegan) {
        self.layer.zPosition = FLT_MAX;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemHideEditBar:)]) {
            [self.delegate dynamicViewItemHideEditBar:self];
        }
    }
    
    if (state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGestureRecognizer translationInView:self];
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        CGFloat width = [self checkWidthWithPoint:point];
        self.frame = CGRectMake(self.x, self.y, width, self.height);
        
        [self checkShouldDelegate];
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateRecognized) {
        [self panGestureEnded];
    }
}

- (void)verticalPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIGestureRecognizerState state = panGestureRecognizer.state;
    
    if (state == UIGestureRecognizerStateBegan) {
        self.layer.zPosition = FLT_MAX;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemHideEditBar:)]) {
            [self.delegate dynamicViewItemHideEditBar:self];
        }
    }
    
    if (state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGestureRecognizer translationInView:self];
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        CGFloat height = [self checkHeightWithPoint:point];
        self.frame = CGRectMake(self.x, self.y, self.width, height);
        
        [self checkShouldDelegate];
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateRecognized) {
        [self panGestureEnded];
    }
}

- (void)cornerPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIGestureRecognizerState state = panGestureRecognizer.state;
    
    if (state == UIGestureRecognizerStateBegan) {
        self.layer.zPosition = FLT_MAX;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemHideEditBar:)]) {
            [self.delegate dynamicViewItemHideEditBar:self];
        }
    }
    
    if (state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGestureRecognizer translationInView:self];
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        CGFloat width = [self checkWidthWithPoint:point];
        CGFloat height = [self checkHeightWithPoint:point];
        
        self.frame = CGRectMake(self.x, self.y, width, height);
        [self checkShouldDelegate];
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateRecognized) {
        [self panGestureEnded];
    }
}

#pragma mark - private methods
- (CGFloat)checkWidthWithPoint:(CGPoint)point
{
    CGFloat minWidth = self.gridLength;
    CGFloat maxWidth = self.gridLength * 6 - self.itemGap * 2;
    
    CGFloat width = self.width + point.x;
    if (width < minWidth) {
        width = minWidth;
    }
    if (width > maxWidth) {
        width = maxWidth;
    }
    return width;
}

- (CGFloat)checkHeightWithPoint:(CGPoint)point
{
    CGFloat minHeight = self.gridLength;
    CGFloat maxHeight = self.gridLength * 12 - self.itemGap * 2;
    
    CGFloat height = self.height + point.y;
    if (height < minHeight) {
        height = minHeight;
    }
    if (height > maxHeight) {
        height = maxHeight;
    }
    
    return height;
}

- (void)checkShouldDelegate
{
    NSInteger coordinateWidth = (NSInteger)ceil(self.frame.size.width / self.gridLength);
    if (coordinateWidth < 2) {
        coordinateWidth = 2;
    }
    NSInteger coordinateHeight = (NSInteger)ceil(self.frame.size.height / self.gridLength);
    if (coordinateHeight < 2) {
        coordinateHeight = 2;
    }
    
    BOOL shouldDelegate = NO;
    
    if (coordinateWidth != self.coordinateWidth) {
        shouldDelegate = YES;
        self.coordinateWidth = coordinateWidth;
    }
    if (coordinateHeight != self.coordinateHeight) {
        shouldDelegate = YES;
        self.coordinateHeight = coordinateHeight;
    }
    
    if (shouldDelegate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemDidChangedSize:)]) {
            [self.delegate dynamicViewItemDidChangedSize:self];
        }
    }
}

- (void)panGestureEnded
{
    self.layer.zPosition = FLT_MIN + 1;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = [self refreshFrame];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewItemShowEditBar:)]) {
                [self.delegate dynamicViewItemShowEditBar:self];
            }
        }
    }];
}

#pragma mark - getters and setters
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.borderWidth = 0.0f;
        _imageView.layer.borderColor = [[UIColor blueColor] CGColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (CTDynamicHorizontalDragPointView *)horizontalDragPointView
{
    if (_horizontalDragPointView == nil) {
        _horizontalDragPointView = [[CTDynamicHorizontalDragPointView alloc] init];
        _horizontalDragPointView.alpha = 0.0f;
        _horizontalDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_horizontalDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _horizontalDragPointView;
}

- (CTDynamicVerticalDragPointView *)verticalDragPointView
{
    if (_verticalDragPointView == nil) {
        _verticalDragPointView = [[CTDynamicVerticalDragPointView alloc] init];
        _verticalDragPointView.alpha = 0.0f;
        _verticalDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(verticalPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_verticalDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _verticalDragPointView;
}

- (CTDynamicCornerDragPointView *)cornerDragPointView
{
    if (_cornerDragPointView == nil) {
        _cornerDragPointView = [[CTDynamicCornerDragPointView alloc] init];
        _cornerDragPointView.alpha = 0.0f;
        _cornerDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cornerPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_cornerDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _cornerDragPointView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    if (isSelected) {
        _imageView.layer.borderWidth = 3.0f;
        self.cornerDragPointView.alpha = 1.0f;
        self.verticalDragPointView.alpha = 1.0f;
        self.horizontalDragPointView.alpha = 1.0f;
        self.cornerDragPointView.userInteractionEnabled = YES;
        self.verticalDragPointView.userInteractionEnabled = YES;
        self.horizontalDragPointView.userInteractionEnabled = YES;
    } else {
        _imageView.layer.borderWidth = 0.0f;
        self.cornerDragPointView.alpha = 0.0f;
        self.verticalDragPointView.alpha = 0.0f;
        self.horizontalDragPointView.alpha = 0.0f;
        self.cornerDragPointView.userInteractionEnabled = NO;
        self.verticalDragPointView.userInteractionEnabled = NO;
        self.horizontalDragPointView.userInteractionEnabled = NO;
    }
}

@end
