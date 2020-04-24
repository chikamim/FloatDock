//
//  AppDelegate.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    window.title = @"Float Dock";
    //window.hasCloseBox = NO;
    //[window setStyleMask:NSWindowStyleMaskBorderless];
    //[window setStyleMask:NSWindowStyleMaskBorderless];
    
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    
    self.window = window;
    
    self.window.minSize = CGSizeMake(400, 80);
    self.window.maxSize = CGSizeMake(400, 80);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //self.window.minSize = CGSizeMake(400, 80);
        //self.window.maxSize = CGSizeMake(400, 80);
    });
    
    

    self.window.alphaValue = 0.3;
    
    [NSApp.windows[0] setLevel:NSFloatingWindowLevel];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
