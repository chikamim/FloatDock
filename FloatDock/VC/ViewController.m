//
//  ViewController.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "ViewController.h"

#import "DragView.h"
#import <Masonry/Masonry.h>
#import "AppInfoView.h"


static CGFloat AppWidth  = 48;
static CGFloat AppHeight = 58;
static CGFloat AppGap    = 10;

@interface ViewController() <AppInfoViewProtocol>

@property (nonatomic, strong) DragView * dv;
@property (nonatomic, strong) NSMutableArray * aivArray;
@property (nonatomic, strong) NSMenu * clickMenu;

@property (nonatomic        ) BOOL initFrame;

@end

@implementation ViewController

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"x: %f", self.appInfoEntity.x);
    //self.view.layer.backgroundColor = (__bridge CGColorRef _Nullable)([NSColor whiteColor]);
    // [CGColor whiteColor];
    //self.view.frame = CGRectMake(0, 0, 400, 80);
    self.aivArray = [NSMutableArray new];
    [self addDvs];
    [self addViews];
}

- (void)addDvs {
    self.dv = [DragView new];
    
    [self.view addSubview:self.dv];
    [self.dv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.dv.dragAppBlock = ^(NSArray * array) {
        [weakSelf addPathUrls:array];
        [AppInfoTool updateEntity];
    };
}

- (void)addViews {
    [self showBeforeAppPaths];
    [self addMenus];
}

// MARK: 增加 按钮
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

- (void)addAppPath:(NSString *)path {
    [self.appInfoEntity.appPathArray addObject:[NSString stringWithFormat:@"file://%@/", path]];
    CGFloat maxX = [self addBT:self.appInfoEntity.appPathArray.count - 1];
    
    [self updateFrameMaxX:maxX];
}

- (void)updateFrameMaxX:(CGFloat)maxX {
    CGRect rect = CGRectMake(self.view.window.frame.origin.x,
                             self.view.window.frame.origin.y,
                             maxX,
                             VcHeight);
    
    [self.view.window setFrame:rect display:YES];
    //[self.view.window setLevel:NSFloatingWindowLevel];
}

- (CGFloat)addBT:(NSInteger)index {
    //CGFloat width = AppWidth;
    //CGFloat gap   = AppGap;
    
    AppInfoView * aiv = ({
        NSString * str = self.appInfoEntity.appPathArray[index];
        //str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        AppInfoView * oneAIV = [AppInfoView new];
        oneAIV.delegate     = self;
        oneAIV.appBT.target = self;
        oneAIV.appBT.action = @selector(btAction:);
        
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
    
    aiv.frame = [self aivFrameIndex:index];
    //CGRectMake(AppWidth * index + AppGap*(index + 1), 10, AppWidth, AppHeight);
    aiv.appBT.frame = CGRectMake(0, 10, AppWidth, AppWidth);
    aiv.appPath    = self.appInfoEntity.appPathArray[index];
    aiv.appUrlPath = [aiv.appPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [self.aivArray addObject:aiv];
    return CGRectGetMaxX(aiv.frame) + AppGap;
}

- (CGRect)aivFrameIndex:(NSInteger)index {
    return CGRectMake(AppWidth * index + AppGap*(index + 1), 10, AppWidth, AppHeight);
}

- (void)btAction:(NSButton *)bt {
    //NSURL * url = [NSURL URLWithString:@"file:///Applications/Google%20Chrome.app/"];
    
    NSString * str = self.appInfoEntity.appPathArray[bt.tag];
    if (str.length == 0) {
        //[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:@"file:///Applications/"]]];
        [self addAppAction];
    } else {
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL * url = [NSURL URLWithString:str];
        
        if (url) {
            NSWorkspaceOpenConfiguration * config = [NSWorkspaceOpenConfiguration configuration];
            config.activates = YES;
            [[NSWorkspace sharedWorkspace] openApplicationAtURL:url configuration:config completionHandler:nil];
        }
    }
    // [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]]; // 打开文件夹
}

// MARK: 右键menu
- (void)addMenus {
    if (!self.clickMenu) {
        self.clickMenu = [NSMenu new];
        
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"新增APP" action:@selector(addAppAction) keyEquivalent:@""];
        NSMenuItem *item1_0 = [[NSMenuItem alloc] initWithTitle:@"新增Finder" action:@selector(addFinderAppPath) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"新增Dock" action:@selector(addDockAction) keyEquivalent:@""];
        NSMenuItem *item_0 = [NSMenuItem separatorItem];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"清空Dock" action:@selector(clearDockAction) keyEquivalent:@""];
        NSMenuItem *item4 = [[NSMenuItem alloc] initWithTitle:@"删除Dock" action:@selector(deleteDockAction) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item1_0 setTarget:self];
        [item2 setTarget:self];
        [item3 setTarget:self];
        [item4 setTarget:self];
        
        [self.clickMenu addItem:item1];
        [self.clickMenu addItem:item1_0];
        [self.clickMenu addItem:item2];
        
        [self.clickMenu addItem:item_0];
        
        [self.clickMenu addItem:item3];
        [self.clickMenu addItem:item4];
    }
    self.view.menu = self.clickMenu;
}

- (void)addFinderAppPath {
    [self addPathArray:@[@"/System/Library/CoreServices/Finder.app/"]];
    [AppInfoTool updateEntity];
}

- (void)addDockAction {
    if (self.addDockBlock) {
        self.addDockBlock();
    }
}

- (void)clearDockAction {
    if (self.appInfoEntity.appPathArray.firstObject.length == 0) {
        return;
    }
    
    [self.appInfoEntity.appPathArray removeAllObjects];
    for (AppInfoView * aiv in self.aivArray) {
        [aiv removeFromSuperview];
    }
    [self.aivArray removeAllObjects];
    
    [self.appInfoEntity.appPathArray addObject:@""];
    [self showBeforeAppPaths];
    
    [AppInfoTool updateEntity];
}

- (void)deleteDockAction {
    [[AppInfoTool share].appInfoArrayEntity.windowArray removeObject:self.appInfoEntity];
    [AppInfoTool updateEntity];
    
    [self.view.window close];
}

// MARK: 打开系统文件件事件
- (void)addAppAction {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"app"]];
    
    //[NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
    if ([panel runModal] == NSModalResponseOK) {
        [self addPathUrls:panel.URLs];
        [AppInfoTool updateEntity];
    }
}

