//
//  CTDynamicLayoutBottomBar.m
//  StoreHouseDemo
//
//  Created by casa on 15/7/12.
//  Copyright (c) 2015年 casa. All rights reserved.
//

#import "CTDynamicLayoutBottomBar.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicLayoutBottomBar ()

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *textFieldButton;

@end

@implementation CTDynamicLayoutBottomBar

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageButton];
        [self addSubview:self.cameraButton];
        [self addSubview:self.textFieldButton];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat gap = (self.width - self.height * 3) / 4.0f;
    
    self.imageButton.size = CGSizeMake(self.height, self.height);
    [self.imageButton leftInContainer:gap shouldResize:NO];
    [self.imageButton centerYEqualToView:self];
    
    [self.cameraButton sizeEqualToView:self.imageButton];
    [self.cameraButton right:gap FromView:self.imageButton];
    [self.cameraButton centerYEqualToView:self];
    
    [self.textFieldButton sizeEqualToView:self.cameraButton];
    [self.textFieldButton right:gap FromView:self.cameraButton];
    [self.textFieldButton centerYEqualToView:self.textFieldButton];
}

#pragma mark - event response
- (void)didTappedImageButton:(UIButton *)imageButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomBar:didTappedImageButton:)]) {
        [self.delegate bottomBar:self didTappedImageButton:imageButton];
    }
}

- (void)didTappedCameraButton:(UIButton *)cameraButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomBar:didTappedCameraButton:)]) {
        [self.delegate bottomBar:self didTappedCameraButton:cameraButton];
    }
}

- (void)didTappedTextFieldButton:(UIButton *)textFieldButton
{
    // do nothing
}

#pragma mark - getters and setters
- (UIButton *)imageButton
{
    if (_imageButton == nil) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setTitle:@"img" forState:UIControlStateNormal];
        [_imageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(didTappedImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageButton;
}

- (UIButton *)cameraButton
{
    if (_cameraButton == nil) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setTitle:@"cmr" forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(didTappedCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton *)textFieldButton
{
    if (_textFieldButton == nil) {
        _textFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textFieldButton setTitle:@"txt" forState:UIControlStateNormal];
        [_textFieldButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_textFieldButton addTarget:self action:@selector(didTappedTextFieldButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textFieldButton;
}

@end
