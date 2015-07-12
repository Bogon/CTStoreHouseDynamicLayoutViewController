//
//  CTDynamicFontStylePicker.m
//  StoreHouseDemo
//
//  Created by casa on 7/12/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicFontStylePicker.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicFontStylePicker ()

@property (nonatomic, strong) UIButton *normalStyleButton;
@property (nonatomic, strong) UIButton *headerStyleButton;
@property (nonatomic, strong) UIButton *quoteStyleButton;

@end

@implementation CTDynamicFontStylePicker

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.normalStyleButton];
        [self addSubview:self.headerStyleButton];
        [self addSubview:self.quoteStyleButton];
        
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    self.normalStyleButton.size = CGSizeMake(self.width, self.height/3.0f);
    [self.normalStyleButton topInContainer:0 shouldResize:NO];
    [self.normalStyleButton centerXEqualToView:self];
    
    [self.headerStyleButton sizeEqualToView:self.normalStyleButton];
    [self.headerStyleButton top:0 FromView:self.normalStyleButton];
    [self.headerStyleButton centerXEqualToView:self];
    
    [self.quoteStyleButton sizeEqualToView:self.normalStyleButton];
    [self.quoteStyleButton top:0 FromView:self.headerStyleButton];
    [self.quoteStyleButton centerXEqualToView:self];
}

#pragma mark - public methods
- (void)showInView:(UIView *)view forView:(UIView *)targetView
{
    CGSize preferedSize = [self preferedSize];
    self.alpha = 0.0f;
    [view addSubview:self];
    
    self.size = preferedSize;
    [self centerXEqualToView:targetView];
    [self top:0 FromView:targetView];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        [self bottom:0 FromView:targetView];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - event response
- (void)didTappedNormalButton:(UIButton *)normalButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontStylePicker:didPickedFontStyle:)]) {
        [self.delegate fontStylePicker:self didPickedFontStyle:CTDynamicTextFieldEditBarFontStyleNormal];
    }
}

- (void)didTappedHeaderButton:(UIButton *)headerButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontStylePicker:didPickedFontStyle:)]) {
        [self.delegate fontStylePicker:self didPickedFontStyle:CTDynamicTextFieldEditBarFontStyleHeader];
    }
}

- (void)didTappedQuoteButton:(UIButton *)quoteButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontStylePicker:didPickedFontStyle:)]) {
        [self.delegate fontStylePicker:self didPickedFontStyle:CTDynamicTextFieldEditBarFontStyleQuote];
    }
}

#pragma mark - private methods
- (CGSize)preferedSize
{
    return CGSizeMake(100, 100);
}

#pragma mark - getters and setters
- (UIButton *)normalStyleButton
{
    if (_normalStyleButton == nil) {
        _normalStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalStyleButton setTitle:@"normal" forState:UIControlStateNormal];
        [_normalStyleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_normalStyleButton addTarget:self action:@selector(didTappedNormalButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _normalStyleButton;
}

- (UIButton *)headerStyleButton
{
    if (_headerStyleButton == nil) {
        _headerStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerStyleButton setTitle:@"header" forState:UIControlStateNormal];
        [_headerStyleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_headerStyleButton addTarget:self action:@selector(didTappedHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerStyleButton;
}

- (UIButton *)quoteStyleButton
{
    if (_quoteStyleButton == nil) {
        _quoteStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quoteStyleButton setTitle:@"quote" forState:UIControlStateNormal];
        [_quoteStyleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_quoteStyleButton addTarget:self action:@selector(didTappedQuoteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quoteStyleButton;
}

@end
