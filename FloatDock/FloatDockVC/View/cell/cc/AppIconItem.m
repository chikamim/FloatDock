//
//  AppIconItem.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppIconItem.h"
#import <Masonry/Masonry.h>

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
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor redColor] CGColor]];
    
    self.view.layer.masksToBounds = NO;
}

- (void)addBT {
    self.appBT = ({
        NSButton * button = [NSButton new];
        
        // 设置 button 背景色 边界.
        [[button cell] setBackgroundColor:[NSColor clearColor]];
        button.title = @"";
        button.bordered = NO;
        
        [self.view addSubview:button];
        button;
    });
    
    [self.appBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(NSEdgeInsetsZero);
    }];
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
        make.bottom.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    self.activeIV.hidden = NO;
}


@end
