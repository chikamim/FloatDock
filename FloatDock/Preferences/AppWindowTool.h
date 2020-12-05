//
//  AppWindowTool.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatWindow.h"
#import "FloatDockVC.h"
#import "AlphaSetVC.h"
#import "FavoriteVC.h"
#import "FavoriteWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppWindowTool : NSObject

@property (nonatomic, weak  ) AppInfoTool * appInfoTool;
@property (nonatomic, strong) NSDecimalNumber * windowAlphaNum;
@property (nonatomic, strong) NSDecimalNumber * appIconWidthNum;

@property (nonatomic, strong) NSDecimalNumber * num1;
@property (nonatomic, strong) NSDecimalNumber * num5;
@property (nonatomic, strong) NSDecimalNumber * num100;

@property (nonatomic, strong) NSWindow * alphaWindow;
@property (nonatomic, strong) AlphaSetVC  * alphaVC;

@property (nonatomic, strong) NSWindowController * favoriteWC;
@property (nonatomic, strong) FavoriteWindow * favoriteWindow;
@property (nonatomic, strong) FavoriteVC  * favoriteVC;

+ (instancetype)share;

- (void)showBeforeWindows;
- (void)createNewDockEvent:(CGPoint)origin;

- (void)alphaUpEvent;
- (void)alphaDownEvent;

- (void)sizeUpEvent;
- (void)sizeDownEvent;

- (void)openFavoriteWindows;

@end

NS_ASSUME_NONNULL_END
