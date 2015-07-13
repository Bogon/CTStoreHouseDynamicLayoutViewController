//
//  CTDynamicTextFieldEditBar.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicTextFieldEditBar.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicTextFieldEditBar ()

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *fontButton;
@property (nonatomic, strong) UIButton *arrangeButton;
@property (nonatomic, strong) UIButton *deleteButton;

// font
@property (nonatomic, strong) UIButton *normalFontButton;
@property (nonatomic, strong) UIButton *quoteFontButton;
@property (nonatomic, strong) UIButton *headerFontButton;

// arrange
@property (nonatomic, strong) UIButton *leftArrangeButton;
@property (nonatomic, strong) UIButton *centerArrangeButton;
@property (nonatomic, strong) UIButton *rightArrangeButton;

// seperateLines
@property (nonatomic, strong) UIView *seperateLine1;
@property (nonatomic, strong) UIView *seperateLine2;
@property (nonatomic, strong) UIView *seperateLine3;

// style
@property (nonatomic, readwrite, assign) CTDynamicTextFieldEditBarStyle editBarStyle;

@end

@implementation CTDynamicTextFieldEditBar

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.editBarStyle = CTDynamicTextFieldEditBarStyleUndefined;
        self.layer.zPosition = FLT_MAX;
    }
    return self;
}

- (void)layoutSubviews
{
    [self switchToStyle:self.editBarStyle];
}

#pragma mark - public methods
- (void)showInView:(UIView *)view atFrame:(CGRect)frame
{
#warning can not show edit bar
    [self switchToStyle:CTDynamicTextFieldEditBarStyleDefault];
    CGFloat selfWidth = (4 * 40) + 3 + 3*8;
    CGFloat selfHeight = 40 + 6;
    
    CGRect initFrame;
    if (frame.origin.y - selfHeight < 10) {
        initFrame = CGRectMake(frame.origin.x + frame.size.width / 2.0f, (frame.origin.y + frame.size.height) / 2.0f, 0, 0);
    } else {
        initFrame = CGRectMake(frame.origin.x + frame.size.width / 2.0f, frame.origin.y - selfHeight / 2.0f, 0, 0);
    }
    self.frame = initFrame;
    [view addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:1.0 options:0 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = CGRectMake(initFrame.origin.x - selfWidth / 2.0f, initFrame.origin.y - selfHeight / 2.0f, selfWidth, selfHeight);
        strongSelf.frame = frame;
        [strongSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@", strongSelf);
    }];
}

- (void)hide
{
    self.editBarStyle = CTDynamicTextFieldEditBarStyleUndefined;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.centerX, strongSelf.centerY, 0, 0);
        strongSelf.alpha = 0.0f;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (finished) {
            [strongSelf removeFromSuperview];
        }
    }];
}

#pragma mark - switch view
- (void)switchToStyle:(CTDynamicTextFieldEditBarStyle)style
{
    BOOL shouldClean = YES;
    if (style == self.editBarStyle) {
        shouldClean = NO;
    } else {
        self.editBarStyle = style;
    }
    
    if (shouldClean) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    switch (style) {
        case CTDynamicTextFieldEditBarStyleDefault:
            [self switchToDefaultWithClean:shouldClean];
            break;
            
        case CTDynamicTextFieldEditBarStyleArrange:
            [self switchToArrangeWithClean:shouldClean];
            break;
            
        case CTDynamicTextFieldEditBarStyleFont:
            [self switchToFontWithClean:shouldClean];
            break;
            
        default:
            break;
    }
}

- (void)switchToDefaultWithClean:(BOOL)isCleaned
{
    if (isCleaned) {
        [self addSubview:self.editButton];
        [self addSubview:self.fontButton];
        [self addSubview:self.arrangeButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.seperateLine1];
        [self addSubview:self.seperateLine2];
        [self addSubview:self.seperateLine3];
    }
    
    self.editButton.size = CGSizeMake(self.height - 6, self.height - 6);
    [self.editButton leftInContainer:3 shouldResize:NO];
    [self.editButton centerYEqualToView:self];
    
    self.seperateLine1.size = CGSizeMake(1, self.height - 6);
    [self.seperateLine1 right:3 FromView:self.editButton];
    [self.seperateLine1 centerYEqualToView:self];
    
    [self.fontButton sizeEqualToView:self.editButton];
    [self.fontButton right:3 FromView:self.seperateLine1];
    [self.fontButton centerYEqualToView:self];
    
    [self.seperateLine2 sizeEqualToView:self.seperateLine1];
    [self.seperateLine2 right:3 FromView:self.fontButton];
    [self.seperateLine2 centerYEqualToView:self];
    
    [self.arrangeButton sizeEqualToView:self.editButton];
    [self.arrangeButton right:3 FromView:self.seperateLine2];
    [self.arrangeButton centerYEqualToView:self];
    
    [self.seperateLine3 sizeEqualToView:self.seperateLine1];
    [self.seperateLine3 right:3 FromView:self.arrangeButton];
    [self.seperateLine3 centerYEqualToView:self];
    
    [self.deleteButton sizeEqualToView:self.editButton];
    [self.deleteButton right:3 FromView:self.seperateLine3];
    [self.deleteButton centerYEqualToView:self];
}

