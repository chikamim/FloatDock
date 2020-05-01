//
//  HotKeyTool.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "FavoriteAppEntity.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * HotKeyEnd = @"#";

@interface HotKeyTool : NSObject

@property (nonatomic        ) NSEventModifierFlags flagsGlobal;
@property (nonatomic, copy  ) NSString * charactersGlobal;

@property (nonatomic        ) NSEventModifierFlags flagsLocal;
@property (nonatomic, copy  ) NSString * charactersLocal;
@property (nonatomic, copy  ) NSString * currentKeyboardLocal;

// !!!: wkq 应该移除掉
@property (nonatomic, copy  ) NSSet * runningAppsSet;
@property (nonatomic, copy  ) NSDictionary * runningAppsDic;

+ (instancetype)share;

- (void)updateGlobalMonitorKeyboardEvent:(BOOL)enable;
- (void)updateLocalMonitorKeyboardEvent:(BOOL)enable;

//已经完成数据转移, 还剩余什么时候控制全局本地监听键盘
// MARK: 收藏数据部分
@property (nonatomic, strong) FavoriteAppArrayEntity * favoriteApps;
@property (nonatomic, strong) NSMutableDictionary    * favoriteHotkeyDic;
// 更新数组, 内置方法可以触发RACObserver
- (void)addFavoriteAppEntity:(FavoriteAppEntity *)entity;
- (void)removeFavoriteAppEntity:(FavoriteAppEntity *)entity;

- (void)updateEntitySaveJson;

//- (void)updateHotkeyDic; // 考虑到代码复杂度, 改为内置函数


@end

NS_ASSUME_NONNULL_END
