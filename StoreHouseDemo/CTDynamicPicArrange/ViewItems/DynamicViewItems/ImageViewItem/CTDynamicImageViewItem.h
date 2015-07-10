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

- (instancetype)initWithImage:(UIImage *)image;

@end

