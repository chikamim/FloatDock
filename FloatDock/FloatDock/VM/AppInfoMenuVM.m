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
#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "AppWindowTool.h"

@interface AppInfoMenuVM ()
@property (nonatomic, strong) NSMenu * clickMenu;
@property (nonatomic, strong) NSMenu * favoriteMenu;
@property (nonatomic, weak  ) HotKeyTool * hotKeyTool;
@property (nonatomic, weak  ) AppWindowTool * appWindowTool;

@end

@implementation AppInfoMenuVM

- (instancetype)init {
    if (self = [super init]) {
        _hotKeyTool = [HotKeyTool share];
        _appWindowTool = [AppWindowTool share];
    }
    return self;
}

- (void)addMenus {
    if (!self.favoriteMenu) {
        NSMenu * menu = [NSMenu new];
        self.favoriteMenu = menu;
    }
    if (!self.clickMenu) {
        NSMenu * menu = [NSMenu new];
        
        NSMenuItem *item1   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddApp") action:@selector(addAppAction) keyEquivalent:@""];
        NSMenuItem *item1_0 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddFinder") action:@selector(addFinderAppPath) keyEquivalent:@""];
        NSMenuItem *item1_1 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddAppFromFavorite") action:nil keyEquivalent:@""];
        item1_1.submenu = self.favoriteMenu;
        
        NSMenuItem *item2   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddDock") action:@selector(addDockAction) keyEquivalent:@""];
        NSMenuItem *item_0  = [NSMenuItem separatorItem];
        NSMenuItem *item30  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_FavoriteWindow") action:@selector(openFavoriteWindow) keyEquivalent:@""];
        NSMenuItem *item31  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_ClearDock") action:@selector(clearDockAppAction) keyEquivalent:@""];
        NSMenuItem *item32  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DeleteDock") action:@selector(deleteDockAction) keyEquivalent:@""];
        
        NSMenuItem *item41  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_UpAlpha") action:@selector(alphaUpEvent) keyEquivalent:@""];
        NSMenuItem *item42  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DownAlpha") action:@selector(alphaDownEvent) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item1_0 setTarget:self];
        [item1_1 setTarget:self];
        [item2 setTarget:self];
        [item30 setTarget:self];
        [item31 setTarget:self];
        [item32 setTarget:self];
        
        [item41 setTarget:self.appWindowTool];
        [item42 setTarget:self.appWindowTool];
        
        [menu addItem:item1];
        [menu addItem:item1_0];
        [menu addItem:item1_1];
        [menu addItem:item2];
        
        [menu addItem:item_0];
        
        [menu addItem:item30];
        [menu addItem:item31];
        [menu addItem:item32];
        
        [menu addItem:item41];
        [menu addItem:item42];
        
        self.clickMenu = menu;
    }
    self.view.menu = self.clickMenu;
    [self racObserveEvent];
}

- (void)racObserveEvent {
    @weakify(self);
    [[RACObserve(self.hotKeyTool, favoriteAppsSigleArray) throttle:0.5] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self updateFavoriteMenuEvent];
    }];
}

- (void)updateFavoriteMenuEvent {
    [self.favoriteMenu removeAllItems];
    for (NSInteger i = 0; i < self.hotKeyTool.favoriteAppsSigleArray.count; i++) {
        FavoriteAppEntity * app = self.hotKeyTool.favoriteAppsSigleArray[i];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:app.name action:@selector(addAppFromFavority:) keyEquivalent:@""];
        item.tag = i;
        item.target = self;
        if (!app.imageMenu) {
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            NSImage *finderIcon;
            //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
            finderIcon = [workspace iconForFile:[app.path substringFromIndex:7]];
            [finderIcon setSize:NSMakeSize(18, 18)];
            
            app.imageMenu = finderIcon;
        }
        item.image = app.imageMenu;
        //NSData *imageData = [app.smallImage TIFFRepresentation];
        [self.favoriteMenu addItem:item];
    }
}

// MARK: 右键menu
- (void)addFinderAppPath {
    [self addAppUrlArray:@[[NSURL URLWithString:AppInfoUrl_Finder]]];
}

- (void)addDockAction {
    [[AppWindowTool share] createNewDockEvent:self.view.window.frame.origin];
}

- (void)clearDockAppAction { }

- (void)deleteDockAction { }

- (void)addAppUrlArray:(NSArray *)array { }

- (void)addAppPathArray:(NSArray *)array { }

- (void)openFavoriteWindow {
    AppWindowTool * tool = [AppWindowTool share];
    [tool openFavoriteWindows];
}

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

- (void)addAppFromFavority:(NSMenuItem *)item {
    FavoriteAppEntity * app = self.hotKeyTool.favoriteAppsSigleArray[item.tag];
    NSString * url = [app.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self addAppUrlArray:@[[NSURL URLWithString:url]]];
}

@end
