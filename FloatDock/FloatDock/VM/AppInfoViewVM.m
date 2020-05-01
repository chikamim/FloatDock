//
//  AppInfoViewVM.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoViewVM.h"
#import "HotKeyTool.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface AppInfoViewVM ()

@property (nonatomic        ) BOOL initFrame;

@end

@implementation AppInfoViewVM

- (id)init {
    if (self = [super init]) {
        _aivArray = [NSMutableArray new];
    }
    return self;
}

// MARK: 增加
- (void)showBeforeAppPaths {
    CGFloat maxX = 70;
    for (NSInteger i = 0; i<self.appInfoEntity.appPathArray.count; i++) {
        maxX =[self addBT:i];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect;
        if (!self.initFrame) {
            self.initFrame = YES;
            rect = CGRectMake(self.appInfoEntity.x, self.appInfoEntity.y,
                              maxX, VcHeight);
        } else {
            rect = CGRectMake(self.view.window.frame.origin.x, self.view.window.frame.origin.y,
                              maxX, VcHeight);
        }
        [self.view.window setFrame:rect display:YES];
        
        //[self.view.window setLevel:NSFloatingWindowLevel];
    });
}

- (void)addAppUrlArray:(NSArray *)array {
    for (int i = 0; i<array.count; i++) {
        if (i == 0) {
            [self removeNilAiv];
        }
        NSString * path = [array[i] path];
        [self addAppPath:path];
    }
    [self checkActiveSelf];
    
    [AppInfoTool updateEntity];
}

- (void)addAppPathArray:(NSArray *)array {
    for (int i = 0; i<array.count; i++) {
        if (i == 0) {
            [self removeNilAiv];
        }
        NSString * path = array[i];
        [self addAppPath:path];
    }
    [self checkActiveSelf];
    
    [AppInfoTool updateEntity];
}

- (void)addAppPath:(NSString *)path {
    [self.appInfoEntity.appPathArray addObject:[NSString stringWithFormat:@"file://%@/", path]];
    CGFloat maxX = [self addBT:self.appInfoEntity.appPathArray.count - 1];
    
    [self updateFrameMaxX:maxX];
}

// 移除第一个空的 aiv
- (void)removeNilAiv {
    if (self.appInfoEntity.appPathArray.firstObject.length == 0) {
        [self.appInfoEntity.appPathArray removeAllObjects];
        AppInfoView * aiv = self.aivArray.firstObject;
        
        [aiv removeFromSuperview];
        [self.aivArray removeObject:aiv];
    }
}

- (CGFloat)addBT:(NSInteger)index {
    //CGFloat width = AppWidth;
    //CGFloat gap   = AppGap;
    
    AppInfoView * aiv = ({
        NSString * str = self.appInfoEntity.appPathArray[index];
        //str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        AppInfoView * oneAIV = [AppInfoView new];
        oneAIV.delegate     = self;
        //oneAIV.appBT.target = self;
        //oneAIV.appBT.action = @selector(btAction:aiv:);
        
        @weakify(self);
        @weakify(oneAIV);
        oneAIV.appBT.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            @strongify(oneAIV);
            
            [self btAction_AppInfoView:oneAIV];
            return [RACSignal empty];
        }];
        
        
        if (str.length == 0) {
            [oneAIV.appBT setImage:[NSImage imageNamed:@"icon48"]];
            
        } else {
            // http://hk.uwenku.com/question/p-vrwwdiql-bnz.html
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            NSImage *finderIcon;
            //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
            finderIcon = [workspace iconForFile:[str substringFromIndex:7]];
            [finderIcon setSize:NSMakeSize(AppWidth, AppWidth)];
            
            [oneAIV.appBT setImage:finderIcon];
        }
        
        oneAIV.appBT.tag = index;
        
        [self.view addSubview:oneAIV];
        
        oneAIV;
    });
    
    aiv.frame = [AppInfoViewVM aivFrameIndex:index];
    aiv.appBT.frame = CGRectMake(0, 10, AppWidth, AppWidth);
    aiv.appPath    = self.appInfoEntity.appPathArray[index];
    aiv.appUrlPath = [aiv.appPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [self.aivArray addObject:aiv];
    return CGRectGetMaxX(aiv.frame) + AppGap;
}

