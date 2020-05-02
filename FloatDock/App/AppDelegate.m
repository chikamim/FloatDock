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
#import "HotKeyTool.h"

@interface AppDelegate ()

@property (nonatomic, weak  ) AppWindowTool * appWindowTool;
@property (nonatomic, weak  ) HotKeyTool * hotKeyTool;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
#if TARGET_OS_MAC//模拟器
    NSString * macOSInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    if ([[NSFileManager defaultManager] fileExistsAtPath:macOSInjectionPath]) {
        [[NSBundle bundleWithPath:macOSInjectionPath] load];
    }
#endif
    self.hotKeyTool = [HotKeyTool share];
    
    self.appWindowTool = [AppWindowTool share];
    [self.appWindowTool showBeforeWindows];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self check1];
    });
    
    // 增加Finder右键方法: http://www.cocoachina.com/articles/430358
    [NSApp setServicesProvider:self];
    NSUpdateDynamicServices();
}

// http://www.cocoachina.com/articles/430358 
//handleServices:userData:error:
- (void)handleServices:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error {
    if([[pboard types] containsObject:NSFilenamesPboardType]){
        NSArray* fileArray=[pboard propertyListForType:NSFilenamesPboardType];
        // do something...
        NSLog(@"12");
    }
}

- (void)handleServices:(NSPasteboard *)pboard {
    
}

// 在 dock 中新增Menu
//- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
//    NSMenu * menu = [NSMenu new];
//    NSMenuItem *item1   = [[NSMenuItem alloc] initWithTitle:@"新增APP" action:@selector(addAppAction) keyEquivalent:@""];
//    [menu addItem:item1];
//
//    return menu;
//}

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

- (IBAction)openFavoriteWindows:(id)sender {
    [self.appWindowTool openFavoriteWindows];
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
    @weakify(self);
    [RACObserve(work, runningApplications) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        //NSLog(@"111");
        NSArray<NSRunningApplication *> * appAppArray =[work runningApplications];
        //NSMutableArray * appNormalArray = [NSMutableArray new];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        for (NSRunningApplication * oneApp in appAppArray) {
            if (oneApp.activationPolicy == NSApplicationActivationPolicyRegular) {
                //NSLog(@"oneApp: %@ _ %@", oneApp.description, oneApp.bundleURL);
                //NSLog(@"oneApp: %@", oneApp.bundleURL);
                //[appNormalArray addObject:oneApp];
                [dic setObject:oneApp forKey:oneApp.bundleURL.absoluteString];
            }
        }
        self.hotKeyTool.runningAppsDic = dic;
        
        //NSLog(@"appSet: %@", appSet);
        NSArray * windowArray = [NSApplication sharedApplication].windows;
        for (FloatWindow * window in windowArray) {
            if ([window isMemberOfClass:[FloatWindow class]]) {
                ViewController * vc = (ViewController *)window.contentViewController;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [vc checkDockAppActive:dic];
                });
            }
        }
    }];
}


@end
