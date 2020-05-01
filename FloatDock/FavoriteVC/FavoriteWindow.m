//
//  FavoriteWindow.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/30.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteWindow.h"

#import "FavoriteVC.h"

@implementation FavoriteWindow
/*
 如何 判断是否失去焦点
 https://mlog.club/article/1508723
 */

- (void)setupWindowForEvents {
    // 尚不知2者区别
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignMain:) name:NSWindowDidResignMainNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:self];
}

-(void)windowDidResignMain:(NSNotification *)note {
    //NSLog(@"notification Main");
    [self resignEvent];
}

-(void)windowDidResignKey:(NSNotification *)note {
    //NSLog(@"notification Key");
    [self resignEvent];
}

- (void)resignEvent {
    [self.favoriteVC closeEditHotkeyOuter];
    //[self close];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

@end
