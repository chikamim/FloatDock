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
    
    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    window.title = @"Float Dock";
    self.window = window;
    
    [self setWindowStyle:window];
    
    self.window.alphaValue = 0.4;
    
    [self.window.contentView.layer setBackgroundColor:[[NSColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:208.0/255.0 alpha:1]CGColor]];
    //self.window.contentView.layer.cornerRadius = 12;
    //self.window.contentView.layer.masksToBounds = YES;
    
    [NSApp.windows[0] setLevel:NSFloatingWindowLevel];
}

- (void)setWindowStyle:(NSWindow *)window {
    
    [window setStyleMask:NSWindowStyleMaskBorderless];

    CGRect rect =CGRectMake(window.frame.origin.x, window.frame.origin.y, 400, 60);
    [window setFrame:rect display:YES];
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    
    window.hasShadow = NO; // 关闭阴影
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)alphaUp:(id)sender {
    if (self.window.alphaValue < 1.0) {
        self.window.alphaValue = self.window.alphaValue + 0.05;
    }
}

- (IBAction)alphaDown:(id)sender {
    if (self.window.alphaValue > 0.1) {
        self.window.alphaValue = self.window.alphaValue - 0.05;
    }
}

@end
