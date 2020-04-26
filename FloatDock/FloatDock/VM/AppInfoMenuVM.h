//
//  AppInfoMenuVM.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AppInfoEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FloatDockBlockPVoid) (void);

@interface AppInfoMenuVM : NSObject

@property (nonatomic, weak  ) NSView * view;
@property (nonatomic, weak  ) AppInfoEntity  * appInfoEntity;

- (void)addMenus;

- (void)addAppAction;

// 对外: 清空dock
- (void)clearDockAppAction;
// 对外: 删除dock
- (void)deleteDockAction;

// 对外: 新增APP url 数组
- (void)addAppUrlArray:(NSArray *)array;
// 对外: 新增APP path 数组
- (void)addAppPathArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
