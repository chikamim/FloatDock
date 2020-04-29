//
//  HotKeyTool.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Carbon/Carbon.h> // kVK_Space; 识别键盘类型 // https://blog.csdn.net/weixin_33862514/article/details/89664156
#import "FavoriteAppEntity.h"

@interface HotKeyTool ()

@property (nonatomic, weak  ) FavoriteAppTool * favoriteAppTool;

@end

@implementation HotKeyTool

+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance racBindEvent];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            instance.favoriteAppTool = [FavoriteAppTool share];
        });
    });
    return instance;
}

/**
 // 全局监听事件 链接：https://blog.csdn.net/ZhangWangYang/article/details/95952046
 */
- (void)bindHotKey:(NSNotification *)aNotification {
    @weakify(self);
    // 全局
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^(NSEvent * event) {
        @strongify(self);
        //NSLog(@"event: %@\n\n", event);
        //NSLog(@"全局 修饰符 event: %li", event.modifierFlags);
        
        self.flags = event.modifierFlags;
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyDown handler:^(NSEvent *event){
        //NSLog(@"全局 键盘 event: %@", event.characters);
        @strongify(self);
        
        self.characters = [self keyboard:event.keyCode];
        //NSLog(@"设置字符: %@", event.charactersIgnoringModifiers);
        //NSLog(@"设置字符: %@", self.characters);
    }];
    [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyUp handler:^(NSEvent *event){
        //NSLog(@"全局 键盘 event: %@", event.characters);
        @strongify(self);
        self.characters = @"";
        
    }];
    
    // 本地 修饰符
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        @strongify(self);
        self.flags = event.modifierFlags;
        return event;
    }];
    
    // 本地 键盘
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        @strongify(self);
        self.characters = [NSString stringWithFormat:@"%@%@", [self keyboard:event.keyCode], HotKeyEnd];
        //NSLog(@"设置字符: %@", event.charactersIgnoringModifiers);
        //NSLog(@"设置字符: %@", self.characters);
        return event;
    }];
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        @strongify(self);
        self.characters = @"";
        return event;
    }];
    
}

// 键盘修饰符 https://www.jianshu.com/p/f46a5f5dfed7
- (NSMutableString *)checkFlag:(NSEventModifierFlags)flags {
    NSMutableString * flagsString = [NSMutableString new];
    if (flags & NSEventModifierFlagFunction) {
        [flagsString appendString:@"Fn"];
    }
    if (flags & NSEventModifierFlagShift) {
        [flagsString appendString:@"⇧"];
    }
    if (flags & NSEventModifierFlagControl) {
        [flagsString appendString:@"⌃"];
    }
    if (flags & NSEventModifierFlagOption) {
        [flagsString appendString:@"⌥"];
    }
    if (flags & NSEventModifierFlagCommand) {
        [flagsString appendString:@"⌘"];
    }
    return flagsString;
}

