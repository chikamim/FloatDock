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
@property (nonatomic, strong) NSMenu * addFavoriteMenu;
@property (nonatomic, strong) NSMenu * openFavoriteMenu;
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
    if (!self.addFavoriteMenu) {
        NSMenu * menu = [NSMenu new];
        self.addFavoriteMenu = menu;
    }
    if (!self.openFavoriteMenu) {
        NSMenu * menu = [NSMenu new];
        self.openFavoriteMenu = menu;
    }
    if (!self.clickMenu) {
        NSMenu * menu = [NSMenu new];
        NSMenuItem *line_0  = [NSMenuItem separatorItem];
        NSMenuItem *line_1  = [NSMenuItem separatorItem];
        NSMenuItem *line_2  = [NSMenuItem separatorItem];
        
        NSMenuItem *itemAddApp   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddApp") action:@selector(addAppAction) keyEquivalent:@""];
        NSMenuItem *itemAddFinder = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddFinder") action:@selector(addFinderAppPath) keyEquivalent:@""];
        NSMenuItem *itemAddFromFav = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddAppFromFavorite") action:nil keyEquivalent:@""];
        itemAddFromFav.submenu = self.addFavoriteMenu;
        NSMenuItem *itemOpenFromFav = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_OpenAppFromFavorite") action:nil keyEquivalent:@""];
        itemOpenFromFav.submenu = self.openFavoriteMenu;
        
        NSMenuItem *itemAddDock   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddDock") action:@selector(addDockAction) keyEquivalent:@""];
        
        NSMenuItem *itemOpenFav  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_FavoriteWindow") action:@selector(openFavoriteWindow) keyEquivalent:@""];
        NSMenuItem *itemClearDock  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_ClearDock") action:@selector(clearDockAppAction) keyEquivalent:@""];
        NSMenuItem *itemDeleteDock  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DeleteDock") action:@selector(deleteDockAction) keyEquivalent:@""];
        
        NSMenuItem *itemUpAlpha  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_UpAlpha") action:@selector(alphaUpEvent) keyEquivalent:@""];
        NSMenuItem *itemDownAlpha  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DownAlpha") action:@selector(alphaDownEvent) keyEquivalent:@""];
        
        [itemAddApp setTarget:self];
        [itemAddFinder setTarget:self];
        //[item1_1 setTarget:self];
        [itemAddDock setTarget:self];
        [itemOpenFav setTarget:self];
        [itemClearDock setTarget:self];
        [itemDeleteDock setTarget:self];
        
        [itemUpAlpha setTarget:self.appWindowTool];
        [itemDownAlpha setTarget:self.appWindowTool];
        
        // ------- menu排序
        [menu addItem:itemOpenFromFav];
        [menu addItem:line_0];
        
        [menu addItem:itemAddFromFav];
        
        [menu addItem:itemAddApp];
        [menu addItem:itemAddFinder];
        [menu addItem:itemAddDock];
        
        [menu addItem:line_1];
        
        [menu addItem:itemOpenFav];
        [menu addItem:itemClearDock];
        [menu addItem:itemDeleteDock];
        
        [menu addItem:line_2];
        [menu addItem:itemUpAlpha];
        [menu addItem:itemDownAlpha];
        
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
    [self.addFavoriteMenu removeAllItems];
    [self.openFavoriteMenu removeAllItems];
    for (NSInteger i = 0; i < self.hotKeyTool.favoriteAppsSigleArray.count; i++) {
        FavoriteAppEntity * app = self.hotKeyTool.favoriteAppsSigleArray[i];
        {
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
            [self.addFavoriteMenu addItem:item];
        }
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:app.name action:@selector(openAppFromFavority:) keyEquivalent:@""];
            item.tag = i;
            item.target = self;
            item.image = app.imageMenu;
            [self.openFavoriteMenu addItem:item];
        }
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

- (void)openAppFromFavority:(NSMenuItem *)item {
    FavoriteAppEntity * app = self.hotKeyTool.favoriteAppsSigleArray[item.tag];
    [self.hotKeyTool openAppWindows:app.path];
}

@end
