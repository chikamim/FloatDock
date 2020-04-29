//
//  HotKeyTool.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * HotKeyEnd = @"end";

@interface HotKeyTool : NSObject

@property (nonatomic        ) NSEventModifierFlags flags;
@property (nonatomic, copy  ) NSString * characters;
@property (nonatomic, copy  ) NSString * currentKeyboard;

@property (nonatomic, copy  ) NSSet * runningAppsSet;
@property (nonatomic, copy  ) NSDictionary * runningAppsDic;

+ (instancetype)share;

- (void)bindHotKey:(NSNotification *)aNotification;

@end

NS_ASSUME_NONNULL_END
