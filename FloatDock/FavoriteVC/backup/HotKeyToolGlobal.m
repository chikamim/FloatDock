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
#import "HotKeyPermission.h"

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
        [instance racBindEvent];        
    });
    return instance;
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
        
        [HotKeyPermission alertUserGetSystemKeyboardPermission];
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
