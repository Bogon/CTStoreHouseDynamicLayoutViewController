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

@interface CTDynamicTextFieldViewItem : CTDynamicBaseViewItem

@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, assign) CTDynamicTextFieldItemFontStyle fontStyle;

- (instancetype)initWithFontStyle:(CTDynamicTextFieldItemFontStyle)style;
- (void)sizeToFit;

@end
