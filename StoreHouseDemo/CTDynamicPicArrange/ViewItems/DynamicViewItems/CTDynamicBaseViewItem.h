//
//  CTBaseDynamicViewItem.h
//  StoreHouseDemo
//
//  Created by casa on 7/10/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTDynamicBaseViewItemDelegate;

@interface CTDynamicBaseViewItem : UIView

@property (nonatomic, assign) CGPoint upLeftPoint;
@property (nonatomic, assign) CGPoint downRightPoint;

@property (nonatomic, assign) NSInteger coordinateWidth;
@property (nonatomic, assign) NSInteger coordinateHeight;

@property (nonatomic, assign) CGFloat gridLength;
@property (nonatomic, assign) CGFloat itemGap;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, weak) id<CTDynamicBaseViewItemDelegate> delegate;

- (CGRect)refreshFrame;
- (void)refreshCoordinator;
- (void)makeRandomeSize;

@end

@protocol CTDynamicBaseViewItemDelegate <NSObject>

- (void)dynamicViewItemDidChangedPosition:(CTDynamicBaseViewItem *)viewItem;
- (void)dynamicViewItemDidChangedSize:(CTDynamicBaseViewItem *)viewItem;
- (void)dynamicViewItemDidChangedSelect:(CTDynamicBaseViewItem *)viewItem;

@end
