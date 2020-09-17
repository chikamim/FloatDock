//
//  FloatDockVCProtocol.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import <AppKit/AppKit.h>
#import "AppIconItem.h"
#import "AppInfoEntity.h"

@class AppWindowTool;

NS_ASSUME_NONNULL_BEGIN

// MARK: 对外接口
@protocol FloatDockVCProtocol <NSObject>

- (NSViewController *)vc;

- (void)updateAppIconWidth;

- (void)updateWindowFrame;

// MARK: 自己的
@property (nonatomic, strong) NSScrollView * infoCvSV;
@property (nonatomic, strong) NSCollectionView * infoCV;
@property (nonatomic, strong) NSCollectionViewFlowLayout *infoCvLayout;
@property (nonatomic, weak  ) AppWindowTool * awt;

// MARK: 外部注入的
@property (nonatomic, weak  ) AppInfoEntity * appInfoEntity;
@property (nonatomic, copy  ) NSDictionary  * appActiveDic;

@end

// MARK: 数据来源
@protocol FloatDockVCDataSource <NSObject>

@end

// MARK: UI事件
@protocol FloatDockVCEventHandler <NSObject>

@end

NS_ASSUME_NONNULL_END
