//
//  FloatDockVCPresenter.h
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import <Foundation/Foundation.h>
#import "FloatDockVCProtocol.h"

// 处理和View事件
@interface FloatDockVCPresenter : NSObject <FloatDockVCEventHandler, FloatDockVCDataSource, NSCollectionViewDelegate, NSCollectionViewDataSource>


- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end

