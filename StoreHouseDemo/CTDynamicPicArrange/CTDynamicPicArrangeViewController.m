//
//  CTDynamicPicArrangeViewController.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicPicArrangeViewController.h"
#import "CTDynamicPicNavigationBar.h"

#import "CTDynamicTextFieldItem.h"
#import "CTDynamicImageViewItem.h"

#import "CTDynamicImageEditBar.h"
#import "CTDynamicTextFieldEditBar.h"
#import "CTDynamicPicScrollView.h"

#import "CTDynamicLayoutCalculator.h"

@interface CTDynamicPicArrangeViewController () <CTDynamicPicNavigationBarDelegate>

@property (nonatomic, strong) CTDynamicTextFieldEditBar *textFieldEditBar;
@property (nonatomic, strong) CTDynamicImageEditBar *imageEditBar;

@property (nonatomic, strong) CTDynamicPicNavigationBar *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CTDynamicLayoutCalculator *calculator;

@end

@implementation CTDynamicPicArrangeViewController

#pragma mark - life cycle
- (instancetype)initWithImages:(NSArray *)imageList
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [imageList enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([image isKindOfClass:[UIImage class]]) {
                CTDynamicImageViewItem *imageItem = [[CTDynamicImageViewItem alloc] initWithImage:image];
                [imageItem makeRandomeSize];
                imageItem.backgroundColor = [UIColor grayColor];
                [strongSelf.scrollView addSubview:imageItem];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.navBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.scrollView fill];
    
    self.navBar.height = 40;
    [self.navBar leftInContainer:0 shouldResize:YES];
    [self.navBar rightInContainer:0 shouldResize:YES];
    [self.navBar topInContainer:0 shouldResize:NO];
    
    NSArray *viewArray = [self.calculator recalculateFromCoordinator:CGPointZero];
    for (CTDynamicBaseViewItem *viewItem in viewArray) {
        if ([viewItem isKindOfClass:[CTDynamicBaseViewItem class]]) {
            viewItem.frame = [viewItem refreshFrame];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - CTDynamicPicNavigationBarDelegate
- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedCancelButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedPublishButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedSaveButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (CTDynamicPicNavigationBar *)navBar
{
    if (_navBar == nil) {
        _navBar = [[CTDynamicPicNavigationBar alloc] init];
        _navBar.delegate = self;
    }
    return _navBar;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (CTDynamicLayoutCalculator *)calculator
{
    if (_calculator == nil) {
        _calculator = [[CTDynamicLayoutCalculator alloc] init];
        _calculator.superView = self.scrollView;
    }
    return _calculator;
}

@end
