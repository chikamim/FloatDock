//
//  NSWindow+beep.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "NSWindow+beep.h"

@implementation NSWindow (beep)

/**
 
 https://stackoverflow.com/questions/7992742/how-to-turn-off-keyboard-sounds-in-cocoa-application?answertab=active#tab-top
 当添加下面的代码,  windows.style包含标题栏的话,  按钮就不会出声了.
 
 但是不包含就会发出声音, 比如本 APP 的 dock 窗口.
 */
- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    //[super keyDown:theEvent];
    //NSLog(@"NSWindow keyDown : %@", theEvent.characters);
}

@end
