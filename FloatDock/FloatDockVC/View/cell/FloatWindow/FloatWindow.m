//
//  FloatWindow.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FloatWindow.h"
#import "FloatDockVC.h"

@interface FloatWindow ()

@property (nonatomic        ) BOOL moved;

@end

@implementation FloatWindow

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
        FloatDockVC * vc = (FloatDockVC *)self.contentViewController;
        
        vc.appInfoEntity.x = self.frame.origin.x;
        vc.appInfoEntity.y = self.frame.origin.y;
        
        [AppInfoTool updateEntity];
    }
}

/*
 下面2个是为了配合 FavoriteWindow.
 == 如何 判断是否失去焦点
 == https://mlog.club/article/1508723
*/

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}


@end
