//
//  HotKeyTool.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FavoriteAppEntity.h"

#import "DataSavePath.h"
#import "NSParameterName.h"
//#import <PoporAFN/PoporAFN.h>
#import "HotKeyMas.h"
#import "StatusBarTool.h"

static NSString * FavoriteDBPath = @"favority";

@interface HotKeyTool ()

@end

@implementation HotKeyTool

+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        instance.favoriteAppArrayEntity = [instance getFavoriteAppArrayEntity];
        instance.favoriteAppsSigleArray = [NSMutableArray<FavoriteAppEntity> new];
        instance.favoriteHotkeyDic      = [NSMutableDictionary new];
        [instance updateHotkeyDic];
        [instance racUpdateFavoriteAppsSigleArray];
        
    });
    return instance;
}

// MARK: 打开APP
- (void)openAppWindows:(NSString * _Nullable)appPath {
    if (!appPath) {
        return;
    }
    appPath                           = appPath.stringByRemovingPercentEncoding;
    NSURL                * url        = [NSURL URLWithString:[appPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSRunningApplication * runningApp = self.runningAppsDic[appPath];
    
    // [self pushUrl:appPath];
    
    // 显示APP窗口
    if (url) {
        if (@available(macOS 10.15, *)) {
            // 2. 如果没有运行APP, 则打开最后一个窗口
            NSWorkspaceOpenConfiguration * config = [NSWorkspaceOpenConfiguration configuration];
            config.activates = YES;
            [[NSWorkspace sharedWorkspace] openApplicationAtURL:url configuration:config completionHandler:nil];
            
            // 通过某个APP打开某个文件.
            // [[NSWorkspace sharedWorkspace] openFile:@"/Myfiles/README" withApplication:@"TextEdit"];
        } else {
            // 2. 如果没有运行APP, 则打开最后一个窗口
            [[NSWorkspace sharedWorkspace] openURL:url];
        }
    }
    
    // 1. 假如有多个窗口, 则打开所有窗口, 全局运行的需要调换下顺序.
    if (runningApp) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [runningApp unhide];
        });
    }
}

- (void)pushUrl:(NSString *)appPath {
    // [PoporAFNTool title:@"FloadDock url" url:@"http:127.0.0.1:9000/requestAdd" method:PoporMethodPost parameters:@{@"appPath": appPath, @"title":@"FD:appPath", @"replace":@(YES)} success:nil failure:nil];
}

// MARK: TOOLS

// MARK: 收藏APP数据
- (FavoriteAppArrayEntity *)getFavoriteAppArrayEntity {
    //DataSavePath * path = [DataSavePath share];
    //NSData * data = [NSData dataWithContentsOfFile:path.DBPath];
    NSString * txt = [NSString stringWithContentsOfFile:[self savePath] encoding:NSUTF8StringEncoding error:nil];
    if (txt) {
        //NSString * txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //AppInfoArrayEntity * entity = [[AppInfoArrayEntity alloc] initWithData:data error:nil];
        FavoriteAppArrayEntity * entity = [[FavoriteAppArrayEntity alloc] initWithString:txt error:nil];
        if (entity) {
            return entity;
        } else {
            return [FavoriteAppArrayEntity new];
        }
    } else {
        return [FavoriteAppArrayEntity new];
    }
}

- (void)updateEntitySaveJson {
    [self saveAppInfoArrayEntity:self.favoriteAppArrayEntity];
    [self updateHotkeyDic];
    
    [[StatusBarTool share] updateStatusBarUI];
}

- (void)updateHotkeyDic {
    [self.favoriteHotkeyDic removeAllObjects];
    for (FavoriteAppEntity * app in self.favoriteAppArrayEntity.array) {
        if (app.hotKey.length > 0 && app.enable) {
            //NSLog(@"app.hotKey: %@", app.hotKey);
            NSMutableArray * array = [self.favoriteHotkeyDic objectForKey:app.hotKey];
            if (array) {
                [array addObject:app];
            } else {
                array = [NSMutableArray new];
                [array addObject:app];
                [self.favoriteHotkeyDic setObject:array forKey:app.hotKey];
            }
            
        }
    }
    
    [[HotKeyMas share] monitorKeyboard:YES];
}

- (void)saveAppInfoArrayEntity:(FavoriteAppArrayEntity *)entity {
    if (entity) {
        [entity.toJSONString writeToFile:[self savePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        //[[NSFileManager defaultManager] createDirectoryAtPath:path.cachesPath withIntermediateDirectories:YES attributes:nil error:nil]; // 放在单例中执行
    }
}

- (NSString *)savePath {
    DataSavePath * path = [DataSavePath share];
#if DEBUG
    return [NSString stringWithFormat:@"%@/%@Debug.txt", path.cachesPath, FavoriteDBPath];
#else
    return [NSString stringWithFormat:@"%@/%@.txt", path.cachesPath, FavoriteDBPath];
#endif
}

// 新增APP, 需要顺带更新favoriteAppsSigleArray
- (void)racAddFavoriteAppEntity:(FavoriteAppEntity *)entity {
    static NSString * mKey;
    if (!mKey) {
        mKey = [NSParameterName entity:self.favoriteAppArrayEntity equalTo:self.favoriteAppArrayEntity.array];
    }
    
    [[self.favoriteAppArrayEntity mutableArrayValueForKey:mKey] addObject:entity];
    
    [self updateEntitySaveJson];
    [self racUpdateFavoriteAppsSigleArray];
}

// 删除APP, 需要顺带更新favoriteAppsSigleArray
- (void)racRemoveFavoriteAppEntity:(FavoriteAppEntity *)entity {
    static NSString * mKey;
    if (!mKey) {
        mKey = [NSParameterName entity:self.favoriteAppArrayEntity equalTo:self.favoriteAppArrayEntity.array];
    }
    
    [[self.favoriteAppArrayEntity mutableArrayValueForKey:mKey] removeObject:entity];
    
    [self updateEntitySaveJson];
    [self racUpdateFavoriteAppsSigleArray];
}

- (void)racUpdateFavoriteAppsSigleArray {
    static NSString * mKey;
    if (!mKey) {
        mKey = [NSParameterName entity:self equalTo:self.favoriteAppsSigleArray];
    }
    
    //NSMutableArray * array = [NSMutableArray<FavoriteAppEntity> new];
    [self.favoriteAppsSigleArray removeAllObjects];
    NSMutableSet * set = [NSMutableSet new];
    for (FavoriteAppEntity * app in self.favoriteAppArrayEntity.array) {
        if (![set containsObject:app.name]) {
            [set addObject:app.name];
            //[array addObject:app];
            [[self mutableArrayValueForKey:mKey] addObject:app];
        }
    }
    
}

@end