//- (void)btAction:(NSButton *)bt aiv:(AppInfoView *)aiv {
- (void)btAction_AppInfoView:(AppInfoView *)aiv {
    //NSURL * url = [NSURL URLWithString:@"file:///Applications/Google%20Chrome.app/"];
    
    NSString * str = self.appInfoEntity.appPathArray[aiv.appBT.tag];
    if (str.length == 0) {
        [self addAppAction];
    } else {
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL * url = [NSURL URLWithString:str];
        
        if (url) {
            if ([NSEvent modifierFlags] & NSEventModifierFlagCommand) {
                // NSLog(@"按下了 command");
                // https://stackoom.com/question/39rQu/如果用户在应用程序开始运行之前将其按下-该如何检测是否按下了Shift 判断command键代码
                NSString * path   = [url.absoluteString substringFromIndex:7].stringByRemovingPercentEncoding;
                NSString * folder = [path substringToIndex:path.length - url.lastPathComponent.length-1];
                [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:folder];
            } else {
                // 1. 假如有多个窗口, 则打开所有窗口
                [aiv.runningApp unhide];
                
                // 2. 如果没有运行APP, 则打开最后一个窗口
                NSWorkspaceOpenConfiguration * config = [NSWorkspaceOpenConfiguration configuration];
                config.activates = YES;
                [[NSWorkspace sharedWorkspace] openApplicationAtURL:url configuration:config completionHandler:nil];
            }
        }
    }
    // [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]]; // 打开文件夹
}

- (void)addAppAction {
    
}

- (void)updateFrameMaxX:(CGFloat)maxX {
    CGRect rect = CGRectMake(self.view.window.frame.origin.x,
                             self.view.window.frame.origin.y,
                             maxX,
                             VcHeight);
    
    [self.view.window setFrame:rect display:YES];
    //[self.view.window setLevel:NSFloatingWindowLevel];
}

- (void)clearDockAppAction {
    if (self.appInfoEntity.appPathArray.firstObject.length == 0) {
        return;
    }
    
    [self.appInfoEntity.appPathArray removeAllObjects];
    for (AppInfoView * aiv in self.aivArray) {
        [aiv removeFromSuperview];
    }
    [self.aivArray removeAllObjects];
    
    // 加载一个默认的
    [self.appInfoEntity.appPathArray addObject:@""];
    [self showBeforeAppPaths];
    
    // 更新 data
    [AppInfoTool updateEntity];
}

- (void)deleteDockAction {
    [[AppInfoTool share].appInfoArrayEntity.windowArray removeObject:self.appInfoEntity];
    [AppInfoTool updateEntity];
    
    [self.view.window close];
}

// MARK: AIV 的 delegate
- (void)exit:(AppInfoView *)appInfoView {
    //[appInfoView.runningApp terminate];
    //NSLog(@"appInfoView.runningApp.processIdentifier: %i", appInfoView.runningApp.processIdentifier);
    //NSApplication * app = [NSRunningApplication runningApplicationWithProcessIdentifier:appInfoView.runningApp.processIdentifier];
    
    // https://stackoverrun.com/cn/q/3714068
    //CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
    
    // 无效的代码, 不知为何.
    if (appInfoView.runningApp) {
        [appInfoView.runningApp forceTerminate];
    }
}

- (void)delete:(AppInfoView *)appInfoView {
    [self.appInfoEntity.appPathArray removeObjectAtIndex:appInfoView.appBT.tag];
    [self.aivArray removeObject:appInfoView];
    
    [appInfoView removeFromSuperview];
    
    for (int index = 0; index< self.aivArray.count; index++) {
        AppInfoView * aiv = self.aivArray[index];
        aiv.appBT.tag = index;
        
        aiv.frame = [AppInfoViewVM aivFrameIndex:index];
    }
    
    if (self.appInfoEntity.appPathArray.count == 0) {
        [self.appInfoEntity.appPathArray addObject:@""];
        
        [self showBeforeAppPaths]; // 包含了 刷新 frame
    } else {
        AppInfoView * aiv = (AppInfoView *)[self.aivArray lastObject];
        CGFloat maxX = CGRectGetMaxX(aiv.frame) + AppGap;
        
        [self updateFrameMaxX:maxX];
    }
    
    [AppInfoTool updateEntity];
}

- (void)moveLeft:(AppInfoView *)appInfoView  {
    if (appInfoView.appBT.tag == 0) {
        return;
    } else {
        [self exchangeAIV:appInfoView withIndex:appInfoView.appBT.tag-1];
        [AppInfoTool updateEntity];
    }
}

