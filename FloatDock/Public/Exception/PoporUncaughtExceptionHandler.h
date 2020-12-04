//
//  PoporUncaughtExceptionHandler.h
//  FloatDock
//
//  Created by popor on 2020/9/12.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//void UncaughtExceptionHandler(NSException *exception) {
//    [PoporUncaughtExceptionHandler saveException:exception];
//}

//    // 测试崩溃代码
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSButton * bt = [NSButton buttonWithTitle:@"  " target:nil action:nil];
//        NSString * str = (NSString *)bt;
//        NSLog(@"str: %li", str.length);
//    });

@interface PoporUncaughtExceptionHandler : NSObject

+ (void)saveException:(NSException *)exception;

+ (void)saveCrashInfo:(NSString *)crashInfo;

+ (NSString *)getCrashInfo;

@end


//void UncaughtExceptionHandler(NSException *exception) {
//    [PoporUncaughtExceptionHandler saveException:exception];
//
//    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString * buide   = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//
//    NSArray  * arr     = [exception callStackSymbols];
//    NSString * reason  = [exception reason];
//    NSString * name    = [exception name];
//    NSString * content = [arr componentsJoinedByString:@"\r\n"];
//
//    NSDictionary * dic =
//    @{
//        @"version":version,
//        @"buide":buide,
//        @"reason":reason,
//        @"name":name,
//        @"content":content,
//    };
//
//    [PoporUncaughtExceptionHandler saveCrashInfo:[dic description]];
//}

NS_ASSUME_NONNULL_END
