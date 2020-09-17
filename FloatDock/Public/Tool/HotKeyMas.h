//
//  HotKeyMas.h
//  FloatDock
//
//  Created by popor on 2020/9/15.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotKeyMas : NSObject

//@property (nonatomic        ) BOOL pauseMonitor;

+ (instancetype)share;

- (void)monitorKeyboard:(BOOL)enable;


@end

NS_ASSUME_NONNULL_END