- (void)moveRight:(AppInfoView *)appInfoView {
    if (appInfoView.appBT.tag >= self.appInfoEntity.appPathArray.count - 1) {
        return;
    } else {
        [self exchangeAIV:appInfoView withIndex:appInfoView.appBT.tag+1];
        [AppInfoTool updateEntity];
    }
}

- (void)exchangeAIV:(AppInfoView *)aiv1 withIndex:(NSInteger)exchangeTag {
    AppInfoView * changeAIV = self.aivArray[exchangeTag];
    
    [self.appInfoEntity.appPathArray exchangeObjectAtIndex:aiv1.appBT.tag withObjectAtIndex:exchangeTag];
    [self.aivArray exchangeObjectAtIndex:aiv1.appBT.tag withObjectAtIndex:exchangeTag];
    
    CGRect rect           = changeAIV.frame;
    changeAIV.frame       = aiv1.frame;
    aiv1.frame            = rect;
    
    NSInteger tag         = changeAIV.appBT.tag;
    changeAIV.appBT.tag   = aiv1.appBT.tag;
    aiv1.appBT.tag = tag;
}

- (void)getPid:(AppInfoView *)appInfoView {
    //NSLog(@"appInfoView.runningApp.processIdentifier: %i", appInfoView.runningApp.processIdentifier);
    NSString * pid = [NSString stringWithFormat:@"%i", appInfoView.runningApp.processIdentifier];
    
    NSPasteboard * pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:pid forType:NSPasteboardTypeString];
}

- (void)favorite:(AppInfoView *)appInfoView {
    FavoriteAppEntity * entity = [FavoriteAppEntity new];
    entity.path = appInfoView.appPath;
    entity.name = entity.path.lastPathComponent;
    entity.name = entity.name.stringByDeletingPathExtension;
    
    [[HotKeyTool share] addFavoriteAppEntity:entity];
    //self.favoriteAppTool.arrayEntity
    //[[FavoriteAppTool share].arrayEntity.appArray addObject:entity];
}

- (void)lldbFront:(AppInfoView *)appInfoView {
    NSString * lldb =
    [NSString stringWithFormat:@"\
     process attach --pid %i \n\
     e NSApplication $app = [NSApplication sharedApplication];\n\
     e NSWindow $win = $app.windows[0];\n\
     e [$win setLevel: 3];\n\
     exit \n\
     y \n", appInfoView.runningApp.processIdentifier];
    
    NSPasteboard * pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:lldb forType:NSPasteboardTypeString];
}

- (void)lldbNormal:(AppInfoView *)appInfoView {
    NSString * lldb =
    [NSString stringWithFormat:@"\
     process attach --pid %i \n\
     e NSApplication $app = [NSApplication sharedApplication];\n\
     e NSWindow $win = $app.windows[0];\n\
     e [$win setLevel: 0];\n\
     exit \n\
     y \n", appInfoView.runningApp.processIdentifier];
    
    NSPasteboard * pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:lldb forType:NSPasteboardTypeString];
}

+ (CGRect)aivFrameIndex:(NSInteger)index {
    return CGRectMake(AppWidth * index + AppGap*(index + 1), AppY, AppWidth, AppHeight);
}

// MARK: 检查小白点
// 自己单独检查
- (void)checkActiveSelf {
    NSWorkspace * work = [NSWorkspace sharedWorkspace];
    NSArray<NSRunningApplication *> * appAppArray =[work runningApplications];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    for (NSRunningApplication * oneApp in appAppArray) {
        if (oneApp.activationPolicy == NSApplicationActivationPolicyRegular) {
            [dic setObject:oneApp forKey:oneApp.bundleURL.absoluteString];
        }
    }
    [self checkDockAppActive:dic];
}

- (void)checkDockAppActive:(NSMutableDictionary *)dic {
    for (AppInfoView * aiv in self.aivArray) {
        //NSLog(@"aiv.appPath: %@", aiv.appUrlPath);
        NSRunningApplication * runningApp = dic[aiv.appUrlPath];
        if (runningApp) {
            aiv.runningApp = dic[aiv.appUrlPath];
            aiv.activeIV.hidden = NO;
        } else{
            aiv.activeIV.hidden = YES;
        }
    }
}

@end
