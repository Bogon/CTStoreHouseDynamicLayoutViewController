//
//  CTDynamicPicArrangeViewController.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicLayoutViewController.h"

#import "CTDynamicLayoutNavigationBar.h"
#import "CTDynamicLayoutBottomBar.h"

#import "CTDynamicTextFieldViewItem.h"
#import "CTDynamicImageViewItem.h"

#import "CTDynamicImageEditBar.h"
#import "CTDynamicTextFieldEditBar.h"
#import "CTDynamicPicScrollView.h"

#import "CTDynamicLayoutCalculator.h"

@interface CTDynamicLayoutViewController () <CTDynamicLayoutNavigationBarDelegate, CTDynamicBaseViewItemDelegate, CTDynamicImageEditBarDelegate, CTDynamicLayoutBottomBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CTDynamicTextFieldEditBarDelegate>

@property (nonatomic, strong) CTDynamicTextFieldEditBar *textFieldEditBar;
@property (nonatomic, strong) CTDynamicImageEditBar *imageEditBar;
@property (nonatomic, strong) UIView *positionView;

@property (nonatomic, strong) CTDynamicLayoutNavigationBar *navBar;
@property (nonatomic, strong) CTDynamicLayoutBottomBar *bottomBar;
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
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.scrollView topInContainer:40 shouldResize:YES];
    [self.scrollView fillWidth];
    [self.scrollView bottomInContainer:40 shouldResize:YES];
    
    [self dynamicViewItemDidChangedSize:nil];
    
    self.navBar.height = 40;
    [self.navBar leftInContainer:0 shouldResize:YES];
    [self.navBar rightInContainer:0 shouldResize:YES];
    [self.navBar topInContainer:0 shouldResize:NO];
    
    [self.bottomBar fillWidth];
    self.bottomBar.height = 40.0f;
    [self.bottomBar bottomInContainer:0 shouldResize:NO];
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
    [self animateWithTargetViewItem:viewItem viewsToAnimate:viewsToAnimate completion:nil];
}

- (void)dynamicViewItemDidChangedSize:(CTDynamicBaseViewItem *)viewItem
{
    NSArray *viewsToAnimate = [self.calculator calculate];
    [self animateWithTargetViewItem:viewItem viewsToAnimate:viewsToAnimate completion:nil];
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
        frame.size.height += 60;
        frame.origin.y -= 30;
        [self.scrollView scrollRectToVisible:frame animated:YES];
        
        self.positionView.frame = viewItem.frame;
    }
}

- (void)dynamicViewItemHideEditBar:(CTDynamicBaseViewItem *)viewItem
{
    [self.imageEditBar hide];
    [self.textFieldEditBar hide];
}

- (void)dynamicViewItemShowEditBar:(CTDynamicBaseViewItem *)viewItem
{
    if ([viewItem isKindOfClass:[CTDynamicImageViewItem class]]) {
        [self.textFieldEditBar hide];
        self.imageEditBar.targetImageViewItem = (CTDynamicImageViewItem *)viewItem;
        [self.imageEditBar showInView:self.scrollView frame:viewItem.frame];
    }
    if ([viewItem isKindOfClass:[CTDynamicTextFieldViewItem class]]) {
        [self.imageEditBar hide];
        self.textFieldEditBar.targetTextFieldViewItem = (CTDynamicTextFieldViewItem *)viewItem;
        [self.textFieldEditBar showInView:self.scrollView atFrame:viewItem.frame];
    }
}

#pragma mark - CTDynamicImageEditBarDelegate
- (void)imageEditBar:(CTDynamicImageEditBar *)imageEditBar didTappedEditButton:(UIButton *)button
{
#warning todo
}

- (void)imageEditBar:(CTDynamicImageEditBar *)imageEditBar didTappedDeleteButton:(UIButton *)button
{
    [imageEditBar.targetImageViewItem removeFromSuperview];
    [imageEditBar hide];
    self.positionView.frame = CGRectZero;
    NSArray *viewsToAnimate = [self.calculator removeView:imageEditBar.targetImageViewItem];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __block CGFloat maxHeight = 0;
        [viewsToAnimate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *item, NSUInteger idx, BOOL *stop) {
            if ([item isKindOfClass:[CTDynamicBaseViewItem class]]) {
                item.frame = [item refreshFrame];
                if (item.bottom >= maxHeight) {
                    maxHeight = item.bottom;
                }
            }
        }];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, maxHeight + 60);
    }];
}

#pragma mark - CTDynamicTextFieldEditBarDelegate
- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedDeleteButton:(UIButton *)deleteButton
{
    [editBar.targetTextFieldViewItem removeFromSuperview];
    [editBar hide];
    self.positionView.frame = CGRectZero;
    NSArray *viewsToAnimate = [self.calculator removeView:editBar.targetTextFieldViewItem];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __block CGFloat maxHeight = 0;
        [viewsToAnimate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *item, NSUInteger idx, BOOL *stop) {
            if ([item isKindOfClass:[CTDynamicBaseViewItem class]]) {
                item.frame = [item refreshFrame];
                if (item.bottom >= maxHeight) {
                    maxHeight = item.bottom;
                }
            }
        }];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, maxHeight + 60);
    }];
}

- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedEditButton:(UIButton *)editButton
{
#warning can not show keyboard
    [editBar hide];
    editBar.targetTextFieldViewItem.textField.userInteractionEnabled = YES;
    [editBar.targetTextFieldViewItem.textField becomeFirstResponder];
}

#pragma mark - CTDynamicLayoutBottomBarDelegate
- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedImageButton:(UIButton *)button
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedCameraButton:(UIButton *)button
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedTextFieldButton:(UIButton *)button withFontStyle:(CTDynamicTextFieldItemFontStyle)fontStyle
{
    [self dynamicViewItemHideEditBar:nil];
    CTDynamicTextFieldViewItem *textFieldViewItem = [[CTDynamicTextFieldViewItem alloc] initWithFontStyle:fontStyle];
    textFieldViewItem.coordinateHeight = 1;
    textFieldViewItem.delegate = self;
    [self.scrollView addSubview:textFieldViewItem];
    
    CGPoint currentPoint = CGPointMake(0, (NSInteger)floor((self.scrollView.contentOffset.y + self.scrollView.height / 2.0f) / self.calculator.gridLength));
    NSArray *viewsToAnimate = [self.calculator addView:textFieldViewItem nearPoint:currentPoint];
    [self animateWithTargetViewItem:nil viewsToAnimate:viewsToAnimate completion:^(BOOL finished) {
        if (finished) {
            textFieldViewItem.isSelected = YES;
            self.textFieldEditBar.targetTextFieldViewItem = textFieldViewItem;
            [self dynamicViewItemShowEditBar:textFieldViewItem];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    CTDynamicImageViewItem *imageViewItem = [[CTDynamicImageViewItem alloc] initWithImage:image];
    [imageViewItem makeRandomeSize];
    imageViewItem.delegate = self;
    [self.scrollView addSubview:imageViewItem];
    [self.calculator addViews:@[imageViewItem]];
    imageViewItem.frame = [imageViewItem refreshFrame];
    if (imageViewItem.bottom + 60 >= self.scrollView.contentSize.height) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, imageViewItem.bottom + 60);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        CGRect frame = imageViewItem.frame;
        frame.origin.y -= 30;
        frame.size.height += 60;
        [self.scrollView scrollRectToVisible:frame animated:YES];
    }];
}

#pragma mark - CTDynamicLayoutNavigationBarDelegate
- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedCancelButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedPublishButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedSaveButton:(UIButton *)button
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
    
    self.positionView.frame = CGRectZero;
    [self.imageEditBar hide];
    [self.textFieldEditBar hide];
    [self.bottomBar hidePopup];
}

#pragma mark - private methods
- (void)animateWithTargetViewItem:(CTDynamicBaseViewItem *)viewItem viewsToAnimate:(NSArray *)viewsToAnimate completion:(void(^)(BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        CGRect newFrame = [viewItem refreshFrame];
        __block CGFloat maxHeight = newFrame.origin.y + newFrame.size.height;
        [viewsToAnimate enumerateObjectsUsingBlock:^(CTDynamicBaseViewItem *item, NSUInteger idx, BOOL *stop) {
            if ([item isKindOfClass:[CTDynamicBaseViewItem class]]) {
                if (item != viewItem) {
                    item.frame = [item refreshFrame];
                    if (item.bottom >= maxHeight) {
                        maxHeight = item.bottom;
                    }
                }
            }
        }];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, maxHeight + 60);
        strongSelf.positionView.frame = [viewItem refreshFrame];
    } completion:completion];
}

#pragma mark - getters and setters
- (CTDynamicLayoutNavigationBar *)navBar
{
    if (_navBar == nil) {
        _navBar = [[CTDynamicLayoutNavigationBar alloc] init];
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
        
        [_scrollView addSubview:self.positionView];
        
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

- (UIView *)positionView
{
    if (_positionView == nil) {
        _positionView = [[UIView alloc] init];
        _positionView.backgroundColor = [UIColor grayColor];
        _positionView.layer.zPosition = FLT_MIN;
    }
    return _positionView;
}

- (CTDynamicImageEditBar *)imageEditBar
{
    if (_imageEditBar == nil) {
        _imageEditBar = [[CTDynamicImageEditBar alloc] init];
        _imageEditBar.delegate = self;
        _imageEditBar.layer.zPosition = FLT_MAX;
    }
    return _imageEditBar;
}

- (CTDynamicTextFieldEditBar *)textFieldEditBar
{
    if (_textFieldEditBar == nil) {
        _textFieldEditBar = [[CTDynamicTextFieldEditBar alloc] init];
        _textFieldEditBar.delegate = self;
        _textFieldEditBar.layer.zPosition = FLT_MAX;
    }
    return _textFieldEditBar;
}

- (CTDynamicLayoutBottomBar *)bottomBar
{
    if (_bottomBar == nil) {
        _bottomBar = [[CTDynamicLayoutBottomBar alloc] init];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

@end
