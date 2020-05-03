//
//  HotKeyTool.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Carbon/Carbon.h> // kVK_Space; 识别键盘类型 // https://blog.csdn.net/weixin_33862514/article/details/89664156
#import "FavoriteAppEntity.h"

#import "DataSavePath.h"
#import "NSParameterName.h"

static NSString * FavoriteDBPath = @"favority";

@interface HotKeyTool ()

@property (nonatomic, strong) NSEvent * localEvent1;
@property (nonatomic, strong) NSEvent * localEvent2;
@property (nonatomic, strong) NSEvent * localEvent3;

@property (nonatomic, strong) NSEvent * globalEvent1;
@property (nonatomic, strong) NSEvent * globalEvent2;
@property (nonatomic, strong) NSEvent * globalEvent3;

@end

@implementation HotKeyTool

+ (instancetype)share {
    static dispatch_once_t once;
    static HotKeyTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance racBindEvent];
        
        instance.favoriteAppArrayEntity = [instance getFavoriteAppArrayEntity];
        instance.favoriteAppsSigleArray = [NSMutableArray<FavoriteAppEntity> new];
        instance.favoriteHotkeyDic      = [NSMutableDictionary new];
        [instance updateHotkeyDic];
        [instance updateFavoriteAppsSigleArray];
        
    });
    return instance;
}

/**
 // 全局监听事件 链接：https://blog.csdn.net/ZhangWangYang/article/details/95952046
 */
- (void)updateLocalMonitorKeyboard:(BOOL)enable {
    if (!enable) {
        if (self.localEvent1) {
            [NSEvent removeMonitor:self.localEvent1];
            [NSEvent removeMonitor:self.localEvent2];
            [NSEvent removeMonitor:self.localEvent3];
            
            self.localEvent1 = nil;
            self.localEvent2 = nil;
            self.localEvent3 = nil;
        }
    } else {
        if (self.localEvent1) {
            return;
        }
        @weakify(self);
        // 本地 修饰符
        self.localEvent1 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            self.flagsLocal = event.modifierFlags;
            return event;
        }];
        
        // 本地 键盘
        self.localEvent2 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            NSString * key = [self convertKeyboard:event.keyCode];
            self.charactersLocal = key ? [NSString stringWithFormat:@"%@%@", key, HotKeyEnd] : @"";
            //NSLog(@"设置字符: %@", event.charactersIgnoringModifiers);
            //NSLog(@"设置字符: %@", self.characters);
            return event;
        }];
        
        self.localEvent3 = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            @strongify(self);
            self.charactersLocal = @"";
            return event;
        }];
    }
}

- (void)updateGlobalMonitorKeyboard:(BOOL)enable {
    if (!enable) {
        if (self.globalEvent1) {
            [NSEvent removeMonitor:self.globalEvent1];
            [NSEvent removeMonitor:self.globalEvent2];
            [NSEvent removeMonitor:self.globalEvent3];
            
            self.globalEvent1 = nil;
            self.globalEvent2 = nil;
            self.globalEvent3 = nil;
        }
    } else {
        if (self.globalEvent1) {
            return;
        }
        @weakify(self);
        // 全局
        self.globalEvent1 = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^(NSEvent * event) {
            @strongify(self);
            //NSLog(@"event: %@\n\n", event);
            //NSLog(@"全局 修饰符 event: %li", event.modifierFlags);
            
            self.flagsGlobal = event.modifierFlags;
        }];
        
        self.globalEvent2 = [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyDown handler:^(NSEvent *event){
            //NSLog(@"全局 键盘 event: %@", event.characters);
            @strongify(self);
            
            self.charactersGlobal = [self convertKeyboard:event.keyCode];
            //NSLog(@"设置字符: %@", event.charactersIgnoringModifiers);
            //NSLog(@"设置字符: %@", self.characters);
        }];
        self.globalEvent3 = [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskKeyUp handler:^(NSEvent *event){
            //NSLog(@"全局 键盘 event: %@", event.characters);
            @strongify(self);
            self.charactersGlobal = @"";
            
        }];
    }
}

