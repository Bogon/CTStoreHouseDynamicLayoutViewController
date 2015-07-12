//
//  CTDynamicPicNavigationBar.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTDynamicLayoutNavigationBarDelegate;

@interface CTDynamicLayoutNavigationBar : UIView

@property (nonatomic, weak) id<CTDynamicLayoutNavigationBarDelegate> delegate;

@end

@protocol CTDynamicLayoutNavigationBarDelegate <NSObject>

@optional
- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedCancelButton:(UIButton *)button;
- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedSaveButton:(UIButton *)button;
- (void)navBar:(CTDynamicLayoutNavigationBar *)navBar didTappedPublishButton:(UIButton *)button;

@end
