//
//  CTDynamicPicViewItem.h
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicBaseViewItem.h"

@protocol CTDynamicImageViewItemDelegate;

@interface CTDynamicImageViewItem : CTDynamicBaseViewItem

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<CTDynamicImageViewItemDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;

@end

@protocol CTDynamicImageViewItemDelegate <NSObject>

- (void)imageViewItemDidChangedFrame:(CTDynamicImageViewItem *)imageViewItem;
- (void)imageViewItemDidChangedSelect:(CTDynamicImageViewItem *)imageViewItem;

@end