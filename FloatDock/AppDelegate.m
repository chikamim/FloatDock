//
//  AppDelegate.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppDelegate.h"
#import "FloatWindow.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, weak  ) AppInfoTool * appInfoTool;
@property (nonatomic        ) CGFloat windowAlpha;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
#if TARGET_OS_MAC//模拟器
    NSString * macOSInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    if ([[NSFileManager defaultManager] fileExistsAtPath:macOSInjectionPath]) {
        [[NSBundle bundleWithPath:macOSInjectionPath] load];
    }
#endif
    self.windowAlpha = 0.45;
    self.appInfoTool = [AppInfoTool share];
    if (self.appInfoTool.appInfoArrayEntity.windowArray.count == 0) {
        AppInfoEntity * entity = [AppInfoEntity new];
        [entity.appPathArray addObject:@""];
        
        [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    }

    for (int i = 0; i<self.appInfoTool.appInfoArrayEntity.windowArray.count; i++) {
        AppInfoEntity * aie = self.appInfoTool.appInfoArrayEntity.windowArray[i];
        //if (i == 0) {
        //    NSWindow * window = [NSApplication sharedApplication].keyWindow;
        //    self.window = window;
        //    [self showNewDock:aie window:window];
        //} else {
        [self showNewDock:aie window:nil];
        //}
    }
    
    //self.window.contentView.layer.cornerRadius = 12;
    //self.window.contentView.layer.masksToBounds = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self check1];
    });
    
}

- (void)setWindowStyle:(NSWindow *)window {
    
    [window setStyleMask:NSWindowStyleMaskBorderless];
    
    //CGRect rect =CGRectMake(window.frame.origin.x, window.frame.origin.y, 400, 60);
    //[window setFrame:rect display:YES];
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    window.hasShadow = NO; // 关闭阴影
    
    [window.contentView.layer setBackgroundColor:[[NSColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:208.0/255.0 alpha:1]CGColor]];
    
    [window setLevel:NSFloatingWindowLevel];
    window.alphaValue = self.windowAlpha;
}

- (IBAction)alphaUp:(id)sender {
    if (self.windowAlpha < 1.0) {
        self.windowAlpha = self.windowAlpha + 0.05;
        
        for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
            oneWin.alphaValue = self.windowAlpha;
        }
    }
    //NSLog(@"self.windowAlpha: %.02f", self.windowAlpha);
}

- (IBAction)alphaDown:(id)sender {
    if (self.windowAlpha > 0.1) {
        self.windowAlpha = self.windowAlpha - 0.05;
        
        for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
            oneWin.alphaValue = self.windowAlpha;
        }
    }
    //NSLog(@"self.windowAlpha: %.02f", self.windowAlpha);
}

- (IBAction)createNewDock:(id)sender {
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
    
    
    AppInfoEntity * entity = [AppInfoEntity new];
    [entity.appPathArray addObject:@""];
    [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    
    [self showNewDock:entity window:nil];
}

- (void)showNewDock:(AppInfoEntity *)appInfoEntity window:(NSWindow *)window {
    // 设置 wc
    ViewController * vc = [[ViewController alloc] init];
    vc.appInfoEntity = appInfoEntity;
    __weak typeof(self) weakSelf = self;
    vc.addDockBlock = ^{
        [weakSelf createNewDock:nil];
    };
    
    //vc.view.frame = CGRectMake(0, 0, 400, 60);
    if (!window) {
        window = [FloatWindow new];
    }
    [window setContentViewController:vc];
    
    [self setWindowStyle:window];
    
    NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
    
    [wc showWindow:nil];
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
        for (NSRunningApplication * oneApp in appAppArray) {
               if (oneApp.activationPolicy == NSApplicationActivationPolicyRegular) {
                   //NSLog(@"oneApp: %@ _ %@", oneApp.description, oneApp.bundleURL);
                   //NSLog(@"oneApp: %@", oneApp.bundleURL);
                   //[appNormalArray addObject:oneApp];
                   [appSet addObject:oneApp.bundleURL.absoluteString];
               }
        }
        //NSLog(@"appSet: %@", appSet);
        NSArray * windowArray = [NSApplication sharedApplication].windows;
        for (FloatWindow * window in windowArray) {
            ViewController * vc = (ViewController *)window.contentViewController;
            [vc checkActive:appSet];
        }
    }];
}

@end
