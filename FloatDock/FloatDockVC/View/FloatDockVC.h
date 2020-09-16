//
//  FloatDockVC.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "FloatDockVCProtocol.h"

@interface FloatDockVC : NSViewController <FloatDockVCProtocol>

- (void)checkDockAppActive:(NSMutableDictionary *)dic;


- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)addViews;

// 开始执行事件,比如获取网络数据
- (void)startEvent;


@end

