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
//#import "AppInfoBT.h"
#import "AppInfoMenuBT.h"

static CGFloat AppWidth = 50;
static CGFloat AppGap   = 10;

@interface ViewController() <AppInfoMenuBTProtocol>

@property (nonatomic, strong) DragView * dv;
@property (nonatomic, strong) NSMutableArray * btArray;
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
    
    NSLog(@"x: %f", self.appInfoEntity.x);
    //self.view.layer.backgroundColor = (__bridge CGColorRef _Nullable)([NSColor whiteColor]);
    // [CGColor whiteColor];
    //self.view.frame = CGRectMake(0, 0, 400, 80);
    self.btArray = [NSMutableArray new];
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
    self.dv.dragAppBlock = ^(NSString * _Nonnull string) {
        [weakSelf addAppPath:string];
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
    CGFloat width = AppWidth;
    CGFloat gap   = AppGap;
    
    AppInfoMenuBT * bt = ({
        NSString * str = self.appInfoEntity.appPathArray[index];
        //str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        AppInfoMenuBT * button = [AppInfoMenuBT new];
        button.target   = self;
        button.action   = @selector(btAction:);
        button.delegate = self;
        
        if (str.length == 0) {
            [button setImage:[NSImage imageNamed:@"icon"]];
            
        } else {
            // http://hk.uwenku.com/question/p-vrwwdiql-bnz.html
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            NSImage *finderIcon;
            //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
            finderIcon = [workspace iconForFile:[str substringFromIndex:7]];
            [finderIcon setSize:NSMakeSize(width, width)];
            
            [button setImage:finderIcon];
        }
        
        // 设置 button 背景色 边界.
        [[button cell] setBackgroundColor:[NSColor clearColor]];
        button.bordered = NO;
        
        button.tag = index;
        
        [self.view addSubview:button];
        
        button;
    });
    
    bt.frame = CGRectMake(width * index + gap*(index + 1), 15, width, width);
    
    [self.btArray addObject:bt];
    return CGRectGetMaxX(bt.frame) + gap;
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
        
        //NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", str, @"Icon?"]];
        //NSImage * image = [NSImage imageNamed:@""];
        //NSImage * image;
        //image = [[NSImage alloc]initWithContentsOfURL:imageUrl];
        //image = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
        //image = [NSImage imageNamed:str];
        //image = [[NSWorkspace sharedWorkspace] iconForFile:str];
        //NSLog(@"image: %@", NSStringFromSize(image.size));
        
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
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"新增Dock" action:@selector(addDockAction) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"清空" action:@selector(clearDockAction) keyEquivalent:@""];
        NSMenuItem *item4 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteDockAction) keyEquivalent:@""];
        
        [item1 setTarget:self];
        [item2 setTarget:self];
        [item3 setTarget:self];
        [item4 setTarget:self];
        
        [self.clickMenu addItem:item1];
        [self.clickMenu addItem:item2];
        [self.clickMenu addItem:item3];
        [self.clickMenu addItem:item4];
    }
    self.view.menu = self.clickMenu;
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
    for (NSButton * bt in self.btArray) {
        [bt removeFromSuperview];
    }
    [self.btArray removeAllObjects];
    
    [self.appInfoEntity.appPathArray addObject:@""];
    [self showBeforeAppPaths];
    
    [AppInfoTool updateEntity];
}

- (void)deleteDockAction {
    [[AppInfoTool share].appInfoArrayEntity.windowArray removeObject:self.appInfoEntity];
    [AppInfoTool updateEntity];
    
    [self.view.window close];
}

- (void)mouseEntered:(NSEvent *)event {
    self.view.window.alphaValue = 1.0;
    NSLog(@"entered");
}

- (void)mouseExited:(NSEvent *)event {
    self.view.window.alphaValue = 0.5;
}

- (void)addAppAction {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"app"]];
    
    //[NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
    if ([panel runModal] == NSModalResponseOK) {
        for (int i = 0; i<panel.URLs.count; i++) {
            NSString * path   = [panel.URLs[i] path];
            
            if (i == 0) {
                if (self.appInfoEntity.appPathArray.firstObject.length == 0) {
                    [self.appInfoEntity.appPathArray removeAllObjects];
                    NSButton * bt = self.btArray.firstObject;
                    
                    [bt removeFromSuperview];
                }
            }
            
            [self addAppPath:path];
        }
        [AppInfoTool updateEntity];
    }
   
}

// MARK: delegate
- (void)delete:(NSButton *)appInfoMenuBT {
    [self.appInfoEntity.appPathArray removeObjectAtIndex:appInfoMenuBT.tag];
    [self.btArray removeObject:appInfoMenuBT];
    
    [appInfoMenuBT removeFromSuperview];
    
    for (int index = 0; index< self.btArray.count; index++) {
        NSButton * bt = self.btArray[index];
        bt.tag = index;
        
        bt.frame = CGRectMake(AppWidth * index + AppGap*(index + 1), 15, AppWidth, AppWidth);
    }
    
    if (self.appInfoEntity.appPathArray.count == 0) {
        [self.appInfoEntity.appPathArray addObject:@""];
        
        [self showBeforeAppPaths]; // 包含了 刷新 frame
    } else {
        NSButton * bt = (NSButton *)[self.btArray lastObject];
        CGFloat maxX = CGRectGetMaxX(bt.frame) + AppGap;
        
        [self updateFrameMaxX:maxX];
    }
    
    [AppInfoTool updateEntity];
}

- (void)moveLeft:(NSButton *)appInfoMenuBT  {
    if (appInfoMenuBT.tag == 0) {
        return;
    } else {
        NSInteger exchangeTag = appInfoMenuBT.tag-1;
        NSButton * changeBT = self.btArray[exchangeTag];
        
        [self.appInfoEntity.appPathArray exchangeObjectAtIndex:appInfoMenuBT.tag withObjectAtIndex:exchangeTag];
        [self.btArray exchangeObjectAtIndex:appInfoMenuBT.tag withObjectAtIndex:exchangeTag];
        
        CGRect rect         = changeBT.frame;
        changeBT.frame      = appInfoMenuBT.frame;
        appInfoMenuBT.frame = rect;
        
        NSInteger tag       = changeBT.tag;
        changeBT.tag        = appInfoMenuBT.tag;
        appInfoMenuBT.tag   = tag;
        
        [AppInfoTool updateEntity];
    }
}

- (void)moveRight:(NSButton *)appInfoMenuBT {
    if (appInfoMenuBT.tag >= self.appInfoEntity.appPathArray.count - 1) {
        return;
    } else {
        NSInteger exchangeTag = appInfoMenuBT.tag+1;
        NSButton * changeBT = self.btArray[exchangeTag];
        
        [self.appInfoEntity.appPathArray exchangeObjectAtIndex:appInfoMenuBT.tag withObjectAtIndex:exchangeTag];
        [self.btArray exchangeObjectAtIndex:appInfoMenuBT.tag withObjectAtIndex:exchangeTag];
        
        CGRect rect         = changeBT.frame;
        changeBT.frame      = appInfoMenuBT.frame;
        appInfoMenuBT.frame = rect;
        
        NSInteger tag       = changeBT.tag;
        changeBT.tag        = appInfoMenuBT.tag;
        appInfoMenuBT.tag   = tag;
        
        [AppInfoTool updateEntity];
    }
}

- (void)checkActive:(NSArray *)appRunningArray {
    
    
}

@end
