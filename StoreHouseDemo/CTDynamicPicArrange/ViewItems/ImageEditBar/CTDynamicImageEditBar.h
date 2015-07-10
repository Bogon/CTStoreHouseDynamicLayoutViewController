//
//  CTDynamicImageEditBar.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicImageViewItem.h"

@protocol CTDynamicImageEditBarDelegate;

@interface CTDynamicImageEditBar : UIView

@property (nonatomic, weak) id<CTDynamicImageEditBarDelegate> delegate;
@property (nonatomic, weak) CTDynamicImageViewItem *targetImageViewItem;
@property (nonatomic, assign, readonly) BOOL isShowing;

- (void)showInView:(UIView *)view aboveFrame:(CGRect)aboveFrame;
- (void)hide;

@end

@protocol CTDynamicImageEditBarDelegate <NSObject>

- (void)imageEditBar:(CTDynamicImageEditBar *)imageEditBar didTappedEditButton:(UIButton *)button;
- (void)imageEditBar:(CTDynamicImageEditBar *)imageEditBar didTappedDeleteButton:(UIButton *)button;

@end