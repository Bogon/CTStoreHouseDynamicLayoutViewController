//
//  CTDynamicPicNavigationBar.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicLayoutNavigationBar.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicLayoutNavigationBar ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation CTDynamicLayoutNavigationBar

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.cancelButton];
        [self addSubview:self.saveButton];
        [self addSubview:self.publishButton];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    self.cancelButton.size = CGSizeMake(60.0f, self.height);
    [self.cancelButton leftInContainer:5 shouldResize:NO];
    [self.cancelButton centerYEqualToView:self];
    
    self.publishButton.size = CGSizeMake(70.0f, self.height);
    [self.publishButton rightInContainer:5 shouldResize:NO];
    [self.publishButton centerYEqualToView:self.cancelButton];
    
    self.saveButton.size = CGSizeMake(60.0f, self.height);
    [self.saveButton left:3 FromView:self.publishButton];
    [self.saveButton centerYEqualToView:self.cancelButton];
}

#pragma mark - event response
- (void)didTappedCancelButton:(UIButton *)cancelButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBar:didTappedCancelButton:)]) {
        [self.delegate navBar:self didTappedCancelButton:cancelButton];
    }
}

- (void)didTappedSaveButton:(UIButton *)saveButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBar:didTappedSaveButton:)]) {
        [self.delegate navBar:self didTappedSaveButton:saveButton];
    }
}

- (void)didTappedPublishButton:(UIButton *)publishButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBar:didTappedPublishButton:)]) {
        [self.delegate navBar:self didTappedPublishButton:publishButton];
    }
}

#pragma mark - getters and setters
- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didTappedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(didTappedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)publishButton
{
    if (_publishButton == nil) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(didTappedPublishButton:) forControlEvents:UIControlEventTouchUpInside];
        _publishButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _publishButton;
}

@end
