//
//  AppDelegate.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppDelegate.h"

#import "AppWindowTool.h"
#import "DataSavePath.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <Carbon/Carbon.h> // kVK_Space; 识别键盘类型 // https://blog.csdn.net/weixin_33862514/article/details/89664156

@interface AppDelegate ()

@property (nonatomic, weak  ) AppWindowTool * appWindowTool;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
#if TARGET_OS_MAC//模拟器
    NSString * macOSInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    if ([[NSFileManager defaultManager] fileExistsAtPath:macOSInjectionPath]) {
        [[NSBundle bundleWithPath:macOSInjectionPath] load];
    }
#endif
    [self bindHotKey:aNotification];
    self.appWindowTool = [AppWindowTool share];
    [self.appWindowTool showBeforeWindows];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self check1];
    });
    
}

- (IBAction)alphaUp:(id)sender {
    [self.appWindowTool alphaUpEvent];
}

- (IBAction)alphaDown:(id)sender {
    [self.appWindowTool alphaDownEvent];
}

- (IBAction)createNewDock:(id)sender {
    [self.appWindowTool createNewDockEvent:CGPointZero];
    // 1. 创建视图控制器，加载xib文件
    // 原文链接：https://blog.csdn.net/fl2011sx/article/details/73252859
    // let sub1ViewController = NSViewController(nibName: "sub1ViewController", bundle: Bundle.main)
    //
    // // 创建窗口，关联控制器
    // let sub1Window = sub1ViewController != nil ? NSWindow(contentViewController: sub1ViewController!) : nil
    //
    // // 初始化窗口控制器
    // sub1WindowController = NSWindowController(window: sub1Window)
    //
    // // 显示窗口
    // sub1WindowController?.showWindow(nil)
    // ————————————————
    
    // 2. 创建一个没有 xib 的 vc 方法.
    // https://stackoverflow.com/questions/34124228/initialize-a-subclass-of-nsviewcontroller-without-a-xib-file
}

- (IBAction)openDbFolder:(id)sender {
    DataSavePath * db = [DataSavePath share];
    [self openPath:db.DBPath];
}

- (void)openPath:(NSString *)path {
    NSURL * url = [NSURL fileURLWithPath:path];
    NSString * folder = [path substringToIndex:path.length - url.lastPathComponent.length];
    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:folder];
}

- (void)check {
    //    NSArray<NSRunningApplication *> * apps =[[NSWorkspace sharedWorkspace] runningApplications];
    //    NSRunningApplication * app = [NSRunningApplication currentApplication];
    //
    //    NSApplicationActivationPolicy policy = NSApplicationActivationPolicyRegular;
    //
    //    for (NSRunningApplication * oneApp in apps) {
    //        if (oneApp.activationPolicy == policy) {
    //            //NSLog(@"oneApp: %@ _ %@", oneApp.description, oneApp.bundleURL);
    //            NSLog(@"oneApp: %@", oneApp.bundleURL);
    //        }
    //
    //        //oneApp.
    //        //if (app == oneApp) {
    //        //    NSLog(@"111");
    //        //}
    //    }
    //
}

- (void)check1 {
    NSWorkspace * work = [NSWorkspace sharedWorkspace];
    [RACObserve(work, runningApplications) subscribeNext:^(id  _Nullable x) {
        //NSLog(@"111");
        NSArray<NSRunningApplication *> * appAppArray =[work runningApplications];
        //NSMutableArray * appNormalArray = [NSMutableArray new];
        NSMutableSet * appSet = [NSMutableSet new];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        for (NSRunningApplication * oneApp in appAppArray) {
            if (oneApp.activationPolicy == NSApplicationActivationPolicyRegular) {
                //NSLog(@"oneApp: %@ _ %@", oneApp.description, oneApp.bundleURL);
                //NSLog(@"oneApp: %@", oneApp.bundleURL);
                //[appNormalArray addObject:oneApp];
                [appSet addObject:oneApp.bundleURL.absoluteString];
                [dic setObject:oneApp forKey:oneApp.bundleURL.absoluteString];
            }
        }
        //NSLog(@"appSet: %@", appSet);
        NSArray * windowArray = [NSApplication sharedApplication].windows;
        for (FloatWindow * window in windowArray) {
            if ([window isMemberOfClass:[FloatWindow class]]) {
                ViewController * vc = (ViewController *)window.contentViewController;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [vc checkActive:appSet dic:dic];
                });
            }
        }
    }];
}


- (void)bindHotKey:(NSNotification *)aNotification {
    // 全局监听事件 链接：https://blog.csdn.net/ZhangWangYang/article/details/95952046

    // 全局
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^(NSEvent * event) {
        //NSLog(@"event: %@\n\n", event);
        NSLog(@"全局 修饰符 event: %li", event.modifierFlags);
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyDown | NSEventMaskRightMouseUp handler:^(NSEvent *event){
        NSLog(@"全局 键盘 event: %@", event.characters);
    }];
    
    // 本地 修饰符
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        //NSLog(@"本地 1 event: %li", aEvent.modifierFlags);
        NSLog(@"本地 修饰符 event: %li", aEvent.modifierFlags);
        return aEvent;
    }];
    
    // 本地 键盘
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        //NSLog(@"本地 1 event: %li", aEvent.modifierFlags);
        NSLog(@"本地 键盘 event: '%@'", aEvent.characters);
        return aEvent;
    }];
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

@end
