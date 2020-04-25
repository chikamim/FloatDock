//
//  AppInfoView.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoView.h"
#import <Masonry/Masonry.h>

@interface AppInfoView ()

@property (nonatomic, strong) NSMenu * clickMenu;

@end

@implementation AppInfoView

- (id)init {
    if (self = [super init]) {
        [self addBT];
        [self addIV];
        [self addMenu];
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
        //[self addSubview:iv];
        [self addSubview:iv];
        iv;
    });
    [self.activeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
}

- (void)addMenu {
    if (!self.clickMenu) {
        self.clickMenu = [NSMenu new];
        
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(delete) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"前移" action:@selector(moveLeft) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"后移" action:@selector(moveRight) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item2 setTarget:self];
        [item3 setTarget:self];
        
        [self.clickMenu addItem:item1];
        [self.clickMenu addItem:item2];
        [self.clickMenu addItem:item3];
    }
    self.appBT.menu = self.clickMenu;
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

@end
