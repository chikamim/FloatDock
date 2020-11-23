//
//  AppIconItem.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppIconItem.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AppWindowTool.h"

@interface AppIconItem ()

@end

@implementation AppIconItem

- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBT];
    [self addIV];
    
    {   // 此为保证小白点显示出来第一步
        [self.view setWantsLayer:YES];
        [self.view.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        
        self.view.layer.masksToBounds = NO;
    }
}

- (void)addBT {
    self.appBT = ({
        NSButton * button = [NSButton new];
        
        // 设置 button 背景色 边界.
        [[button cell] setBackgroundColor:[NSColor clearColor]];
        button.title = @"";
        button.bordered = NO;
        
        button.target = self;
        button.action = @selector(open);
        
        [self.view addSubview:button];
        button;
    });
    
    [self.appBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(NSEdgeInsetsZero);
    }];
    
    {
        self.clickMenu  = [NSMenu new];
        self.appBT.menu = self.clickMenu;
        
        @weakify(self);
        [[RACObserve(self.activeIV, hidden) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateBtMenu];
            //NSLog(@"更新 menu");
        }];
        [self updateBtMenu];
    }
    //self.appBT.hidden = YES;
}

- (void)addIV {
    self.activeIV = ({
        NSImageView * iv = [NSImageView new];
        iv.image = [NSImage imageNamed:@"whitePoint"];
        // TODO: wkq, 如何 使得 NSImageVIew 点击穿透?
        
        [self.view addSubview:iv];
        iv;
    });
    [self.activeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    self.activeIV.hidden = NO;
}

- (void)updateBtMenu {
    
    [self.clickMenu removeAllItems];
    
    if (self.appPath.length == 0) {
        return;
    }
    
    NSMenuItem *item01 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_Open") action:@selector(open) keyEquivalent:@""];
    //NSMenuItem *item_1 = [NSMenuItem separatorItem];
    
    NSMenuItem *item11 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_Delete") action:@selector(delete) keyEquivalent:@""];
    NSMenuItem *item12 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_MoveLeft") action:@selector(moveLeft) keyEquivalent:@""];
    NSMenuItem *item13 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_MoveRight") action:@selector(moveRight) keyEquivalent:@""];
    
    NSMenuItem *item_2 = [NSMenuItem separatorItem];
    NSMenuItem *item21 = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"获取 PID: %i", self.runningApp.processIdentifier] action:@selector(getPid) keyEquivalent:@""];
    //NSMenuItem *item22 = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(exit) keyEquivalent:@""];
    NSMenuItem *item22 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_Favorite") action:@selector(favorite) keyEquivalent:@""];
    NSMenuItem *item22_0 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_StatusBarIconSwitch") action:@selector(showStatusBar) keyEquivalent:@""];
    NSMenuItem *item23 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_FavoriteWindow") action:@selector(openFavoriteWindow) keyEquivalent:@""];
    NSMenuItem *item24 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_FrontLLDB") action:@selector(lldbFront) keyEquivalent:@""];
    NSMenuItem *item25 = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_NormalLLDB") action:@selector(lldbNormal) keyEquivalent:@""];
    
    [item01 setTarget:self];
    [item11 setTarget:self];
    [item12 setTarget:self];
    [item13 setTarget:self];
    
    [item21 setTarget:self];
    [item22 setTarget:self];
    [item23 setTarget:self];
    [item24 setTarget:self];
    [item25 setTarget:self];
    
    [self.clickMenu addItem:item01];
    
    [self.clickMenu addItem:item11];
    [self.clickMenu addItem:item12];
    [self.clickMenu addItem:item13];
    
    [self.clickMenu addItem:item_2];
    [self.clickMenu addItem:item22]; // 收藏
    [self.clickMenu addItem:item22_0]; // 状态栏图标
    [self.clickMenu addItem:item23];
    if (!self.activeIV.hidden) {
        //[self.clickMenu addItem:item21];
        [self.clickMenu addItem:item24];
        [self.clickMenu addItem:item25];
    }
    
}

- (void)open {
    if (self.delegate && [self.delegate respondsToSelector:@selector(open:)]) {
        [self.delegate open:self];
    }
}

- (void)delete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delete:)]) {
        [self.delegate delete:self];
    }
}

- (void)moveLeft {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveLeft:)]) {
        [self.delegate moveLeft:self];
    }
}

- (void)moveRight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveRight:)]) {
        [self.delegate moveRight:self];
    }
}

- (void)getPid {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getPid:)]) {
        [self.delegate getPid:self];
    }
}

- (void)favorite {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favorite:)]) {
        [self.delegate favorite:self];
    }
}

- (void)openFavoriteWindow {
    AppWindowTool * tool = [AppWindowTool share];
    [tool openFavoriteWindows];
}


- (void)lldbFront {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lldbFront:)]) {
        [self.delegate lldbFront:self];
    }
}

- (void)lldbNormal {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lldbNormal:)]) {
        [self.delegate lldbNormal:self];
    }
}

- (void)showStatusBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showStatusBarAction:)]) {
        [self.delegate showStatusBarAction:self];
    }
}

@end
