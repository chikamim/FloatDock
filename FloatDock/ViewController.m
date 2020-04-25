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

@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic, strong) DragView * dv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.layer.backgroundColor = (__bridge CGColorRef _Nullable)([NSColor whiteColor]);
    // [CGColor whiteColor];
    //self.view.frame = CGRectMake(0, 0, 400, 80);
    
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
        [weakSelf.urlArray addObject:[NSString stringWithFormat:@"file://%@/", string]];
        [weakSelf addBT:weakSelf.urlArray.count - 1];
    };
}

- (void)addViews {
    self.urlArray = [@[
        @"file:///System/Library/CoreServices/Finder.app/",
        @"file:///Applications/Google Chrome.app",
        @"file:///Applications/Xcode.app/",
        //@"file:///Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/",
        @"file:///Applications/iTerm.app/",
    ] mutableCopy];
    
  
    for (NSInteger i = 0; i<self.urlArray.count; i++) {
        [self addBT:i];
    }
}

- (void)addBT:(NSInteger)index {
    CGFloat width = 50;
    CGFloat gap   = 10;
    
    NSButton * bt = ({
        //NSButton * button = //[[NSButton alloc] init];
        //[NSButton buttonWithTitle:titleArray[i] target:self action:@selector(btAction:)];'
        NSString * str = self.urlArray[index];
        //str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSButton * button = [NSButton new];
        //button = [NSButton buttonWithTitle:titleArray[i] target:self action:@selector(btAction:)];
        //button = [NSButton buttonWithImage:image target:self action:@selector(btAction:)];
        button.target = self;
        button.action = @selector(btAction:);
        {
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
    
    bt.frame = CGRectMake(width * index + gap*(index + 1), 5, width, width);
}

- (void)btAction:(NSButton *)bt {
    //NSURL * url = [NSURL URLWithString:@"file:///Applications/Google%20Chrome.app/"];
    
    NSString * str = self.urlArray[bt.tag];
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
    // [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]]; // 打开文件夹
    
    [self addW];
}

- (void)mouseEntered:(NSEvent *)event {
    self.view.window.alphaValue = 1.0;
    NSLog(@"entered");
}

- (void)mouseExited:(NSEvent *)event {
    self.view.window.alphaValue = 0.5;
}

- (void)addW {
    //NSWindow * win = [[NSWindow alloc] init];
    
    
    //[win ]
}

// MARK: 注册 drag drop
- (void)registerDragDrop {
    //self.view.registeredDraggedTypes = @[NSPasteboardTypeFileURL];
    [self.view registerForDraggedTypes:@[NSPasteboardTypeFileURL]];
    
}

@end
