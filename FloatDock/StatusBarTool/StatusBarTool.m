//
//  StatusBarTool.m
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "StatusBarTool.h"
#import "ZLImage.h"

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
- (void)setStatusImage {
    //获取系统单例NSStatusBar对象
    self.statusItem = ({
        NSStatusBar * statusBar = [NSStatusBar systemStatusBar];
        NSStatusItem * item = [statusBar statusItemWithLength:NSVariableStatusItemLength];
        //        //NSStatusItem *statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
        //        item.button.image = [NSImage imageNamed:@"AppIcon32x32@2x"];
        //        item.button.image = [NSImage imageNamed:@"AppIcon64x64@2x"];
        //        //item.button.image = [NSImage imageNamed:@"AppIcon"];
        //        item.button.image = [NSImage imageNamed:@"AppIcon128x128"];
        //
        //        //item.button.image = [NSImage imageNamed:@"AppIcon_32x32@2x"];
        //        //item.button.image = [NSImage imageNamed:@"AppIcon_64x64@2x"];
        //        //item.button.image = [NSImage imageNamed:@"AppIcon"];
        //        //item.button.image = [NSImage imageNamed:@"AppIcon_128x128"];
        
        static NSImage * image;
        if (!image) {
            image = [NSImage imageNamed:@"AppIcon"];
            image = [ZLImage resizeImage:image forSize:NSMakeSize(20, 20)];
        }
        item.button.image = image;
        
        [item.button setTarget:self];
        [item.button setAction:@selector(statusItemAction:)];
        
        item.menu = [NSMenu new];
        {
            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"显示" action:@selector(menuShow) keyEquivalent:@""];
            
            [item.menu addItem:mi];
        }
        {
            NSMenuItem * mi = [NSMenuItem separatorItem];
            [item.menu addItem:mi];
        }
        {
            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(menuExit) keyEquivalent:@""];
            mi.enabled = YES;
            
            [item.menu addItem:mi];
        }
        
        item;
    });
    
}

- (void)statusItemAction:(NSStatusItem *)item {NSLog(@"%s", __func__); }
- (void)menuExit { }
- (void)menuShow { }

@end
