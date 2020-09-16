//
//  AppInfoViewVM.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfoView.h"
#import "AppInfoEntity.h"

/*
 负责绘制AIV
 
 */
NS_ASSUME_NONNULL_BEGIN

static CGFloat AppWidth  = 48;
static CGFloat AppHeight = 58;
static CGFloat AppGap    = 10;
static CGFloat AppY      = 10;

static CGFloat VcHeight  = 70;

@interface AppInfoViewVM : NSObject <AppInfoViewProtocol>

@property (nonatomic, weak  ) NSView         * view;
@property (nonatomic, weak  ) AppInfoEntity  * appInfoEntity;
@property (nonatomic, strong) NSMutableArray * aivArray;

// 增加记录的 APP icon.
- (void)showBeforeAppPaths;

// 增加 一个 APP icon.
- (void)addAppPath:(NSString *)path;

// 增加 多个 APP icon, 使用 URL array
- (void)addAppUrlArray:(NSArray *)array;

// 增加 多个 APP icon, 使用 path array
- (void)addAppPathArray:(NSArray *)array;

// 清空 dock 上面的 APP icon.
- (void)clearDockAppAction;

// 删除该 dock
- (void)deleteDockAction;

// 检查 Dock 上面的 APP icon 状态.
- (void)checkDockAppActive:(NSMutableDictionary *)dic;

// 对外: 增加 APP icon 事件
- (void)addAppAction;

@end

NS_ASSUME_NONNULL_END
