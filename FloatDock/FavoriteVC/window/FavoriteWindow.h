//
//  FavoriteWindow.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/30.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FavoriteVC;

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteWindow : NSWindow

@property (nonatomic, weak  ) FavoriteVC * favoriteVC;
- (void)setupWindowForEvents;

@end

NS_ASSUME_NONNULL_END
