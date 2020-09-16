//
//  KeyboardConvert.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/5/3.
//  Copyright © 2020 王凯庆. All rights reserved.
//

// 后面使用 #import <MASShortcut/MASShortcut.h> 替换

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h> // kVK_Space; 识别键盘类型 // https://blog.csdn.net/weixin_33862514/article/details/89664156

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardConvert : NSObject

// 键盘修饰符 https://www.jianshu.com/p/f46a5f5dfed7
+ (NSString *)convertFlag:(NSEventModifierFlags)flags;

// 键盘字母符 https://blog.csdn.net/weixin_33862514/article/details/89664156
+ (NSString *)convertKeyboard:(int)keycode;


@end

NS_ASSUME_NONNULL_END
