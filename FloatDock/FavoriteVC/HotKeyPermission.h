//
//  HotKeyPermission.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotKeyPermission : NSObject

// MARK: TOOLS

/**
 1. 如果没有系统权限, 是无法获得全局点击键盘功能的.
 2. 除此之外, mac app 还需打开 app > target > Signing & Capabilities > Signing Certificate.
 3. 要想用下面的代码自动在 [系统设置][安全与隐私][隐私][辅助功能] 中包含本APP,需要关闭SandBox.
 */
/**
 沙盒其他相关
 https://www.jianshu.com/p/c8785cb864e9 macOS-Cocoa开发之沙盒机制及访问Sandbox之外的文件
 */
+ (void)alertUserGetSystemKeyboardPermission;

@end

NS_ASSUME_NONNULL_END
