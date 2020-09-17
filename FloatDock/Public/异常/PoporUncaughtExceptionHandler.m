//
//  PoporUncaughtExceptionHandler.m
//  FloatDock
//
//  Created by popor on 2020/9/12.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "PoporUncaughtExceptionHandler.h"
#import <PoporAFN/PoporAFN.h>

@implementation PoporUncaughtExceptionHandler

+ (void)saveException:(NSException *)exception {
    
    //NSString * appTitle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * buide    = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    NSArray  * arr      = [exception callStackSymbols];
    NSString * reason   = [exception reason];
    NSString * name     = [exception name];
    // NSString * content  = [arr componentsJoinedByString:@"\r\n"]; // 方便网页查看, 目前不需要
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"appTitle"]       = @"FloatDock";
    dic[@"appversion"]     = version;
    dic[@"appbuide"]       = buide;
    dic[@"appCrashReason"] = reason;
    dic[@"appCrashname"]   = name;
    dic[@"crash"]          = arr;
    //    NSMutableArray * array = [NSMutableArray new];
    //    for (NSInteger i = 0; i<arr.count; i++) {
    //        dic[[NSString stringWithFormat:@"c%02li", i]] = arr[i];
    //    }
    
    {
        NSError  * error = nil;
        NSData   * data  = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
        NSString * str   = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self saveCrashInfo:str];
    }
}

+ (void)saveCrashInfo:(NSString *)crashInfo {
    [[NSUserDefaults standardUserDefaults] setObject:crashInfo forKey:@"crashInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCrashInfo {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"crashInfo"];
    return info;
}

+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString * crashInfo = [PoporUncaughtExceptionHandler getCrashInfo];
        if (crashInfo.length > 1) {
            NSData       * data = [crashInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dic) {
                [PoporAFNTool title:@"崩溃信息" url:@"http:127.0.0.1:9000/requestAdd" method:PoporMethodPost parameters:dic success:^(NSString * _Nonnull url, NSData * _Nullable data, NSDictionary * _Nullable dic) {
                    [PoporUncaughtExceptionHandler saveCrashInfo:@""];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [PoporUncaughtExceptionHandler saveCrashInfo:@""];
                }];
            }
        }
    });
}

@end
