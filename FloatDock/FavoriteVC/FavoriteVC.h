//
//  FavoriteVC.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger FavoriteVCWidth  = 400;
static NSInteger FavoriteVCHeight = 300;


@interface FavoriteVC : NSViewController

// 关闭监测键盘输入事件 和 本地键盘监测事件, 外部调运通常为YES.
- (void)closeEditHotkeyOuter;
- (void)closeEditHotkey:(BOOL)andMoniter;

@end

NS_ASSUME_NONNULL_END
