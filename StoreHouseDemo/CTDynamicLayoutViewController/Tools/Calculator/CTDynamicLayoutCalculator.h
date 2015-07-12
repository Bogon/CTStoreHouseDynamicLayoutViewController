//
//  CTDynamicLayoutCalculator.h
//  StoreHouseDemo
//
//  Created by casa on 7/9/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicBaseViewItem.h"

@interface CTDynamicLayoutCalculator : NSObject

@property (nonatomic, weak) UIScrollView *superView;

@property (nonatomic, assign, readonly) CGFloat itemGap;
@property (nonatomic, assign, readonly) CGFloat gridLength;

- (NSArray *)calculate;
- (NSArray *)calculateForView:(CTDynamicBaseViewItem *)view;

- (NSArray *)removeView:(CTDynamicBaseViewItem *)view;
- (NSArray *)deleteView:(CTDynamicBaseViewItem *)view;

- (void)addViews:(NSArray *)viewList;
- (NSArray *)addView:(CTDynamicBaseViewItem *)view nearPoint:(CGPoint)coordinatePoint;

@end