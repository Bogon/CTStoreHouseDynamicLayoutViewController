//
//  CTDynamicLayoutCalculator.h
//  StoreHouseDemo
//
//  Created by casa on 7/9/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDynamicBaseViewItem.h"

@protocol CTDynamicLayoutCalculatorDelegate;

// keys in view info
extern NSString * const kCTDynamicLayoutCalculatorInfoKeyView;
extern NSString * const kCTDynamicLayoutCalculatorInfoKeyFrame;

@interface CTDynamicLayoutCalculator : NSObject

@property (nonatomic, weak) id<CTDynamicLayoutCalculatorDelegate> delegate;

@property (nonatomic, weak) UIScrollView *superView;

@property (nonatomic, assign, readonly) CGFloat itemGap;
@property (nonatomic, assign, readonly) CGFloat gridLength;

// just for first use
- (NSArray *)recalculateFromCoordinator:(CGPoint)coordinatorPoint;
- (void)updateLayoutWithView:(UIView *)view;
- (void)addViews:(NSArray *)viewList;
- (void)deleteView:(CTDynamicBaseViewItem *)view;

#pragma mark - methods to test

@end

@protocol CTDynamicLayoutCalculatorDelegate <NSObject>

// update frames here
- (void)layoutCalculator:(CTDynamicLayoutCalculator *)layoutCalculator updateLayoutWithInfo:(NSDictionary *)info;

@end