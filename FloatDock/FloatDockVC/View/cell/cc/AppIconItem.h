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

@class AppIconItem;

@protocol AppIconItemProtocol <NSObject>

- (void)open:(AppIconItem *)appIconItem;

- (void)delete:(AppIconItem *)appIconItem;
- (void)moveLeft:(AppIconItem *)appIconItem;
- (void)moveRight:(AppIconItem *)appIconItem;

- (void)favorite:(AppIconItem *)appIconItem;
- (void)getPid:(AppIconItem *)appIconItem;
- (void)lldbFront:(AppIconItem *)appIconItem;
- (void)lldbNormal:(AppIconItem *)appIconItem;

@end


@interface AppIconItem : NSCollectionViewItem

@property (nonatomic, strong) NSButton    * appBT;
@property (nonatomic, strong) NSImageView * activeIV;
@property (nonatomic, strong) NSMenu      * clickMenu;

@property (nonatomic        ) NSInteger   row;
@property (nonatomic, copy  ) NSString    * appPath;

@property (nonatomic, weak  ) NSRunningApplication * runningApp;
@property (nonatomic, weak  ) id<AppIconItemProtocol> delegate;

- (void)updateBtMenu;

@end

NS_ASSUME_NONNULL_END