// MARK: 监听收集到的键盘事件
- (void)racBindEvent {
    
    @weakify(self);
    // 全局
    RACSignal * signalGlobal = [RACSignal combineLatest:@[RACObserve(self, flagsGlobal), RACObserve(self, charactersGlobal)] reduce:^id (id flags, NSString * characters){
        @strongify(self);
        NSString * flagText = [self convertFlag:[flags integerValue]];
        NSString * keyText  = [characters uppercaseString];
        NSLog(@"%@:%@ - %@", flags, flagText, characters);
        if (flagText.length > 0 && keyText.length>0) {
            return [NSString stringWithFormat:@"%@%@", flagText, keyText];
        } else {
            return nil;
        }
    }];
    [signalGlobal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //NSLog(@"全局监测结果 : %@", x);
        if (x) {
            NSMutableArray * array = self.favoriteHotkeyDic[x];
            for (NSInteger i = 0; i<array.count; i++) {
                FavoriteAppEntity * entity = array[i];
                NSLog(@"name: %@", entity.name);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self openAppWindows:entity.path];
                });
            }
            //NSLog(@"全局监测结果 : %@ ---------2 \n", x);
        }
    }];
    
    // 本地
    RAC(self, currentKeyboardLocal) = [RACSignal combineLatest:@[RACObserve(self, flagsLocal), RACObserve(self, charactersLocal)] reduce:^id (id flags, NSString * characters){
        @strongify(self);
        //NSLog(@"本地 %@ - %@", flags, characters);
        NSString * key = [NSString stringWithFormat:@"%@%@", [self convertFlag:[flags integerValue]], [characters uppercaseString]];
        return key;
    }];
}

// MARK: 打开APP
- (void)openAppWindows:(NSString *)appPath {
    NSString * str = appPath;

    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:str];
        
    {
        // 2. 如果没有运行APP, 则打开最后一个窗口
        NSWorkspaceOpenConfiguration * config = [NSWorkspaceOpenConfiguration configuration];
        config.activates = YES;
        [[NSWorkspace sharedWorkspace] openApplicationAtURL:url configuration:config completionHandler:nil];
    }
    
    // 1. 假如有多个窗口, 则打开所有窗口, 全局运行的需要调换下顺序.
    NSRunningApplication * runningApp = self.runningAppsDic[appPath];
    if (runningApp) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [runningApp unhide];
        });
    }
}

// MARK: TOOLS
// 键盘修饰符 https://www.jianshu.com/p/f46a5f5dfed7
- (NSMutableString *)convertFlag:(NSEventModifierFlags)flags {
    NSMutableString * flagsString = [NSMutableString new];
    if (flags & NSEventModifierFlagFunction) {
        [flagsString appendString:@"Fn"];
    }
    if (flags & NSEventModifierFlagShift) {
        [flagsString appendString:@"⇧"];
    }
    if (flags & NSEventModifierFlagControl) {
        [flagsString appendString:@"⌃"];
    }
    if (flags & NSEventModifierFlagOption) {
        [flagsString appendString:@"⌥"];
    }
    if (flags & NSEventModifierFlagCommand) {
        [flagsString appendString:@"⌘"];
    }
    return flagsString;
}