- (void)addPathUrls:(NSArray *)array {
    for (int i = 0; i<array.count; i++) {
        if (i == 0) {
            [self removeNilAiv];
        }
        NSString * path = [array[i] path];
        [self addAppPath:path];
    }
    [self checkActiveSelf];
}

- (void)addPathArray:(NSArray *)array {
    for (int i = 0; i<array.count; i++) {
        if (i == 0) {
            [self removeNilAiv];
        }
        NSString * path = array[i];
        [self addAppPath:path];
    }
    [self checkActiveSelf];
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

// MARK: AIV 的 delegate
- (void)exit:(AppInfoView *)appInfoView {
    //[appInfoView.runningApp terminate];
    //NSLog(@"appInfoView.runningApp.processIdentifier: %i", appInfoView.runningApp.processIdentifier);
    //NSApplication * app = [NSRunningApplication runningApplicationWithProcessIdentifier:appInfoView.runningApp.processIdentifier];
    
    // https://stackoverrun.com/cn/q/3714068
    //CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
}

- (void)delete:(AppInfoView *)appInfoView {
    [self.appInfoEntity.appPathArray removeObjectAtIndex:appInfoView.appBT.tag];
    [self.aivArray removeObject:appInfoView];
    
    [appInfoView removeFromSuperview];
    
    for (int index = 0; index< self.aivArray.count; index++) {
        AppInfoView * aiv = self.aivArray[index];
        aiv.appBT.tag = index;
        
        aiv.frame = [self aivFrameIndex:index];
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

// MARK: 检查 APP 运行状态
- (void)checkActive:(NSSet *)appRunningSet dic:(NSMutableDictionary *)dic {
    for (AppInfoView * aiv in self.aivArray) {
        //NSLog(@"aiv.appPath: %@", aiv.appUrlPath);
        if ([appRunningSet containsObject:aiv.appUrlPath]) {
            aiv.runningApp = dic[aiv.appUrlPath];
            aiv.activeIV.hidden = NO;
        } else{
            aiv.activeIV.hidden = YES;
        }
    }
}

// 自己单独检查
- (void)checkActiveSelf {
    NSWorkspace * work = [NSWorkspace sharedWorkspace];
    NSArray<NSRunningApplication *> * appAppArray =[work runningApplications];
    NSMutableSet * appSet = [NSMutableSet new];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    for (NSRunningApplication * oneApp in appAppArray) {
        if (oneApp.activationPolicy == NSApplicationActivationPolicyRegular) {
            [appSet addObject:oneApp.bundleURL.absoluteString];
            [dic setObject:oneApp forKey:oneApp.bundleURL.absoluteString];
        }
    }
    [self checkActive:appSet dic:dic];
}

@end
