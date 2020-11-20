//
//  StatusBarTool.h
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusBarTool : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSStatusItem * statusItem;

- (void)updateStatusBarUI;

@end

NS_ASSUME_NONNULL_END
