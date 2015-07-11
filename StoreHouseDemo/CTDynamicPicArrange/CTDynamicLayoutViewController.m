//
//  CTDynamicPicArrangeViewController.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicLayoutViewController.h"
#import "CTDynamicPicNavigationBar.h"

#import "CTDynamicTextFieldItem.h"
#import "CTDynamicImageViewItem.h"

#import "CTDynamicImageEditBar.h"
#import "CTDynamicTextFieldEditBar.h"
#import "CTDynamicPicScrollView.h"

#import "CTDynamicLayoutCalculator.h"

@interface CTDynamicLayoutViewController () <CTDynamicPicNavigationBarDelegate, CTDynamicBaseViewItemDelegate>

@property (nonatomic, strong) CTDynamicTextFieldEditBar *textFieldEditBar;
@property (nonatomic, strong) CTDynamicImageEditBar *imageEditBar;

@property (nonatomic, strong) CTDynamicPicNavigationBar *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CTDynamicLayoutCalculator *calculator;

@end

@implementation CTDynamicLayoutViewController

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
                imageItem.delegate = self;
                [imageItem makeRandomeSize];
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
    
    [self dynamicViewItemDidChangedSize:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - CTDynamicBaseViewItemDelegate
- (void)dynamicViewItemDidChangedPosition:(CTDynamicBaseViewItem *)viewItem
{
    NSArray *viewsToAnimate = [self.calculator calculateForView:viewItem];
    [self animateWithTargetViewItem:viewItem viewsToAnimate:viewsToAnimate];
}

- (void)dynamicViewItemDidChangedSize:(CTDynamicBaseViewItem *)viewItem
{
    NSArray *viewsToAnimate = [self.calculator calculate];
    [self animateWithTargetViewItem:viewItem viewsToAnimate:viewsToAnimate];
}

- (void)dynamicViewItemDidChangedSelect:(CTDynamicBaseViewItem *)viewItem
{
    if (viewItem.isSelected) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *item, NSUInteger idx, BOOL *stop) {
            if ([item isKindOfClass:[CTDynamicBaseViewItem class]] && item != viewItem) {
                item.isSelected = NO;
            }
        }];
        
        CGRect frame = viewItem.frame;
        frame.size.height += 40;
        frame.origin.y -= 20;
        [self.scrollView scrollRectToVisible:frame animated:YES];
    }
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

#pragma mark - event response
- (void)didTappedScrollView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[CTDynamicBaseViewItem class]]) {
            view.isSelected = NO;
        }
    }];
}

#pragma mark - private methods
- (void)animateWithTargetViewItem:(CTDynamicBaseViewItem *)viewItem viewsToAnimate:(NSArray *)viewsToAnimate
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        CGRect newFrame = [viewItem refreshFrame];
        __block CGFloat maxHeight = newFrame.origin.y + newFrame.size.height;
        [viewsToAnimate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *item, NSUInteger idx, BOOL *stop) {
            if (item != viewItem) {
                item.frame = [item refreshFrame];
                if (item.bottom >= maxHeight) {
                    maxHeight = item.bottom;
                }
            }
        }];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, maxHeight + 40);
        newFrame.size.height +=40;
        newFrame.origin.y -= 20;
        [strongSelf.scrollView scrollRectToVisible:newFrame animated:NO];
    }];
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
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedScrollView:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:tapGestureRecognizer];
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
