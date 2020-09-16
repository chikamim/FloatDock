//
//  HotKeyLocal.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyLocal.h"
#import <AppKit/AppKit.h>
#import <MASShortcut/MASShortcut.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface HotKeyLocal ()

@property (nonatomic, strong) NSEvent * localEvent1;
@property (nonatomic, strong) NSEvent * localEvent2;
@property (nonatomic, strong) NSEvent * localEvent3;

@end

@implementation HotKeyLocal


+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyLocal * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance racBindEvent];
    });
    
    return instance;
}

- (void)monitorKeyboard:(BOOL)enable {
    //[[HotKeyMas share] monitorKeyboard:!enable];
    
    if (!enable) {
        if (self.localEvent1) {
            [NSEvent removeMonitor:self.localEvent1];
            [NSEvent removeMonitor:self.localEvent2];
            [NSEvent removeMonitor:self.localEvent3];
            
            self.localEvent1 = nil;
            self.localEvent2 = nil;
            self.localEvent3 = nil;
        }
    } else {
        if (self.localEvent1) {
            return;
        }
        @weakify(self);
        // 本地 修饰符
        self.localEvent1 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            self.localFlags = event.modifierFlags;
            self.localFlagsString = [MASShortcut shortcutWithEvent:event].modifierFlagsString;
            
            return event;
        }];
        
        // 本地 键盘
        self.localEvent2 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            self.localCode = event.keyCode;
            NSString * key = [MASShortcut shortcutWithEvent:event].keyCodeString;
            self.localCodeString = key ? [NSString stringWithFormat:@"%@%@", key, HotKeyEnd] : @"";
            return event;
        }];
        
        self.localEvent3 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            self.localCodeString = @"";
            return event;
        }];
    }
}

// MARK: 监听收集到的键盘事件
- (void)racBindEvent {
    // 本地
    RAC(self, localFlagsKey) = [RACSignal combineLatest:@[RACObserve(self, localFlagsString), RACObserve(self, localCodeString)] reduce:^id (NSString * flagsString, NSString * key){
        return [NSString stringWithFormat:@"%@%@", flagsString, key];
    }];
}

@end
