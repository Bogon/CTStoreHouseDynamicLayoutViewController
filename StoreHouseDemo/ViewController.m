//
//  ViewController.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "ViewController.h"
#import "CTDynamicLayoutViewController.h"
#import "UIView+LayoutMethods.h"
#import "CTDynamicTextFieldEditBar.h"
#import "CTDynamicImageEditBar.h"
#import "CTDynamicImageViewItem.h"
#import "CTDynamicTextFieldViewItem.h"
#import "CTDynamicLayoutCalculator.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *showButton;

@property (nonatomic, strong) CTDynamicTextFieldEditBar *editBar;
@property (nonatomic, strong) CTDynamicImageViewItem *imageItem;
@property (nonatomic, strong) CTDynamicTextFieldViewItem *textFieldItem;
@property (nonatomic, strong) CTDynamicLayoutCalculator *calculator;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showButton];
    [self.view addSubview:self.imageItem];
    [self.view addSubview:self.textFieldItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showButton.size = CGSizeMake(100, 100);
    [self.showButton centerXEqualToView:self.view];
    [self.showButton centerYEqualToView:self.view];
    
    self.imageItem.size = CGSizeMake(100, 100);
    [self.imageItem topInContainer:50 shouldResize:NO];
    [self.imageItem leftInContainer:50 shouldResize:NO];
    
    [self.textFieldItem sizeToFit];
    [self.textFieldItem leftInContainer:0 shouldResize:YES];
    [self.textFieldItem rightInContainer:0 shouldResize:YES];
    [self.textFieldItem top:3 FromView:self.imageItem];
    
}

#pragma mark - event response
- (void)didTappedShowButton:(UIButton *)button
{
    CTDynamicLayoutViewController *viewController = [[CTDynamicLayoutViewController alloc] initWithImages:@[
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"],
                                                                                                                    [UIImage imageNamed:@"test"]
                                                                                                                    ]];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - getters and setters
- (UIButton *)showButton
{
    if (_showButton == nil) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitle:@"show" forState:UIControlStateNormal];
        [_showButton addTarget:self action:@selector(didTappedShowButton:) forControlEvents:UIControlEventTouchUpInside];
        [_showButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _showButton;
}

- (CTDynamicTextFieldEditBar *)editBar
{
    if (_editBar == nil) {
        _editBar = [[CTDynamicTextFieldEditBar alloc] init];
    }
    return _editBar;
}

- (CTDynamicImageViewItem *)imageItem
{
    if (_imageItem == nil) {
        _imageItem = [[CTDynamicImageViewItem alloc] initWithImage:[UIImage imageNamed:@"test"]];
    }
    return _imageItem;
}

- (CTDynamicTextFieldViewItem *)textFieldItem
{
    if (_textFieldItem == nil) {
        _textFieldItem = [[CTDynamicTextFieldViewItem alloc] initWithFontStyle:CTDynamicTextFieldEditBarFontStyleHeader];
    }
    return _textFieldItem;
}

- (CTDynamicLayoutCalculator *)calculator
{
    if (_calculator == nil) {
        _calculator = [[CTDynamicLayoutCalculator alloc] init];
    }
    return _calculator;
}

@end
