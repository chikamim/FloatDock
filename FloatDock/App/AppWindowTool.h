//
//  AppWindowTool.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatWindow.h"
#import "ViewController.h"
#import "AlphaSetVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppWindowTool : NSObject

@property (nonatomic, weak  ) AppInfoTool * appInfoTool;
@property (nonatomic, strong) NSDecimalNumber * windowAlphaNum;
@property (nonatomic, strong) NSDecimalNumber * num05;
@property (nonatomic, strong) NSDecimalNumber * num100;

@property (nonatomic, strong) NSWindow * alphaWindow;
@property (nonatomic, strong) AlphaSetVC  * alphaVC;

+ (instancetype)share;

- (void)showBeforeWindows;
- (void)createNewDockEvent:(CGPoint)origin;

- (void)alphaUpEvent;
- (void)alphaDownEvent;
@end

NS_ASSUME_NONNULL_END