// 键盘字母符 https://blog.csdn.net/weixin_33862514/article/details/89664156
- (NSString *)keyboard:(int)keycode {
    NSString * str;
    switch (keycode) {
        case kVK_ANSI_A:{
            str = @"A";
            break;
        }
        case kVK_ANSI_B:{
            str = @"B";
            break;
        }
        case kVK_ANSI_C:{
            str = @"C";
            break;
        }
        case kVK_ANSI_D:{
            str = @"D";
            break;
        }
        case kVK_ANSI_E:{
            str = @"E";
            break;
        }
        case kVK_ANSI_F:{
            str = @"F";
            break;
        }
        case kVK_ANSI_G:{
            str = @"G";
            break;
        }
        case kVK_ANSI_H:{
            str = @"H";
            break;
        }
        case kVK_ANSI_I:{
            str = @"I";
            break;
        }
        case kVK_ANSI_J:{
            str = @"J";
            break;
        }
        case kVK_ANSI_K:{
            str = @"K";
            break;
        }
        case kVK_ANSI_L:{
            str = @"L";
            break;
        }case kVK_ANSI_M:{
            str = @"M";
            break;
        }
        case kVK_ANSI_N:{
            str = @"N";
            break;
        }
        case kVK_ANSI_O:{
            str = @"O";
            break;
        }
        case kVK_ANSI_P:{
            str = @"P";
            break;
        }
        case kVK_ANSI_Q:{
            str = @"Q";
            break;
        }
        case kVK_ANSI_R:{
            str = @"R";
            break;
        }
        case kVK_ANSI_S:{
            str = @"S";
            break;
        }
        case kVK_ANSI_T:{
            str = @"T";
            break;
        }
        case kVK_ANSI_U:{
            str = @"U";
            break;
        }
        case kVK_ANSI_V:{
            str = @"V";
            break;
        }
        case kVK_ANSI_W:{
            str = @"W";
            break;
        }
        case kVK_ANSI_X:{
            str = @"X";
            break;
        }
        case kVK_ANSI_Y:{
            str = @"Y";
            break;
        }
        case kVK_ANSI_Z:{
            str = @"Z";
            break;
        }
        case kVK_ANSI_0:{
            str = @"0";
            break;
        }
        case kVK_ANSI_1:{
            str = @"1";
            break;
        }
        case kVK_ANSI_2:{
            str = @"2";
            break;
        }
        case kVK_ANSI_3:{
            str = @"3";
            break;
        }
        case kVK_ANSI_4:{
            str = @"4";
            break;
        }
        case kVK_ANSI_5:{
            str = @"5";
            break;
        }
        case kVK_ANSI_6:{
            str = @"6";
            break;
        }
        case kVK_ANSI_7:{
            str = @"7";
            break;
        }
        case kVK_ANSI_8:{
            str = @"8";
            break;
        }
        case kVK_ANSI_9:{
            str = @"9";
            break;
        }
        case kVK_ANSI_Minus:{
            str = @"_";
            break;
        }
        case kVK_ANSI_Equal:{
            str = @"=";
            break;
        }
        case kVK_ANSI_LeftBracket:{
            str = @"[";
            break;
        }
        case kVK_ANSI_RightBracket:{
            str = @"]";
            break;
        }
        case kVK_ANSI_Semicolon:{
            str = @";";
            break;
        }
        case kVK_ANSI_Quote:{
            str = @"'";
            break;
        }
        case kVK_ANSI_Comma:{
            str = @",";
            break;
        }
        case kVK_ANSI_Period:{
            str = @".";
            break;
        }
        case kVK_ANSI_Slash:{
            str = @"/";
            break;
        }
        case kVK_ANSI_Backslash:{
            //str = @"/"; 删除
            break;
        }
            
        default:
            break;
    }
    //NSLog(@"keycode: %i", keycode);
    return str;
    
    //
    //    kVK_ANSI_A                    = 0x00,
    //    kVK_ANSI_S                    = 0x01,
    //    kVK_ANSI_D                    = 0x02,
    //    kVK_ANSI_F                    = 0x03,
    //    kVK_ANSI_H                    = 0x04,
    //    kVK_ANSI_G                    = 0x05,
    //    kVK_ANSI_Z                    = 0x06,
    //    kVK_ANSI_X                    = 0x07,
    //    kVK_ANSI_C                    = 0x08,
    //    kVK_ANSI_V                    = 0x09,
    //    kVK_ANSI_B                    = 0x0B,
    //    kVK_ANSI_Q                    = 0x0C,
    //    kVK_ANSI_W                    = 0x0D,
    //    kVK_ANSI_E                    = 0x0E,
    //    kVK_ANSI_R                    = 0x0F,
    //    kVK_ANSI_Y                    = 0x10,
    //    kVK_ANSI_T                    = 0x11,
    //    kVK_ANSI_1                    = 0x12,
    //    kVK_ANSI_2                    = 0x13,
    //    kVK_ANSI_3                    = 0x14,
    //    kVK_ANSI_4                    = 0x15,
    //    kVK_ANSI_6                    = 0x16,
    //    kVK_ANSI_5                    = 0x17,
    //    kVK_ANSI_Equal                = 0x18,
    //    kVK_ANSI_9                    = 0x19,
    //    kVK_ANSI_7                    = 0x1A,
    //    kVK_ANSI_Minus                = 0x1B,
    //    kVK_ANSI_8                    = 0x1C,
    //    kVK_ANSI_0                    = 0x1D,
    //    kVK_ANSI_RightBracket         = 0x1E,
    //    kVK_ANSI_O                    = 0x1F,
    //    kVK_ANSI_U                    = 0x20,
    //    kVK_ANSI_LeftBracket          = 0x21,
    //    kVK_ANSI_I                    = 0x22,
    //    kVK_ANSI_P                    = 0x23,
    //    kVK_ANSI_L                    = 0x25,
    //    kVK_ANSI_J                    = 0x26,
    //    kVK_ANSI_Quote                = 0x27,
    //    kVK_ANSI_K                    = 0x28,
    //    kVK_ANSI_Semicolon            = 0x29,
    //    kVK_ANSI_Backslash            = 0x2A,
    //    kVK_ANSI_Comma                = 0x2B,
    //    kVK_ANSI_Slash                = 0x2C,
    //    kVK_ANSI_N                    = 0x2D,
    //    kVK_ANSI_M                    = 0x2E,
    //    kVK_ANSI_Period               = 0x2F,
    //    kVK_ANSI_Grave                = 0x32,
    //    kVK_ANSI_KeypadDecimal        = 0x41,
    //    kVK_ANSI_KeypadMultiply       = 0x43,
    //    kVK_ANSI_KeypadPlus           = 0x45,
    //    kVK_ANSI_KeypadClear          = 0x47,
    //    kVK_ANSI_KeypadDivide         = 0x4B,
    //    kVK_ANSI_KeypadEnter          = 0x4C,
    //    kVK_ANSI_KeypadMinus          = 0x4E,
    //    kVK_ANSI_KeypadEquals         = 0x51,
    //    kVK_ANSI_Keypad0              = 0x52,
    //    kVK_ANSI_Keypad1              = 0x53,
    //    kVK_ANSI_Keypad2              = 0x54,
    //    kVK_ANSI_Keypad3              = 0x55,
    //    kVK_ANSI_Keypad4              = 0x56,
    //    kVK_ANSI_Keypad5              = 0x57,
    //    kVK_ANSI_Keypad6              = 0x58,
    //    kVK_ANSI_Keypad7              = 0x59,
    //    kVK_ANSI_Keypad8              = 0x5B,
    //    kVK_ANSI_Keypad9              = 0x5C
}

