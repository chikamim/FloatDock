//
//  AppWindowTool.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppWindowTool.h"

@implementation AppWindowTool

+ (instancetype)share {
    static dispatch_once_t once;
    static AppWindowTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.appInfoTool = [AppInfoTool share];
        instance.windowAlpha = 0.6;
    });
    return instance;
}

- (void)showBeforeWindows {
    if (self.appInfoTool.appInfoArrayEntity.windowArray.count == 0) {
        AppInfoEntity * entity = [AppInfoEntity new];
        [entity.appPathArray addObject:@""];
        
        [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    }
    
    for (int i = 0; i<self.appInfoTool.appInfoArrayEntity.windowArray.count; i++) {
        [self showNewDock:self.appInfoTool.appInfoArrayEntity.windowArray[i]];
    }
}

- (void)createNewDockEvent:(CGPoint)origin {
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
    if (CGPointEqualToPoint(origin, CGPointZero)) {
        CGSize size = [NSScreen mainScreen].frame.size;
        origin = CGPointMake(size.width/2, size.height/2);
    }
    entity.x = origin.x + 10;
    entity.y = origin.y + 10;
    [entity.appPathArray addObject:@""];
    [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    
    [self showNewDock:entity];
}

- (void)showNewDock:(AppInfoEntity *)appInfoEntity {
    // 设置 wc
    ViewController * vc = [[ViewController alloc] init];
    vc.appInfoEntity = appInfoEntity;
    
    //vc.view.frame = CGRectMake(0, 0, 400, 60);
    NSWindow * window = [FloatWindow new];
    [window setContentViewController:vc];
    
    [self setWindowStyle:window];
    
    NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
    
    [wc showWindow:nil];
}

- (void)setWindowStyle:(NSWindow *)window {
    [window setStyleMask:NSWindowStyleMaskBorderless];
    
    //CGRect rect =CGRectMake(window.frame.origin.x, window.frame.origin.y, 400, 60);
    //[window setFrame:rect display:YES];
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    window.hasShadow = NO; // 关闭阴影
    
    window.contentView.layer.cornerRadius = 12;
    //[window setOpaque:YES];
    //window.contentView.layer.masksToBounds = YES;
    [window setBackgroundColor:[NSColor clearColor]];// 防止 设置了圆角之后, 显示为黑角.
    
    // 假如没有背景色, 就无法点击了...
    CGColorRef color;
    //color = [[NSColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:208.0/255.0 alpha:0.55] CGColor];
    color = [[NSColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.5] CGColor];
    [window.contentView.layer setBackgroundColor:color];
    
    [window setLevel:NSFloatingWindowLevel];
    window.alphaValue = self.windowAlpha;
}


- (void)alphaUpEvent {
    if (self.windowAlpha < 1.0) {
        self.windowAlpha = self.windowAlpha + 0.05;
        
        for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
            oneWin.alphaValue = self.windowAlpha;
        }
    }
    //NSLog(@"self.windowAlpha: %.02f", self.windowAlpha);
}

- (void)alphaDownEvent {
    if (self.windowAlpha > 0.05) {
        self.windowAlpha = self.windowAlpha - 0.05;
        
        for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
            NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
            oneWin.alphaValue = self.windowAlpha;
        }
    }
    //NSLog(@"self.windowAlpha: %.02f", self.windowAlpha);
}

@end
