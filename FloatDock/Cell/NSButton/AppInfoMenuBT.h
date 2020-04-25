//
//  AppInfoMenuBT.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppInfoMenuBTProtocol <NSObject>

- (void)delete:(NSButton *)appInfoMenuBT;
- (void)moveLeft:(NSButton *)appInfoMenuBT;
- (void)moveRight:(NSButton *)appInfoMenuBT;

@end

@interface AppInfoMenuBT : NSButton

@property (nonatomic, weak  ) id<AppInfoMenuBTProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
