//
//  CTDynamicLayoutBottomBar.h
//  StoreHouseDemo
//
//  Created by casa on 15/7/12.
//  Copyright (c) 2015年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicTextFieldViewItem.h"

@protocol CTDynamicLayoutBottomBarDelegate;

@interface CTDynamicLayoutBottomBar : UIView

@property (nonatomic, weak) id<CTDynamicLayoutBottomBarDelegate> delegate;

@end

@protocol CTDynamicLayoutBottomBarDelegate <NSObject>

- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedImageButton:(UIButton *)button;
- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedCameraButton:(UIButton *)button;
- (void)bottomBar:(CTDynamicLayoutBottomBar *)bottomBar didTappedTextFieldButton:(UIButton *)button withFontStyle:(CTDynamicTextFieldItemFontStyle)fontStyle;

@end