- (void)switchToFontWithClean:(BOOL)isCleaned
{
    UIButton *button1 = nil;
    UIButton *button2 = nil;
    
    if (self.targetTextFieldViewItem.fontStyle == CTDynamicTextFieldEditBarFontStyleHeader) {
        if (isCleaned) {
            [self addSubview:self.normalFontButton];
            [self addSubview:self.quoteFontButton];
        }
        button1 = self.normalFontButton;
        button2 = self.quoteFontButton;
    }
    if (self.targetTextFieldViewItem.fontStyle == CTDynamicTextFieldEditBarFontStyleNormal) {
        if (isCleaned) {
            [self addSubview:self.headerFontButton];
            [self addSubview:self.quoteFontButton];
        }
        button1 = self.headerFontButton;
        button2 = self.quoteFontButton;
    }
    if (self.targetTextFieldViewItem.fontStyle == CTDynamicTextFieldEditBarFontStyleQuote) {
        if (isCleaned) {
            [self addSubview:self.headerFontButton];
            [self addSubview:self.normalFontButton];
        }
        button1 = self.headerFontButton;
        button2 = self.normalFontButton;
    }

    if (isCleaned) {
        [self addSubview:self.seperateLine1];
    }
    
    button1.size = CGSizeMake(self.height - 6, self.height - 6);
    [button1 leftInContainer:3 shouldResize:NO];
    [button1 centerYEqualToView:self];
    
    self.seperateLine1.size = CGSizeMake(1, self.height - 6);
    [self.seperateLine1 right:3 FromView:button1];
    [self.seperateLine1 centerYEqualToView:self];
    
    [button2 sizeEqualToView:button1];
    [button2 right:3 FromView:self.seperateLine1];
    [button2 centerYEqualToView:self];
}

- (void)switchToArrangeWithClean:(BOOL)isCleaned
{
    if (isCleaned) {
        [self addSubview:self.leftArrangeButton];
        [self addSubview:self.centerArrangeButton];
        [self addSubview:self.rightArrangeButton];
        [self addSubview:self.seperateLine1];
        [self addSubview:self.seperateLine2];
    }
    
    self.leftArrangeButton.size = CGSizeMake(self.height - 6, self.height - 6);
    [self.leftArrangeButton leftInContainer:3 shouldResize:NO];
    [self.leftArrangeButton centerYEqualToView:self];
    
    self.seperateLine1.size = CGSizeMake(1, self.height - 3);
    [self.seperateLine1 right:3 FromView:self.leftArrangeButton];
    [self.seperateLine1 centerYEqualToView:self];
    
    [self.centerArrangeButton sizeEqualToView:self.leftArrangeButton];
    [self.centerArrangeButton right:3 FromView:self.seperateLine1];
    [self.centerArrangeButton centerYEqualToView:self];
    
    [self.seperateLine2 sizeEqualToView:self.seperateLine1];
    [self.seperateLine2 right:3 FromView:self.centerArrangeButton];
    [self.seperateLine2 centerYEqualToView:self];
    
    [self.rightArrangeButton sizeEqualToView:self.leftArrangeButton];
    [self.rightArrangeButton right:3 FromView:self.seperateLine2];
    [self.rightArrangeButton centerYEqualToView:self];
}

#pragma mark - event response
- (void)didTappedEditButton:(UIButton *)editButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEditBar:didTappedEditButton:)]) {
        [self.delegate textFieldEditBar:self didTappedEditButton:editButton];
    }
    [self hide];
}

- (void)didTappedFontButton:(UIButton *)fontButton
{
    CGPoint center = self.center;
    CGFloat selfWidth = 3*4+1+40*2;
    self.frame = CGRectMake(center.x - selfWidth/2.0f, self.y, selfWidth, self.height);
    [self switchToStyle:CTDynamicTextFieldEditBarStyleFont];
}

- (void)didTappedArrangeButton:(UIButton *)arrangeButton
{
    CGPoint center = self.center;
    CGFloat selfWidth = 3*6+2+40*3;
    self.frame = CGRectMake(center.x - selfWidth/2.0f, self.y, selfWidth, self.height);
    [self switchToStyle:CTDynamicTextFieldEditBarStyleArrange];
}

