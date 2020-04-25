//
//  AppDelegate.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, weak  ) AppInfoTool * appInfoTool;
//AppInfoArrayEntity * appInfoArrayEntity;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
#if TARGET_OS_MAC//模拟器
    NSString * macOSInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    if ([[NSFileManager defaultManager] fileExistsAtPath:macOSInjectionPath]) {
        [[NSBundle bundleWithPath:macOSInjectionPath] load];
    }
#endif
    self.appInfoTool = [AppInfoTool share];
    if (self.appInfoTool.appInfoArrayEntity.windowArray.count == 0) {
        AppInfoEntity * entity = [AppInfoEntity new];
        [entity.appPathArray addObject:@""];
        
        [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    }

    for (int i = 0; i<self.appInfoTool.appInfoArrayEntity.windowArray.count; i++) {
        AppInfoEntity * aie = self.appInfoTool.appInfoArrayEntity.windowArray[i];
        if (i == 0) {
            NSWindow * window = [NSApplication sharedApplication].keyWindow;
            self.window = window;
            [self showNewDock:aie window:window];
        } else {
            [self showNewDock:aie window:nil];
        }
    }
    
    //self.window.contentView.layer.cornerRadius = 12;
    //self.window.contentView.layer.masksToBounds = YES;
}

- (void)setWindowStyle:(NSWindow *)window {
    
    [window setStyleMask:NSWindowStyleMaskBorderless];
    
    //CGRect rect =CGRectMake(window.frame.origin.x, window.frame.origin.y, 400, 60);
    //[window setFrame:rect display:YES];
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    window.hasShadow = NO; // 关闭阴影
    
    [window.contentView.layer setBackgroundColor:[[NSColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:208.0/255.0 alpha:1]CGColor]];
    
    [window setLevel:NSFloatingWindowLevel];
    window.alphaValue = 0.4;
}

- (IBAction)alphaUp:(id)sender {
    if (self.window.alphaValue < 1.0) {
        self.window.alphaValue = self.window.alphaValue + 0.05;
        
        for (int i = 1; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * win = [NSApplication sharedApplication].windows[i];
            win.alphaValue = self.window.alphaValue;
        }
    }
    //    NSWindow * win0 = [NSApplication sharedApplication].windows[0];
    //    NSWindow * win1 = [NSApplication sharedApplication].windows[1];
    //
    //    [NSApplication sharedApplication].mainWindow;
    
    //win0.visible;
    
    //[win0 ]
    //NSLog(@"23");
}

- (IBAction)alphaDown:(id)sender {
    if (self.window.alphaValue > 0.1) {
        self.window.alphaValue = self.window.alphaValue - 0.05;
        
        for (int i = 1; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * win = [NSApplication sharedApplication].windows[i];
            win.alphaValue = self.window.alphaValue;
        }
    }
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
    if (window) {
        
    } else {
        window = [NSWindow new];
    }
    
    [window setLevel:NSFloatingWindowLevel];
    [window setContentViewController:vc];
    
    [self setWindowStyle:window];
    
    NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
    
    [wc showWindow:nil];
}

// MARK: app 关闭
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    //[AppInfoTool saveAppInfoArrayEntity:self.appInfoTool.appInfoArrayEntity];
    //[SqliteCofing updateWindowFrame:self.window.frame];
}

@end
