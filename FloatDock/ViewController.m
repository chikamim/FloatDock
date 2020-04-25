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

@interface ViewController()

//@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic, strong) DragView * dv;
@property (nonatomic, strong) NSMutableArray * btArray;
@end

@implementation ViewController

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

// MARK: 增加 按钮
- (void)showBeforeAppPaths {
    CGFloat maxX = 70;
    for (NSInteger i = 0; i<self.appInfoEntity.appPathArray.count; i++) {
        maxX =[self addBT:i];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect = CGRectMake(self.view.window.frame.origin.x,
                                 self.view.window.frame.origin.y,
                                 maxX,
                                 VcHeight);
        [self.view.window setFrame:rect display:YES];
        
        [self.view.window setLevel:NSFloatingWindowLevel];
    });
}

- (void)addAppPath:(NSString *)path {
    [self.appInfoEntity.appPathArray addObject:[NSString stringWithFormat:@"file://%@/", path]];
    CGFloat maxX = [self addBT:self.appInfoEntity.appPathArray.count - 1];
    
    CGRect rect = CGRectMake(self.view.window.frame.origin.x,
                             self.view.window.frame.origin.y,
                             maxX,
                             VcHeight);
    
    [self.view.window setFrame:rect display:YES];
    [self.view.window setLevel:NSFloatingWindowLevel];
}

- (CGFloat)addBT:(NSInteger)index {
    CGFloat width = 50;
    CGFloat gap   = 10;
    
    NSButton * bt = ({
        NSString * str = self.appInfoEntity.appPathArray[index];
        //str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSButton * button = [NSButton new];
        button.target = self;
        button.action = @selector(btAction:);
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
    
    [NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
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


@end
