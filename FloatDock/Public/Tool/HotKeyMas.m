//
//  HotKeyMas.m
//  FloatDock
//
//  Created by popor on 2020/9/15.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyMas.h"
#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import <MASShortcut/MASShortcut.h>
#import <MASShortcut/MASShortcutBinder.h>
#import <MASShortcut/MASDictionaryTransformer.h>

#import "HotKeyPermission.h"

NSString * const MMShortcutSettingLockScreen = @"lockScreenShortcut";
NSString * const MMShortcutSettingLockScreen_2 = @"lockScreenShortcut_2";
NSString * const MMShortcutSettingLockScreen_3 = @"lockScreenShortcut_3";

@interface HotKeyMas ()

@property (nonatomic, weak  ) MASShortcutBinder * binder;
@property (nonatomic, weak  ) HotKeyTool * hotKeyTool;

@end

@implementation HotKeyMas

+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyMas * instance;
    dispatch_once(&once, ^{
        instance = [HotKeyMas new];
        instance.binder = [MASShortcutBinder sharedBinder];
        
        //instance.hotKeyTool = [HotKeyTool share];
        
    });
    return instance;
}

- (void)testMasShortCut {
    //MASShortcut是一个用来设置以及修改快捷键的第三方组件，设置快捷键的做法如下：
    
    //1）定义快捷键的唯一标识，比如mac微信的锁屏：
    NSString * key1 = MMShortcutSettingLockScreen;
    NSString * key2 = MMShortcutSettingLockScreen_2;
    NSString * key3 = MMShortcutSettingLockScreen_3;
    
    //2）快捷键标识与相应的动作（action）绑定：
    MASShortcutBinder *binder = [MASShortcutBinder sharedBinder];
    
    [binder setBindingOptions:@{NSValueTransformerNameBindingOption : MASDictionaryTransformerName}];
    
    [binder bindShortcutWithDefaultsKey:key1 toAction:^{
        
    }];
    
    [binder bindShortcutWithDefaultsKey:key2 toAction:^{
        NSLog(@"222");
    }];
    
    [binder bindShortcutWithDefaultsKey:key3 toAction:^{
        NSLog(@"333");
    }];
    
    //3）注册具体的快捷键：
    [binder registerDefaultShortcuts:
     @{
         key1 : [MASShortcut shortcutWithKeyCode:kVK_ANSI_A modifierFlags:(NSEventModifierFlagCommand | NSEventModifierFlagControl)],
         key2 : [MASShortcut shortcutWithKeyCode:kVK_ANSI_4 modifierFlags:(NSEventModifierFlagControl)],
         key3 : [MASShortcut shortcutWithKeyCode:kVK_ANSI_M modifierFlags:(NSEventModifierFlagControl | NSEventModifierFlagOption)],
     }
     ];
    //这样，cmd+ctrl+a就可以对mac微信进行锁屏了。
    
    //    作者：悲观患者
    //链接：https://www.jianshu.com/p/fb4df5321402
    //    来源：简书
    //    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
    
}

- (void)monitorKeyboard:(BOOL)enable {
    if (!self.hotKeyTool) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hotKeyTool = [HotKeyTool share];
            
            [self monitorKeyboard:enable];
        });
        return;
    }
    
    if (enable) {
        @weakify(self);
        NSMutableDictionary * dic = [NSMutableDictionary new];
        for (FavoriteAppEntity * ae in self.hotKeyTool.favoriteAppArrayEntity.array) {
            if (ae.enable && ae.hotKey.length>0) {
                NSString * url = ae.path;
                NSLog(@"监听键盘点击 url: %@, hotkey:%@, code:%li, flag:%li", url, ae.hotKey, ae.codeNum, ae.flagNum);
                
                [self.binder bindShortcutWithDefaultsKey:ae.hotKey toAction:^{
                    @strongify(self);
                    
                    //NSLog(@"open url: %@", url);
                    [self.hotKeyTool openAppWindows:url];
                }];
                dic[ae.hotKey] = [MASShortcut shortcutWithKeyCode:ae.codeNum modifierFlags:ae.flagNum];
            }
        }
        
        [self.binder registerDefaultShortcuts:dic];
        
    } else {
        
        for (FavoriteAppEntity * ae in self.hotKeyTool.favoriteAppArrayEntity.array) {
            if (ae.enable && ae.hotKey.length>0) {
                [self.binder breakBindingWithDefaultsKey:ae.hotKey];
            }
        }
    }
}

@end
