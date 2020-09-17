//
//  FloatWindow.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FloatWindow.h"
#import "FloatDockVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface FloatWindow ()

@end

@implementation FloatWindow

- (instancetype)init {
    if (self = [super init]) {
        [self racBindEvent];
    }
    return self;
}

- (void)racBindEvent {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @weakify(self);
        [[[RACObserve(self, frame) skip:1] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            FloatDockVC * vc = (FloatDockVC *)self.contentViewController;
            
            vc.appInfoEntity.windowX = self.frame.origin.x;
            vc.appInfoEntity.windowY = self.frame.origin.y;
            
            [AppInfoTool updateEntity];
        }];
    });
}

// 不再使用系统方法, 因为拖拽vc中间导致的修改frame, 不会触发下面方法.
//@property (nonatomic        ) BOOL moved;
//- (void)mouseDragged:(NSEvent *)event {
//    self.moved = YES;
//}
//
//- (void)mouseUp:(NSEvent *)event {
//    if (self.moved) {
//        self.moved = NO;
//
//        //NSLog(@"更新 frame");
//        FloatDockVC * vc = (FloatDockVC *)self.contentViewController;
//
//        vc.appInfoEntity.x = self.frame.origin.x;
//        vc.appInfoEntity.y = self.frame.origin.y;
//
//        [AppInfoTool updateEntity];
//    }
//}

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
