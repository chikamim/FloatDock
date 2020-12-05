//
//  AppWindowTool.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppWindowTool.h"
#import "AppInfoEntity.h"

static NSInteger AppSizeWidthMax = 100;
static NSInteger AppSizeWidthMin = 20;

@implementation AppWindowTool

+ (instancetype)share {
    static dispatch_once_t once;
    static AppWindowTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.appInfoTool = [AppInfoTool share];
        AppInfoTool * ait    = [AppInfoTool share];
        
        instance.windowAlphaNum  = [[NSDecimalNumber alloc] initWithInteger:ait.appInfoArrayEntity.windowAlpha == 0 ? 60 : ait.appInfoArrayEntity.windowAlpha];
        
        instance.num1            = [[NSDecimalNumber alloc] initWithFloat:1];
        instance.num5            = [[NSDecimalNumber alloc] initWithFloat:5];
        instance.num100          = [[NSDecimalNumber alloc] initWithFloat:100];
        
        instance.appIconWidthNum = [[NSDecimalNumber alloc] initWithInteger:ait.appInfoArrayEntity.appIconWidth == 0 ? 45:ait.appInfoArrayEntity.appIconWidth];
    });
    return instance;
}

- (void)showBeforeWindows {
    if (self.appInfoTool.appInfoArrayEntity.windowArray.count == 0) {
        AppInfoEntity * entity = [AppInfoEntity new];
        CGSize size = [NSScreen mainScreen].frame.size;
        entity.windowX = size.width/2.0;
        entity.windowY = size.height/2.0;
        [entity.appPathArray addObject:@"file:///System/Library/CoreServices/Finder.app/"];
        
        [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    }
    
    for (int i = 0; i<self.appInfoTool.appInfoArrayEntity.windowArray.count; i++) {
        [self showNewDock:self.appInfoTool.appInfoArrayEntity.windowArray[i]];
    }
}

- (void)createNewDockEvent:(CGPoint)origin {
    // 1. 创建视图控制器，加载xib文件
    // 原文链接：https://blog.csdn.net/fl2011sx/article/details/73252859
    // let sub1ViewController = NSViewController(nibName: "sub1ViewController", bundle: Bundle.main)
    //
    // // 创建窗口，关联控制器
    // let sub1Window = sub1ViewController != nil ? NSWindow(contentViewController: sub1ViewController!) : nil
    //
    // // 初始化窗口控制器
    // sub1WindowController = NSWindowController(window: sub1Window)
    //
    // // 显示窗口
    // sub1WindowController?.showWindow(nil)
    // ————————————————
    
    // 2. 创建一个没有 xib 的 vc 方法.
    // https://stackoverflow.com/questions/34124228/initialize-a-subclass-of-nsviewcontroller-without-a-xib-file
    
    
    AppInfoEntity * entity = [AppInfoEntity new];
    if (CGPointEqualToPoint(origin, CGPointZero)) {
        CGSize size = [NSScreen mainScreen].frame.size;
        origin = CGPointMake(size.width/2, size.height/2);
    }
    entity.windowX = origin.x + 10;
    entity.windowY = origin.y + 10;
    [entity.appPathArray addObject:@"file:///System/Library/CoreServices/Finder.app/"];
    [self.appInfoTool.appInfoArrayEntity.windowArray addObject:entity];
    
    [self showNewDock:entity];
}

- (void)showNewDock:(AppInfoEntity *)appInfoEntity {
    // 设置 wc
    FloatDockVC * vc = [[FloatDockVC alloc] init];
    vc.appInfoEntity = appInfoEntity;
    
    //vc.view.frame = CGRectMake(0, 0, 400, 60);
    FloatWindow * window = [FloatWindow new];
    [window setContentViewController:vc];
    
    [self setWindowStyle:window];
    
    NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
    
    [wc showWindow:nil];
}

- (void)setWindowStyle:(NSWindow *)window {
    {
        // 设置 style
        NSUInteger style;
        //style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
        //[window setStyleMask:style];
        
        //style = NSWindowStyleMaskResizable;
        
        style = NSWindowStyleMaskBorderless;// NSWindowStyleMaskBorderless
        
        [window setStyleMask:style];
    }
    
    //CGRect rect =CGRectMake(window.frame.origin.x, window.frame.origin.y, 400, 60);
    //[window setFrame:rect display:YES];
    
    [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
    window.hasShadow = NO; // 关闭阴影
    
    window.contentView.layer.cornerRadius = 8;
    //[window setOpaque:YES];
    //window.contentView.layer.masksToBounds = YES;
    [window setBackgroundColor:[NSColor clearColor]];// 防止 设置了圆角之后, 显示为黑角.
    
    // 假如没有背景色, 就无法点击了...
    CGColorRef color;
    //color = [[NSColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:208.0/255.0 alpha:0.55] CGColor];
    color = [[NSColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.5] CGColor];
    //color = [[NSColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1] CGColor];
    [window.contentView.layer setBackgroundColor:color];
    
    [window setLevel:NSFloatingWindowLevel];
    window.alphaValue = [self.windowAlphaNum decimalNumberByDividingBy:self.num100].floatValue;
}


- (void)alphaUpEvent {
    if (self.windowAlphaNum.integerValue < 100) {
        self.windowAlphaNum = [self.windowAlphaNum decimalNumberByAdding:self.num5];
        
        [self updateWindowData];
    }
}

- (void)alphaDownEvent {
    if (self.windowAlphaNum.integerValue >= self.num5.integerValue) {
        self.windowAlphaNum = [self.windowAlphaNum decimalNumberBySubtracting:self.num5];
        
        [self updateWindowData];
    }
}

- (void)updateWindowData {
    for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
        NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
        if ([oneWin isMemberOfClass:[FloatWindow class]]) {
            oneWin.alphaValue = [self.windowAlphaNum decimalNumberByDividingBy:self.num100].floatValue;
        }
    }
    [self updateAlphaWindowInfo:[NSString stringWithFormat:@"%i", self.windowAlphaNum.intValue]];
    
    AppInfoTool * ait = [AppInfoTool share];
    ait.appInfoArrayEntity.windowAlpha = self.windowAlphaNum.intValue;
    
    [AppInfoTool updateEntity];
}

- (void)sizeUpEvent {
    if (self.appIconWidthNum.floatValue < AppSizeWidthMax) {
        self.appIconWidthNum = [self.appIconWidthNum decimalNumberByAdding:self.num1];
        [self updateFloatVCAppIconSize];
    }
}

- (void)sizeDownEvent {
    if (self.appIconWidthNum.floatValue > AppSizeWidthMin) {
        self.appIconWidthNum = [self.appIconWidthNum decimalNumberBySubtracting:self.num1];
        [self updateFloatVCAppIconSize];
    }
}

- (void)updateFloatVCAppIconSize {
    for (int i = 0; i<[NSApplication sharedApplication].windows.count; i++) {
        NSWindow * oneWin = [NSApplication sharedApplication].windows[i];
        if ([oneWin isMemberOfClass:[FloatWindow class]]) {
            NSViewController * vc = oneWin.contentViewController;
            if ([vc isKindOfClass:[FloatDockVC class]]) {
                FloatDockVC * fvc = (FloatDockVC *)vc;
                [fvc updateAppIconWidth];
            }
        }
    }
    
    //NSLog(@"self.windowAlpha: %.02f", self.windowAlphaNum.floatValue);
    [self updateAlphaWindowInfo:[NSString stringWithFormat:@"%ipx", self.appIconWidthNum.intValue]];
    
    AppInfoTool * ait = [AppInfoTool share];
    ait.appInfoArrayEntity.appIconWidth = self.appIconWidthNum.intValue;
    
    [AppInfoTool updateEntity];
}

- (void)updateAlphaWindowInfo:(NSString *)text {
    if (!self.alphaWindow) {
        AlphaSetVC * vc = [[AlphaSetVC alloc] init];
        
        NSWindow * window = [NSWindow new];
        [window setContentViewController:vc];
        
        [self setWindowStyle:window];
        [window setMovableByWindowBackground:NO];
        window.alphaValue = 1;
        
        NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
        [wc showWindow:nil];
        
        // frame
        CGFloat width  = 130;
        CGSize size    = [NSScreen mainScreen].frame.size;
        // CGPoint origin = CGPointMake(size.width/2 - width/2, size.height/2 - width/2);
        CGPoint origin = CGPointMake(size.width/2 - width/2, width);
        CGRect rect    = CGRectMake(origin.x, origin.y, width, width);
        
        [window setFrame:rect display:YES];
        
        self.alphaVC     = vc;
        self.alphaWindow = window;
    }
    
    self.alphaWindow.alphaValue = 1;
    
    self.alphaVC.alphaTF.stringValue = text;
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(removeAlphaWindow) withObject:nil afterDelay:2];
}

