//
//  StatusBarTool.m
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "StatusBarTool.h"
#import "ZLImage.h"
#import "HotKeyTool.h"
#import "AppWindowTool.h"
#import "AppInfoEntity.h"

#import <MASShortcut/MASShortcut.h>
#import <MASShortcut/MASShortcutBinder.h>
#import <MASShortcut/MASDictionaryTransformer.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "StatusBarView.h"
#import <Masonry/Masonry.h>

@implementation StatusBarTool

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

//MARK: 设置状态功能函数
- (void)updateStatusBarUI {
    AppInfoTool * tool = [AppInfoTool share];
    BOOL show = tool.appInfoArrayEntity.showStatusBar;
    
    if (show) {
        if (self.statusItem) {
            [self setStatusImage_delay];
        } else {
            HotKeyTool * hkt = [HotKeyTool share];
            
            if (hkt.favoriteAppArrayEntity) {
                [self setStatusImage_delay];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self setStatusImage_delay];
                });
            }
        }
    } else {
        self.statusItem = nil;
    }
}

- (void)setStatusImage_delay {
    HotKeyTool * tool = [HotKeyTool share];
    
    self.statusItem = ({
        NSStatusBar * statusBar = [NSStatusBar systemStatusBar];
        NSStatusItem * item = [statusBar statusItemWithLength:NSVariableStatusItemLength];
        NSLog(@"生成 status item.");
        {   // 基础属性
            static NSImage * image;
            if (!image) {
                image = [NSImage imageNamed:@"AppIcon"];
                image = [ZLImage resizeImage:image forSize:NSMakeSize(20, 20)];
            }
            item.button.image = image;
            
            //[item.button setTarget:self];
            //[item.button setAction:@selector(statusItemAction:)];
        }
        
        // 点击事件
        item.menu = [NSMenu new];
        {   // 加基础控制UI
            {   // @"显示收藏页"
                NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_OpenAppFromFavorite") action:@selector(showFavVC:) keyEquivalent:@""];
                mi.target = self;
            
                [item.menu addItem:mi];
            }
            {   // "显示/关闭状态栏图标";
                NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_StatusBarIconClose") action:@selector(switchShowStatusBarAction) keyEquivalent:@""];
                mi.target = self;
                
                [item.menu addItem:mi];
            }
        }
        {   // 横线
            NSMenuItem * mi = [NSMenuItem separatorItem];
            [item.menu addItem:mi];
        }
        
        @weakify(self);
        // 加载APP
        for (NSInteger i = 0; i<tool.favoriteAppArrayEntity.array.count; i++) {
            FavoriteAppEntity * entity = tool.favoriteAppArrayEntity.array[i];
            
            NSMenuItem * mi = [NSMenuItem new];
            
            mi.target  = self;
            mi.action  = @selector(appAction:);// 暂且无用, 但是注释的话无法触发点击效果.
            mi.enabled = YES;
            
            // 这里不能设置, 否则会和真正的快捷键相冲突
            // if (entity.hotKey.length > 0) {
            //     MASShortcut * shortCut = [MASShortcut shortcutWithKeyCode:entity.codeNum modifierFlags:entity.flagNum];
            //
            //     mi.keyEquivalentModifierMask = shortCut.modifierFlags;
            //     mi.keyEquivalent = shortCut.keyCodeString;
            //
            //     //NSLog(@"App Name: %@, \t\tflag: %li, \t\tcode:%@", entity.name, shortCut.modifierFlags, shortCut.keyCodeString);
            // }
            
            // if (entity.hotKey.length> 0) {
            //     //mi.title = [NSString stringWithFormat:@"%@ (%@)", mi.title, entity.hotKey];
            //
            //     //mi.keyEquivalent = entity.hotKey;
            //     mi.toolTip = entity.hotKey;
            // }
            
            // 设置自定义view
            StatusBarView * view = [[StatusBarView alloc] initWithFrame:CGRectZero];
            [view.iconBT setImage:entity.imageMenu];
            view.nameTF.stringValue   = entity.name;
            //view.nameTF.stringValue = @"123456789 123456789 123456789 ";
            view.hotkeyTF.stringValue = entity.hotKey.length>0 ? entity.hotKey : @"";
            view.statusTF.hidden      = !entity.enable || entity.hotKey.length==0;
            
            view.number = i;
            
            view.selectBlock = ^(StatusBarView * _Nonnull statusBarView) {
                @strongify(self);
                
                [self appAction:statusBarView.number];
            };
            [mi setView:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(NSEdgeInsetsZero);
                make.height.mas_equalTo(24);
            }];
            
            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //    [mi setView:view];
            //});
            
            //[view needsLayout];
            //[view needsDisplay];
            //[view setNeedsUpdateConstraints:YES];
            [view updateConstraintsForSubtreeIfNeeded];
            
            [item.menu addItem:mi];
            
            //NSLog(@"name: %@", entity.name);
        }
        
        item;
    });
    
    //[self.statusItem ]
}

//- (void)statusItemAction:(NSStatusItem *)item {NSLog(@"%s", __func__); }

- (void)menuExit {
    NSLog(@"exit");
}

- (void)switchShowStatusBarAction {
    AppInfoTool * tool = [AppInfoTool share];
    tool.appInfoArrayEntity.showStatusBar = !tool.appInfoArrayEntity.showStatusBar;
    [AppInfoTool updateEntity];
    
    [self updateStatusBarUI];
}

- (void)showFavVC:(NSMenuItem *)mi {
    AppWindowTool * tool = [AppWindowTool share];
    [tool openFavoriteWindows];
}

- (void)appAction:(NSInteger)tag {
    HotKeyTool * tool = [HotKeyTool share];
    FavoriteAppEntity * entity = tool.favoriteAppArrayEntity.array[tag];
    [tool openAppWindows:entity.path];
}

@end
