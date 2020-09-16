//
//  AppIconItem.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * AppIconItemKey = @"AppIconItemKey";
static CGFloat  AppIconItemMaxWidth = 45;
static CGFloat  AppIconItemHeight = 45;

@interface AppIconItem : NSCollectionViewItem

@property (nonatomic, strong) NSButton    * appBT;
@property (nonatomic, strong) NSImageView * activeIV;

@end

NS_ASSUME_NONNULL_END
