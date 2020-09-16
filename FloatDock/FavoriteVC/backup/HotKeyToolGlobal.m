//
//  HotKeyToolGlobal.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyToolGlobal.h"
#import <AppKit/AppKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <MASShortcut/MASShortcut.h>
//#import "KeyboardConvert.h"

@interface HotKeyToolGlobal ()

@property (nonatomic        ) NSEventModifierFlags globalFlags;
@property (nonatomic, copy  ) NSString * globalKeyString;
@property (nonatomic, copy  ) NSString * globalKey;

@property (nonatomic, strong) NSEvent * globalEvent1;
@property (nonatomic, strong) NSEvent * globalEvent2;
@property (nonatomic, strong) NSEvent * globalEvent3;

@end

@implementation HotKeyToolGlobal


+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyToolGlobal * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance alertUserGetSystemKeyboardPermission];
        [instance racBindEvent];        
    });
    return instance;
}


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
- (void)alertUserGetSystemKeyboardPermission {
    // MacOS获取辅助功能权限控制鼠标点击事件
    // https://blog.csdn.net/cocos2der/article/details/53393026
    //    let opts = NSDictionary(object: kCFBooleanTrue,
    //                            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    //                ) as CFDictionary
    //
    //    guard AXIsProcessTrustedWithOptions(opts) == true else { return }
    
    
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


- (void)racBindEvent {
    
    // 全局
    RACSignal * signalGlobal = [RACSignal combineLatest:@[RACObserve(self, globalKeyString), RACObserve(self, globalKey)] reduce:^id (NSString * flagsString, NSString * key){
        //NSLog(@"全局RAC结果 %@:%@ - %@", flags, flagText, key);
        //NSLog(@"全局RAC结果:%@-%@", flagText, key);
        if (flagsString.length > 0 && key.length>0) {
            return [NSString stringWithFormat:@"%@%@", flagsString, key];
        } else {
            return nil;
        }
    }];
    
    //@weakify(self);
    [[signalGlobal distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        //@strongify(self);
        //NSLog(@"全局监测结果 : %@", x);
        //        if (x) {
        //            NSMutableArray * array = self.favoriteHotkeyDic[x];
        //            for (NSInteger i = 0; i<array.count; i++) {
        //                FavoriteAppEntity * entity = array[i];
        //                //NSLog(@"name: %@", entity.name);
        //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                    [self openAppWindows:entity.path];
        //                });
        //            }
        //            //NSLog(@"全局监测结果 : %@ ---------2 \n", x);
        //        }
    }];
}


- (void)globalMonitorKeyboard:(BOOL)enable {
    if (!enable) {
        if (self.globalEvent1) {
            [NSEvent removeMonitor:self.globalEvent1];
            [NSEvent removeMonitor:self.globalEvent2];
            [NSEvent removeMonitor:self.globalEvent3];
            
            self.globalEvent1 = nil;
            self.globalEvent2 = nil;
            self.globalEvent3 = nil;
        }
    } else {
        if (self.globalEvent1) {
            return;
        }
        @weakify(self);
        // 全局
        self.globalEvent1 = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^(NSEvent * event) {
            @strongify(self);
            //NSLog(@"event: %@\n\n", event);
            //NSLog(@"全局 修饰符 event: %li", event.modifierFlags);
            
            self.globalFlags = event.modifierFlags;
            self.globalKeyString =[MASShortcut shortcutWithEvent:event].modifierFlagsString;
        }];
        
        self.globalEvent2 = [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyDown handler:^(NSEvent *event){
            //NSLog(@"全局 键盘 event: %@", event.characters);
            @strongify(self);
            
            self.globalKey = [MASShortcut shortcutWithEvent:event].keyCodeString; //[KeyboardConvert convertKeyboard:event.keyCode];
            //NSLog(@"设置字符: %@", event.charactersIgnoringModifiers);
            //NSLog(@"设置字符: %@", self.characters);
        }];
        self.globalEvent3 = [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyUp handler:^(NSEvent *event){
            //NSLog(@"全局 键盘 event: %@", event.characters);
            @strongify(self);
            self.globalKey = @"";
            
        }];
    }
}


@end
