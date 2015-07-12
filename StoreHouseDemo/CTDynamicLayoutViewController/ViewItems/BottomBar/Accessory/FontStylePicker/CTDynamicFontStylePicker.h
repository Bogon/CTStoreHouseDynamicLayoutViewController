//
//  CTDynamicFontStylePicker.h
//  StoreHouseDemo
//
//  Created by casa on 7/12/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicTextFieldViewItem.h"

@protocol CTDynamicFontStylePickerDelegate;

@interface CTDynamicFontStylePicker : UIView

@property (nonatomic, weak) id<CTDynamicFontStylePickerDelegate> delegate;

- (void)showInView:(UIView *)view forView:(UIView *)targetView;
- (void)hide;

@end

@protocol CTDynamicFontStylePickerDelegate <NSObject>

- (void)fontStylePicker:(CTDynamicFontStylePicker *)picker didPickedFontStyle:(CTDynamicTextFieldItemFontStyle)fontStyle;

@end