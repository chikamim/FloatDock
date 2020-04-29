//
//  AppInfoView.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface AppInfoView ()

@property (nonatomic, strong) NSMenu * clickMenu;

@end

@implementation AppInfoView

- (id)init {
    if (self = [super init]) {
        [self addBT];
        [self addIV];
        //[self addMenu];
        [self bindEvent];
    }
    return self;
}

- (void)addBT {
    NSButton * button = [NSButton new];
    
    // 设置 button 背景色 边界.
    [[button cell] setBackgroundColor:[NSColor clearColor]];
    button.title = @"";
    button.bordered = NO;
    
    [self addSubview:button];
    
    self.appBT = button;
}

- (void)addIV {
    self.activeIV = ({
        NSImageView * iv = [NSImageView new];
        iv.image = [NSImage imageNamed:@"whitePoint"];
        // TODO: wkq, 如何 使得 NSImageVIew 点击穿透?
        
        [self addSubview:iv];
        iv;
    });
    [self.activeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    self.activeIV.hidden = YES;
}

- (void)addMenu {
    if (!self.clickMenu) {
        self.clickMenu = [NSMenu new];
    }
    {
        [self.clickMenu removeAllItems];
        
        //NSMenuItem *item01 = [[NSMenuItem alloc] initWithTitle:@"extra" action:@selector(exit) keyEquivalent:@""];
        //NSMenuItem *item_1 = [NSMenuItem separatorItem];
        
        NSMenuItem *item11 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(delete) keyEquivalent:@""];
        NSMenuItem *item12 = [[NSMenuItem alloc] initWithTitle:@"前移" action:@selector(moveLeft) keyEquivalent:@""];
        NSMenuItem *item13 = [[NSMenuItem alloc] initWithTitle:@"后移" action:@selector(moveRight) keyEquivalent:@""];
        
        NSMenuItem *item_2 = [NSMenuItem separatorItem];
        NSMenuItem *item21 = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"获取 PID: %i", self.runningApp.processIdentifier] action:@selector(getPid) keyEquivalent:@""];
        //NSMenuItem *item22 = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(exit) keyEquivalent:@""];
        NSMenuItem *item22 = [[NSMenuItem alloc] initWithTitle:@"收藏" action:@selector(favorite) keyEquivalent:@""];
        NSMenuItem *item23 = [[NSMenuItem alloc] initWithTitle:@"置顶LLDB" action:@selector(lldbFront) keyEquivalent:@""];
        NSMenuItem *item24 = [[NSMenuItem alloc] initWithTitle:@"普通LLDB" action:@selector(lldbNormal) keyEquivalent:@""];
        
        //[item01 setTarget:self];
        [item11 setTarget:self];
        [item12 setTarget:self];
        [item13 setTarget:self];
        
        [item21 setTarget:self];
        [item22 setTarget:self];
        [item23 setTarget:self];
        [item24 setTarget:self];
        
        // if (!self.activeIV.hidden) {
        //     [self.clickMenu addItem:item01];
        //     [self.clickMenu addItem:item_1];
        // }
        
        [self.clickMenu addItem:item11];
        [self.clickMenu addItem:item12];
        [self.clickMenu addItem:item13];
        
        if (!self.activeIV.hidden) {
            [self.clickMenu addItem:item_2];
            //[self.clickMenu addItem:item21];
            [self.clickMenu addItem:item22];
            [self.clickMenu addItem:item23];
            [self.clickMenu addItem:item24];
        }
    }
    self.appBT.menu = self.clickMenu;
}

- (void)bindEvent {
    @weakify(self);
    [[RACObserve(self.activeIV, hidden) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self addMenu];
        //NSLog(@"更新 menu");
    }];
}

- (void)exit {
    if (self.delegate && [self.delegate respondsToSelector:@selector(exit:)]) {
        [self.delegate exit:self];
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

@end