// 键盘字母符 https://blog.csdn.net/weixin_33862514/article/details/89664156
- (NSString *)convertKeyboard:(int)keycode {
    NSString * str;
    switch (keycode) {
        case kVK_ANSI_A:{
            str = @"A";
            break;
        }
        case kVK_ANSI_B:{
            str = @"B";
            break;
        }
        case kVK_ANSI_C:{
            str = @"C";
            break;
        }
        case kVK_ANSI_D:{
            str = @"D";
            break;
        }
        case kVK_ANSI_E:{
            str = @"E";
            break;
        }
        case kVK_ANSI_F:{
            str = @"F";
            break;
        }
        case kVK_ANSI_G:{
            str = @"G";
            break;
        }
        case kVK_ANSI_H:{
            str = @"H";
            break;
        }
        case kVK_ANSI_I:{
            str = @"I";
            break;
        }
        case kVK_ANSI_J:{
            str = @"J";
            break;
        }
        case kVK_ANSI_K:{
            str = @"K";
            break;
        }
        case kVK_ANSI_L:{
            str = @"L";
            break;
        }case kVK_ANSI_M:{
            str = @"M";
            break;
        }
        case kVK_ANSI_N:{
            str = @"N";
            break;
        }
        case kVK_ANSI_O:{
            str = @"O";
            break;
        }
        case kVK_ANSI_P:{
            str = @"P";
            break;
        }
        case kVK_ANSI_Q:{
            str = @"Q";
            break;
        }
        case kVK_ANSI_R:{
            str = @"R";
            break;
        }
        case kVK_ANSI_S:{
            str = @"S";
            break;
        }
        case kVK_ANSI_T:{
            str = @"T";
            break;
        }
        case kVK_ANSI_U:{
            str = @"U";
            break;
        }
        case kVK_ANSI_V:{
            str = @"V";
            break;
        }
        case kVK_ANSI_W:{
            str = @"W";
            break;
        }
        case kVK_ANSI_X:{
            str = @"X";
            break;
        }
        case kVK_ANSI_Y:{
            str = @"Y";
            break;
        }
        case kVK_ANSI_Z:{
            str = @"Z";
            break;
        }
        case kVK_ANSI_0:{
            str = @"0";
            break;
        }
        case kVK_ANSI_1:{
            str = @"1";
            break;
        }
        case kVK_ANSI_2:{
            str = @"2";
            break;
        }
        case kVK_ANSI_3:{
            str = @"3";
            break;
        }
        case kVK_ANSI_4:{
            str = @"4";
            break;
        }
        case kVK_ANSI_5:{
            str = @"5";
            break;
        }
        case kVK_ANSI_6:{
            str = @"6";
            break;
        }
        case kVK_ANSI_7:{
            str = @"7";
            break;
        }
        case kVK_ANSI_8:{
            str = @"8";
            break;
        }
        case kVK_ANSI_9:{
            str = @"9";
            break;
        }
        case kVK_ANSI_Minus:{
            str = @"_";
            break;
        }
        case kVK_ANSI_Equal:{
            str = @"=";
            break;
        }
        case kVK_ANSI_LeftBracket:{
            str = @"[";
            break;
        }
        case kVK_ANSI_RightBracket:{
            str = @"]";
            break;
        }
        case kVK_ANSI_Semicolon:{
            str = @";";
            break;
        }
        case kVK_ANSI_Quote:{
            str = @"'";
            break;
        }
        case kVK_ANSI_Comma:{
            str = @",";
            break;
        }
        case kVK_ANSI_Period:{
            str = @".";
            break;
        }
        case kVK_ANSI_Slash:{
            str = @"/";
            break;
        }
        case kVK_ANSI_Backslash:{
            //str = @"/"; 删除
            break;
        }
        case kVK_Delete:{
            str = @"⌫";
            break;
        }
            
        default:
            break;
    }
    //NSLog(@"keycode: %i, str: %@", keycode, str);
    return str;
}

/**
 1. 如果没有系统权限, 是无法获得全局点击键盘功能的.
 2. 除此之外, mac app 还需打开 app > target > Signing & Capabilities > Signing Certificate.
 */
- (void)alertUserGetSystemKeyboardPermission {
    // MacOS获取辅助功能权限控制鼠标点击事件
    // https://blog.csdn.net/cocos2der/article/details/53393026
    //    let opts = NSDictionary(object: kCFBooleanTrue,
    //                            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    //                ) as CFDictionary
    //
    //    guard AXIsProcessTrustedWithOptions(opts) == true else { return }
    
    NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt : @YES};
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);
    NSLog(@"获取APP读取系统权限 acc : %i", accessibilityEnabled);
}


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
}

- (void)updateHotkeyDic {
    [self.favoriteHotkeyDic removeAllObjects];
    for (FavoriteAppEntity * app in self.favoriteAppArrayEntity.array) {
        if (app.hotKey.length > 0 && app.receive) {
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
    
    [self updateGlobalMonitorKeyboard:self.favoriteHotkeyDic.count > 0 ? YES:NO ];
}

- (void)saveAppInfoArrayEntity:(FavoriteAppArrayEntity *)entity {
    if (entity) {
        [entity.toJSONString writeToFile:[self savePath] atomically:yearMask encoding:NSUTF8StringEncoding error:nil];
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
- (void)addFavoriteAppEntity:(FavoriteAppEntity *)entity {
    static NSString * mKey;
    if (!mKey) {
        mKey = [NSParameterName entity:self.favoriteAppArrayEntity equalTo:self.favoriteAppArrayEntity.array];
    }
    
    [[self.favoriteAppArrayEntity mutableArrayValueForKey:mKey] addObject:entity];
    
    [self updateEntitySaveJson];
    [self updateFavoriteAppsSigleArray];
}

// 删除APP, 需要顺带更新favoriteAppsSigleArray
- (void)removeFavoriteAppEntity:(FavoriteAppEntity *)entity {
    static NSString * mKey;
    if (!mKey) {
        mKey = [NSParameterName entity:self.favoriteAppArrayEntity equalTo:self.favoriteAppArrayEntity.array];
    }
    
    [[self.favoriteAppArrayEntity mutableArrayValueForKey:mKey] removeObject:entity];
    
    [self updateEntitySaveJson];
    [self updateFavoriteAppsSigleArray];
}

- (void)updateFavoriteAppsSigleArray {
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