- (void)removeAlphaWindow {
    self.alphaWindow.alphaValue = 0;
}


- (void)openFavoriteWindows {
    if (!self.favoriteWindow) {
        FavoriteVC * vc = [[FavoriteVC alloc] init];
        
        FavoriteWindow * window = [FavoriteWindow new];
        [window setupWindowForEvents];
        [window setContentViewController:vc];
        
        window.title = NSLS(@"FDFavoriteWindowTitle");//@"收藏";
        window.titlebarAppearsTransparent = NO; // 默认值 NO
        
        [window setLevel:NSFloatingWindowLevel];
        [window setMovableByWindowBackground:YES]; // 整体都可以拖拽
        
        // style 设置 https://www.jianshu.com/p/a8846aac8c1d
        NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
        [window setStyleMask:style];
        
        window.alphaValue = 1;
        
        NSWindowController * wc = [[NSWindowController alloc] initWithWindow:window];
        [wc showWindow:nil];
        
        // frame
        CGFloat width   = 520;
        CGFloat height  = 300;
        CGSize size    = [NSScreen mainScreen].frame.size;
        CGPoint origin = CGPointMake(size.width/2 - width/2, size.height/2 - height/2);
        //CGPoint origin = CGPointMake(size.width/2 - width/2, width);
        CGRect rect    = CGRectMake(origin.x, origin.y, width, height);
        
        [window setFrame:rect display:YES];
        
        self.favoriteVC     = vc;
        self.favoriteWindow = window;
        self.favoriteWC     = wc;
        
        self.favoriteWindow.favoriteVC = self.favoriteVC;
    }
    [self.favoriteWC showWindow:nil];
}

@end
