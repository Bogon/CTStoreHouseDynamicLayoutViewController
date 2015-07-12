//
//  CTDynamicTextFieldEditBar.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicTextFieldViewItem.h"

typedef NS_ENUM(NSUInteger, CTDynamicTextFieldEditBarStyle) {
    CTDynamicTextFieldEditBarStyleUndefined,
    CTDynamicTextFieldEditBarStyleDefault,
    CTDynamicTextFieldEditBarStyleFont,
    CTDynamicTextFieldEditBarStyleArrange
};



@protocol CTDynamicTextFieldEditBarDelegate;

@interface CTDynamicTextFieldEditBar : UIView

@property (nonatomic, weak) CTDynamicTextFieldViewItem *targetTextFieldViewItem;
@property (nonatomic, weak) id<CTDynamicTextFieldEditBarDelegate> delegate;

@property (nonatomic, readonly, assign) CTDynamicTextFieldEditBarStyle editBarStyle;

- (void)showInView:(UIView *)view atFrame:(CGRect)frame;
- (void)hide;

@end

@protocol CTDynamicTextFieldEditBarDelegate <NSObject>

- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedEditButton:(UIButton *)editButton;
- (void)textFieldEditBar:(CTDynamicTextFieldEditBar *)editBar didTappedDeleteButton:(UIButton *)deleteButton;

@end