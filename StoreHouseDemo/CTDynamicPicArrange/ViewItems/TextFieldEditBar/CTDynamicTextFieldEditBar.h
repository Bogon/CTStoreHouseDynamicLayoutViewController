//
//  CTDynamicTextFieldEditBar.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicTextFieldItem.h"

typedef NS_ENUM(NSUInteger, CTDynamicTextFieldEditBarStyle) {
    CTDynamicTextFieldEditBarStyleUndefined,
    CTDynamicTextFieldEditBarStyleDefault,
    CTDynamicTextFieldEditBarStyleFont,
    CTDynamicTextFieldEditBarStyleArrange
};



@protocol CTDynamicTextFieldEditBarDelegate;

@interface CTDynamicTextFieldEditBar : UIView

@property (nonatomic, weak) CTDynamicTextFieldItem *targetViewItem;
@property (nonatomic, weak) id<CTDynamicTextFieldEditBarDelegate> delegate;

@property (nonatomic, readonly, assign) CTDynamicTextFieldEditBarStyle editBarStyle;
@property (nonatomic, readonly, assign) BOOL isShowing;

- (void)showInView:(UIView *)view aboveFrame:(CGRect)aboveFrame;
- (void)hide;

@end

@protocol CTDynamicTextFieldEditBarDelegate <NSObject>

- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedEditButton:(UIButton *)editButton;
- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedDeleteButton:(UIButton *)deleteButton;

@end