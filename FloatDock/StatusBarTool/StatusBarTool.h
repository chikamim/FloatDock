//
//  StatusBarTool.h
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusBarTool : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSStatusItem * _Nullable statusItem;
@property (nonatomic, strong) NSMutableArray * barViewArray;
@property (nonatomic, strong) NSMutableDictionary * barViewDic;

// 切换显示状态栏icon
- (void)switchShowStatusBarAction;

- (void)updateStatusBarUI;

- (void)updateAppStatus:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
