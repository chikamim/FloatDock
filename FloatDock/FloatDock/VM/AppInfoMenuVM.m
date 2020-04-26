//
//  AppInfoMenuVM.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoMenuVM.h"

#import "AppDelegate.h"
#import "AppWindowTool.h"

@interface AppInfoMenuVM ()
@property (nonatomic, strong) NSMenu * clickMenu;

@end

@implementation AppInfoMenuVM

- (void)addMenus {
    if (!self.clickMenu) {
        NSMenu * menu = [NSMenu new];
        
        NSMenuItem *item1   = [[NSMenuItem alloc] initWithTitle:@"新增APP" action:@selector(addAppAction) keyEquivalent:@""];
        NSMenuItem *item1_0 = [[NSMenuItem alloc] initWithTitle:@"新增Finder" action:@selector(addFinderAppPath) keyEquivalent:@""];
        NSMenuItem *item2   = [[NSMenuItem alloc] initWithTitle:@"新增Dock" action:@selector(addDockAction) keyEquivalent:@""];
        NSMenuItem *item_0  = [NSMenuItem separatorItem];
        NSMenuItem *item3   = [[NSMenuItem alloc] initWithTitle:@"清空Dock" action:@selector(clearDockAppAction) keyEquivalent:@""];
        NSMenuItem *item4   = [[NSMenuItem alloc] initWithTitle:@"删除Dock" action:@selector(deleteDockAction) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item1_0 setTarget:self];
        [item2 setTarget:self];
        [item3 setTarget:self];
        [item4 setTarget:self];
        
        [menu addItem:item1];
        [menu addItem:item1_0];
        [menu addItem:item2];
        
        [menu addItem:item_0];
        
        [menu addItem:item3];
        [menu addItem:item4];
        
        self.clickMenu = menu;
    }
    self.view.menu = self.clickMenu;
}

// MARK: 右键menu
- (void)addFinderAppPath {
    [self addAppPathArray:@[@"/System/Library/CoreServices/Finder.app/"]];
}

- (void)addDockAction {
    [[AppWindowTool share] createNewDockEvent];
}

- (void)clearDockAppAction { }

- (void)deleteDockAction { }

- (void)addAppUrlArray:(NSArray *)array { }

- (void)addAppPathArray:(NSArray *)array { }

// MARK: 打开系统文件件事件
- (void)addAppAction {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"app"]];
    
    if ([panel runModal] == NSModalResponseOK) {
        [self addAppUrlArray:panel.URLs];
    }
}

@end
