//
//  HotKeyLocal.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * HotKeyEnd = @"#";

@interface HotKeyLocal : NSObject

@property (nonatomic        ) NSEventModifierFlags localFlags;
@property (nonatomic        ) NSInteger  localCode;

@property (nonatomic, copy  ) NSString * localCodeString;
@property (nonatomic, copy  ) NSString * localFlagsString;

@property (nonatomic, copy  ) NSString * localFlagsKey;

+ (instancetype)share;

- (void)monitorKeyboard:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
