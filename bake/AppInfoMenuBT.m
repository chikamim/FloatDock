//
//  AppInfoMenuBT.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoMenuBT.h"
#import <Masonry/Masonry.h>

@interface AppInfoMenuBT ()

@property (nonatomic, strong) NSMenu * clickMenu;

@property (nonatomic, strong) NSImageView * activeIV;

@end

@implementation AppInfoMenuBT

- (id)init {
    if (self = [super init]) {
        [self addIV];
        [self addMenu];
        
    }
    return self;
}

- (void)addMenu {
    if (!self.clickMenu) {
        self.clickMenu = [NSMenu new];
        
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(delete:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"前移" action:@selector(moveLeft:) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"后移" action:@selector(moveRight:) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item2 setTarget:self];
        [item3 setTarget:self];
        
        [self.clickMenu addItem:item1];
        [self.clickMenu addItem:item2];
        [self.clickMenu addItem:item3];
    }
    self.menu = self.clickMenu;
}

- (void)addIV {
    self.activeIV = ({
        NSImageView * iv = [NSImageView new];
        iv.image = [NSImage imageNamed:@"whitePoint"];
        //[self addSubview:iv];
        [self.cell.controlView addSubview:iv];
        iv;
    });
    [self.activeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(6);
    }];
}

- (void)delete:(NSButton *)appInfoMenuBT {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delete:)]) {
        [self.delegate delete:self];
    }
}

- (void)moveLeft:(NSButton *)appInfoMenuBT {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveLeft:)]) {
        [self.delegate moveLeft:self];
    }
}

- (void)moveRight:(NSButton *)appInfoMenuBT {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveRight:)]) {
        [self.delegate moveRight:self];
   }
}

@end
