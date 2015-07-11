//
//  NSMutableDictionary+CTDynamicSpaceMap.h
//  StoreHouseDemo
//
//  Created by casa on 15/7/11.
//  Copyright (c) 2015年 casa. All rights reserved.
//

#import "CTDynamicBaseViewItem.h"

@interface NSMutableDictionary (CTDynamicSpaceMap)

- (void)CTDSM_addView:(CTDynamicBaseViewItem *)view;
- (void)CTDSM_deleteView:(CTDynamicBaseViewItem *)view;
- (void)CTDSM_cleanAll;
- (NSArray *)CTDSM_viewsInMapOrder;

- (CTDynamicBaseViewItem *)CTDSM_viewForPoint:(CGPoint)point;
- (CGPoint)CTDSM_pointAvailableForView:(CTDynamicBaseViewItem *)view;

@end
