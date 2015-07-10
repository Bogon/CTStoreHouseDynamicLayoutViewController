//
//  CTDynamicPicNavigationBar.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTDynamicPicNavigationBarDelegate;

@interface CTDynamicPicNavigationBar : UIView

@property (nonatomic, weak) id<CTDynamicPicNavigationBarDelegate> delegate;

@end

@protocol CTDynamicPicNavigationBarDelegate <NSObject>

@optional
- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedCancelButton:(UIButton *)button;
- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedSaveButton:(UIButton *)button;
- (void)navBar:(CTDynamicPicNavigationBar *)navBar didTappedPublishButton:(UIButton *)button;

@end
