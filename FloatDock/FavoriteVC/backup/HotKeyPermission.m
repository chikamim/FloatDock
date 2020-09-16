//
//  HotKeyPermission.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyPermission.h"
#import <AppKit/AppKit.h>

@implementation HotKeyPermission

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
+ (void)alertUserGetSystemKeyboardPermission {
    // MacOS获取辅助功能权限控制鼠标点击事件
    // https://blog.csdn.net/cocos2der/article/details/53393026
    //    let opts = NSDictionary(object: kCFBooleanTrue,
    //                            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    //                ) as CFDictionary
    //
    // guard AXIsProcessTrustedWithOptions(opts) == true else { return }
    
    
    NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt : (id)kCFBooleanTrue};
    //NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt : (id)kCFBooleanFalse};
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);
    NSLog(@"获取APP读取系统权限 acc : %i", accessibilityEnabled);
    
    if (!accessibilityEnabled) {
        // 打开辅助功能
        NSString *urlString = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility";
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
    }
    
}

@end