/**
 1. 如果没有系统权限, 是无法获得全局点击键盘功能的.
 2. 除此之外, mac app 还需打开 app > target > Signing & Capabilities > Signing Certificate.
 */
- (void)alertUserGetSystemKeyboardPermission {
    // MacOS获取辅助功能权限控制鼠标点击事件
    // https://blog.csdn.net/cocos2der/article/details/53393026
    //    let opts = NSDictionary(object: kCFBooleanTrue,
    //                            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    //                ) as CFDictionary
    //
    //    guard AXIsProcessTrustedWithOptions(opts) == true else { return }
    
    NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt : @YES};
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);
    NSLog(@"acc : %i", accessibilityEnabled);
}

- (void)racBindEvent {
    
    @weakify(self);
    RACSignal * signal = [RACSignal combineLatest:@[RACObserve(self, flags), RACObserve(self, characters)] reduce:^id (id flags, NSString * characters){
        @strongify(self);
        //NSLog(@"%@ - %@", flags, characters);
        NSString * key = [[NSString stringWithFormat:@"%@%@", [self checkFlag:[flags integerValue]], characters] lowercaseString];
        return key;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //NSLog(@"监测结果 : %@", x);
        for (FavoriteAppEntity * entity in self.favoriteAppTool.arrayEntity.appArray) {
            if ([entity.hotKey isEqualTo:x]) {
                NSLog(@"找到了");
                [self openAppPath:entity.appPath];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self openAppPath:entity.appPath];
//                });
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self openAppPath:entity.appPath];
//                });
            }
        }
        self.currentKeyboard = x;
    }];
}

- (void)openAppPath:(NSString *)appPath {
    NSString * str = appPath;

    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:str];
        
    {
        // 2. 如果没有运行APP, 则打开最后一个窗口
        NSWorkspaceOpenConfiguration * config = [NSWorkspaceOpenConfiguration configuration];
        config.activates = YES;
        [[NSWorkspace sharedWorkspace] openApplicationAtURL:url configuration:config completionHandler:nil];
    }
    
    // 1. 假如有多个窗口, 则打开所有窗口, 全局运行的需要调换下顺序.
    if ([self.runningAppsSet containsObject:appPath]) {
        NSRunningApplication * runningApp = self.runningAppsDic[appPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [runningApp unhide];
        });
    }
}


@end
