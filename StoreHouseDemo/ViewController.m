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

@interface ViewController ()

@property (nonatomic, strong) UIButton *showButton;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showButton.size = CGSizeMake(100, 100);
    [self.showButton centerXEqualToView:self.view];
    [self.showButton centerYEqualToView:self.view];
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

@end
