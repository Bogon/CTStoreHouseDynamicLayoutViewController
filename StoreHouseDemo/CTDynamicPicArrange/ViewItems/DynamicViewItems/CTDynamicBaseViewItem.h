//
//  CTBaseDynamicViewItem.h
//  StoreHouseDemo
//
//  Created by casa on 7/10/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDynamicBaseViewItem : UIView

@property (nonatomic, assign) CGPoint upLeftPoint;
@property (nonatomic, assign) CGPoint downRightPoint;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) CGFloat gridLength;
@property (nonatomic, assign) CGFloat itemGap;

- (CGRect)refreshFrame;
- (void)refreshCoordinator;
- (void)makeRandomeSize;

@end