- (void)didTappedDeleteButton:(UIButton *)deleteButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEditBar:didTappedDeleteButton:)]) {
        [self.delegate textFieldEditBar:self didTappedDeleteButton:deleteButton];
    }
    [self hide];
}

- (void)didTappedNormalFontButton:(UIButton *)normalFontButton
{
    self.targetTextFieldViewItem.fontStyle = CTDynamicTextFieldEditBarFontStyleNormal;
    [self hide];
}

- (void)didTappedHeaderFontButton:(UIButton *)headerFontButton
{
    self.targetTextFieldViewItem.fontStyle = CTDynamicTextFieldEditBarFontStyleHeader;
    [self hide];
}

- (void)didTappedQuoteFontButton:(UIButton *)quoteFontButton
{
    self.targetTextFieldViewItem.fontStyle = CTDynamicTextFieldEditBarFontStyleQuote;
    [self hide];
}

- (void)didTappedLeftArrangeButton:(UIButton *)leftArrangeButton
{
    self.targetTextFieldViewItem.textField.textAlignment = NSTextAlignmentLeft;
    [self hide];
}

- (void)didTappedCenterArrangeButton:(UIButton *)centerArrangeButton
{
    self.targetTextFieldViewItem.textField.textAlignment = NSTextAlignmentCenter;
    [self hide];
}

- (void)didTappedRightArrangeButton:(UIButton *)rightArrangeButton
{
    self.targetTextFieldViewItem.textField.textAlignment = NSTextAlignmentRight;
    [self hide];
}

#pragma mark - getters and setters
- (UIButton *)editButton
{
    if (_editButton == nil) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"edit" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(didTappedEditButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)fontButton
{
    if (_fontButton == nil) {
        _fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fontButton setTitle:@"Aa" forState:UIControlStateNormal];
        [_fontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fontButton addTarget:self action:@selector(didTappedFontButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fontButton;
}

- (UIButton *)arrangeButton
{
    if (_arrangeButton == nil) {
        _arrangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrangeButton setTitle:@"arr" forState:UIControlStateNormal];
        [_arrangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_arrangeButton addTarget:self action:@selector(didTappedArrangeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrangeButton;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"del" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didTappedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)normalFontButton
{
    if (_normalFontButton == nil) {
        _normalFontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalFontButton setTitle:@"nor" forState:UIControlStateNormal];
        [_normalFontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_normalFontButton addTarget:self action:@selector(didTappedNormalFontButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _normalFontButton;
}

- (UIButton *)quoteFontButton
{
    if (_quoteFontButton == nil) {
        _quoteFontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quoteFontButton setTitle:@"quote" forState:UIControlStateNormal];
        [_quoteFontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_quoteFontButton addTarget:self action:@selector(didTappedQuoteFontButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quoteFontButton;
}

- (UIButton *)headerFontButton
{
    if (_headerFontButton == nil) {
        _headerFontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerFontButton setTitle:@"header" forState:UIControlStateNormal];
        [_headerFontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_headerFontButton addTarget:self action:@selector(didTappedHeaderFontButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerFontButton;
}

- (UIButton *)leftArrangeButton
{
    if (_leftArrangeButton == nil) {
        _leftArrangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftArrangeButton setTitle:@"left" forState:UIControlStateNormal];
        [_leftArrangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftArrangeButton addTarget:self action:@selector(didTappedLeftArrangeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftArrangeButton;
}

- (UIButton *)centerArrangeButton
{
    if (_centerArrangeButton == nil) {
        _centerArrangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerArrangeButton setTitle:@"center" forState:UIControlStateNormal];
        [_centerArrangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_centerArrangeButton addTarget:self action:@selector(didTappedCenterArrangeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerArrangeButton;
}

- (UIButton *)rightArrangeButton
{
    if (_rightArrangeButton == nil) {
        _rightArrangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightArrangeButton setTitle:@"right" forState:UIControlStateNormal];
        [_rightArrangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightArrangeButton addTarget:self action:@selector(didTappedRightArrangeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightArrangeButton;
}

- (UIView *)seperateLine1
{
    if (_seperateLine1 == nil) {
        _seperateLine1 = [[UIView alloc] init];
        _seperateLine1.backgroundColor = [UIColor whiteColor];
    }
    return _seperateLine1;
}

- (UIView *)seperateLine2
{
    if (_seperateLine2 == nil) {
        _seperateLine2 = [[UIView alloc] init];
        _seperateLine2.backgroundColor = [UIColor whiteColor];
    }
    return _seperateLine2;
}

- (UIView *)seperateLine3
{
    if (_seperateLine3 == nil) {
        _seperateLine3 = [[UIView alloc] init];
        _seperateLine3.backgroundColor = [UIColor whiteColor];
    }
    return _seperateLine3;
}

@end
