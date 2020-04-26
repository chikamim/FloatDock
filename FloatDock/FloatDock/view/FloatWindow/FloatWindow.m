//
//  FloatWindow.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FloatWindow.h"
#import "ViewController.h"

@interface FloatWindow ()

@property (nonatomic        ) BOOL moved;

@end

@implementation FloatWindow

//- (void)mouseDown:(NSEvent *)event {
//    //NSLog(@"3");
//}

- (void)mouseDragged:(NSEvent *)event {
    //NSLog(@"1");
    self.moved = YES;
}

//- (void)mouseExited:(NSEvent *)event {
//    
//}

- (void)mouseUp:(NSEvent *)event {
    //NSLog(@"mouseUp");
    if (self.moved) {
        self.moved = NO;
        
        //NSLog(@"更新 frame");
        ViewController * vc = (ViewController *)self.contentViewController;
        
        vc.appInfoEntity.x = self.frame.origin.x;
        vc.appInfoEntity.y = self.frame.origin.y;
        
        [AppInfoTool updateEntity];
    }
}

@end
