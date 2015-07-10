//
//  CTDynamicTextFieldItem.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicBaseViewItem.h"

typedef NS_ENUM(NSUInteger, CTDynamicTextFieldItemFontStyle) {
    CTDynamicTextFieldEditBarFontStyleHeader,
    CTDynamicTextFieldEditBarFontStyleQuote,
    CTDynamicTextFieldEditBarFontStyleNormal
};

@protocol CTDynamicTextFieldItemDelegate;

@interface CTDynamicTextFieldItem : CTDynamicBaseViewItem

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CTDynamicTextFieldItemFontStyle fontStyle;

@property (nonatomic, weak) id<CTDynamicTextFieldItemDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *textField;

- (instancetype)initWithFontStyle:(CTDynamicTextFieldItemFontStyle)style;
- (void)sizeToFit;

@end

@protocol CTDynamicTextFieldItemDelegate <NSObject>

- (void)textFieldItemDidChangedFrame:(CTDynamicTextFieldItem *)textFieldItem;
- (void)textFieldItemDidChangedSelect:(CTDynamicTextFieldItem *)textFieldItem;

@end