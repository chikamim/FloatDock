//
//  FloatDockVC.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import "FloatDockVC.h"
#import "FloatDockVCPresenter.h"
#import "FloatDockVCInteractor.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "AcceptDragFileView.h"
#import "AppInfoView.h"
#import "AppWindowTool.h"

static CGFloat DockInfoCVLeftRight = 15;

@interface FloatDockVC ()

@property (nonatomic, strong) FloatDockVCPresenter * present;

@property (nonatomic, strong) AcceptDragFileView * dragView;

@property (nonatomic, strong) NSMenu * clickMenu;
@property (nonatomic, strong) NSMenu * addFavoriteMenu;
@property (nonatomic, strong) NSMenu * openFavoriteMenu;

@end

@implementation FloatDockVC
@synthesize appInfoEntity;
@synthesize infoCvSV;
@synthesize infoCV;
@synthesize infoCvLayout;
@synthesize awt;
@synthesize hkt;
@synthesize appActiveDic;


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"FloatDockVC";
    }
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

#pragma mark - VCProtocol
- (NSViewController *)vc {
    return self;
}

- (void)updateAppIconWidth {
    [self updateAppIconSize];
    [self updateWindowFrame];
    
}

- (void)updateAppIconSize {
    CGFloat height = self.awt.appIconWidthNum.floatValue +self.windowHeight;
    [self.view.window setFrame:CGRectMake(self.view.window.frame.origin.x, self.view.window.frame.origin.y, self.view.window.frame.size.width, height) display:YES];
    
    [self.infoCvSV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.awt.appIconWidthNum.floatValue);
    }];
}

- (void)updateWindowFrame {
    NSInteger count = MAX(self.appInfoEntity.appPathArray.count, 1);
    CGFloat width   = DockInfoCVLeftRight*2 + self.awt.appIconWidthNum.floatValue *count + 10*(count-1);
    CGFloat height  = self.awt.appIconWidthNum.floatValue +self.windowHeight;
    
    [self.view.window setFrame:CGRectMake(self.appInfoEntity.windowX, self.appInfoEntity.windowY, width, height) display:YES];
    
    self.infoCvLayout.itemSize = CGSizeMake(self.awt.appIconWidthNum.floatValue, self.awt.appIconWidthNum.floatValue);
    
    [self.infoCV reloadData];
}

- (CGFloat)windowHeight {
    CGFloat height = 0.4* self.awt.appIconWidthNum.floatValue;
    height = MAX(height, 12);
    height = MIN(height, 30);
    return height;
}

#pragma mark - viper views
- (void)assembleViper {
    if (!self.present) {
        FloatDockVCPresenter * present = [FloatDockVCPresenter new];
        FloatDockVCInteractor * interactor = [FloatDockVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    
    self.awt = [AppWindowTool share];
    self.hkt = [HotKeyTool share];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view.window setFrame:CGRectMake(self.appInfoEntity.windowX, self.appInfoEntity.windowY, 0, 0) display:YES];
        [self updateWindowFrame];
    });
    
    [self addDvs];
    self.infoCV = [self addCV];
    
    //[self.view setWantsLayer:YES];
    //[self.view.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
    
    [self addMenus];
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------

- (void)addDvs {
    self.dragView = [AcceptDragFileView new];
    
    [self.view addSubview:self.dragView];
    [self.dragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    @weakify(self);
    self.dragView.dragAppBlock = ^(NSArray * array) {
        @strongify(self);
        
        for (int i = 0; i<array.count; i++) {
            NSString * path = [array[i] path];
            path = [NSString stringWithFormat:@"file://%@/", path];
            
            [self.appInfoEntity.appPathArray addObject:path];
        }
        
        [self updateWindowFrame];
        [AppInfoTool updateEntity];
    };
}

// MARK: 检查 APP 运行状态
- (void)checkDockAppActive:(NSMutableDictionary *)dic {
    //[self.appInfoViewVM checkDockAppActive:dic];
    self.appActiveDic = dic;
    
    [self.infoCV reloadData];
}

- (NSCollectionView *)addCV {
    
    self.infoCvLayout = ({
        NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(self.awt.appIconWidthNum.floatValue, self.awt.appIconWidthNum.floatValue);
        
        layout;
    });
    
    CGRect rect = CGRectZero;
    NSCollectionView *collectionView = [[NSCollectionView alloc] initWithFrame:rect];
    collectionView.collectionViewLayout = self.infoCvLayout;
    
    collectionView.dataSource = self.present;
    collectionView.delegate   = self.present;
    
    [collectionView registerClass:[AppIconItem class] forItemWithIdentifier:AppIconItemKey];
    
    NSClipView *clip = [[NSClipView alloc] initWithFrame:rect];
    clip.documentView = collectionView;
    
    self.infoCvSV = ({
        NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:CGRectZero];
        scrollView.contentView = clip;
        [self.dragView addSubview:scrollView];
        
        scrollView;
    });
    
    [self.infoCvSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DockInfoCVLeftRight);
        make.right.mas_equalTo(-DockInfoCVLeftRight);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.awt.appIconWidthNum.floatValue);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    {   // 此为保证小白点显示出来第二步
        self.infoCvSV.wantsLayer = YES;
        self.infoCvSV.backgroundColor   = [NSColor clearColor];
        self.infoCvSV.layer.masksToBounds = NO;
        
        collectionView.wantsLayer = YES;
        collectionView.backgroundColors = @[[NSColor clearColor]];
        collectionView.layer.masksToBounds = NO;
        
        clip.wantsLayer = YES;
        clip.backgroundColor = [NSColor clearColor];
        clip.layer.masksToBounds = NO;
    
    }
    // 需要延迟处理 滑动条, 不然边缘的滑动条会影响拖拽动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.infoCvSV.verticalScroller.hidden = YES;
        self.infoCvSV.horizontalScroller.hidden = YES;
    });
    
    return collectionView;
}

#pragma mark - menu
- (void)addMenus {
    if (!self.addFavoriteMenu) {
        NSMenu * menu = [NSMenu new];
        self.addFavoriteMenu = menu;
    }
    if (!self.openFavoriteMenu) {
        NSMenu * menu = [NSMenu new];
        self.openFavoriteMenu = menu;
    }
    if (!self.clickMenu) {
        NSMenu * menu = [NSMenu new];
        NSMenuItem *line_0  = [NSMenuItem separatorItem];
        NSMenuItem *line_1  = [NSMenuItem separatorItem];
        NSMenuItem *line_2  = [NSMenuItem separatorItem];
        
        NSMenuItem *itemAddApp      = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddApp")             action:@selector(addAppAction) keyEquivalent:@""];
        NSMenuItem *itemAddFinder   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddFinder")          action:@selector(addFinderAppPath) keyEquivalent:@""];
        NSMenuItem *itemAddFromFav  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddAppFromFavorite") action:nil keyEquivalent:@""];
        itemAddFromFav.submenu      = self.addFavoriteMenu;
        NSMenuItem *itemOpenFromFav = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_OpenAppFromFavorite") action:nil keyEquivalent:@""];
        itemOpenFromFav.submenu     = self.openFavoriteMenu;

        NSMenuItem *itemAddDock     = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_AddDock")            action:@selector(addDockAction) keyEquivalent:@""];

        NSMenuItem *itemOpenFav     = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_FavoriteWindow")     action:@selector(openFavoriteWindow) keyEquivalent:@""];
        NSMenuItem *itemClearDock   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_ClearDock")          action:@selector(clearDockAppAction) keyEquivalent:@""];
        NSMenuItem *itemDeleteDock  = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DeleteDock")         action:@selector(deleteDockAction) keyEquivalent:@""];

        NSMenuItem *itemUpAlpha     = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_UpAlpha")            action:@selector(alphaUpEvent) keyEquivalent:@""];
        NSMenuItem *itemDownAlpha   = [[NSMenuItem alloc] initWithTitle:NSLS(@"FD_DownAlpha")          action:@selector(alphaDownEvent) keyEquivalent:@""];
        
        itemAddApp.target     = self;
        itemAddFinder.target  = self;
        itemAddDock.target    = self;
        itemOpenFav.target    = self;
        itemClearDock.target  = self;
        itemDeleteDock.target = self;
        
        itemUpAlpha.target    = self.awt;
        itemDownAlpha.target  = self.awt;
        
        // ------- menu排序
        [menu addItem:itemOpenFromFav];
        [menu addItem:line_0];
        
        [menu addItem:itemAddFromFav];
        
        [menu addItem:itemAddApp];
        [menu addItem:itemAddFinder];
        [menu addItem:itemAddDock];
        
        [menu addItem:line_1];
        
        [menu addItem:itemOpenFav];
        [menu addItem:itemClearDock];
        [menu addItem:itemDeleteDock];
        
        [menu addItem:line_2];
        [menu addItem:itemUpAlpha];
        [menu addItem:itemDownAlpha];
        
        self.clickMenu = menu;
    }
    self.view.menu = self.clickMenu;
    
    [self racObserveEvent];
}

- (void)racObserveEvent {
    @weakify(self);
    [[RACObserve(self.hkt, favoriteAppsSigleArray) throttle:0.5] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self updateFavoriteMenuEvent];
    }];
}

- (void)updateFavoriteMenuEvent {
    [self.addFavoriteMenu removeAllItems];
    [self.openFavoriteMenu removeAllItems];
    for (NSInteger i = 0; i < self.hkt.favoriteAppsSigleArray.count; i++) {
        FavoriteAppEntity * app = self.hkt.favoriteAppsSigleArray[i];
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:app.name action:@selector(addAppFromFavority:) keyEquivalent:@""];
            item.tag = i;
            item.target = self;
            if (!app.imageMenu && app.path.length > 7) {
                NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
                NSImage *finderIcon;
                //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
                finderIcon = [workspace iconForFile:[app.path substringFromIndex:7]];
                [finderIcon setSize:NSMakeSize(18, 18)];
                
                app.imageMenu = finderIcon;
            }
            item.image = app.imageMenu;
            //NSData *imageData = [app.smallImage TIFFRepresentation];
            [self.addFavoriteMenu addItem:item];
        }
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:app.name action:@selector(openAppFromFavority:) keyEquivalent:@""];
            item.tag = i;
            item.target = self;
            item.image = app.imageMenu;
            [self.openFavoriteMenu addItem:item];
        }
    }
    
}

// MARK: 右键menu
- (void)addFinderAppPath {
    [self.present addAppUrlArray:@[[NSURL URLWithString:AppInfoUrl_Finder]]];
    [self updateWindowFrame];
}

- (void)addDockAction {
    [[AppWindowTool share] createNewDockEvent:self.view.window.frame.origin];
}

- (void)clearDockAppAction {
    [self.appInfoEntity.appPathArray removeAllObjects];
    [AppInfoTool updateEntity];
    [self updateWindowFrame];
}

- (void)deleteDockAction {
    [[AppInfoTool share].appInfoArrayEntity.windowArray removeObject:self.appInfoEntity];
    [AppInfoTool updateEntity];
    
    [self.view.window close];
}

- (void)addAppPathArray:(NSArray *)array { }

- (void)openFavoriteWindow {
    AppWindowTool * tool = [AppWindowTool share];
    [tool openFavoriteWindows];
}

// MARK: 打开系统文件件事件
- (void)addAppAction {
    [self.present addAppWithPanel];
}

- (void)addAppFromFavority:(NSMenuItem *)item {
    FavoriteAppEntity * app = self.hkt.favoriteAppsSigleArray[item.tag];
    NSString * url = [app.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.present addAppUrlArray:@[[NSURL URLWithString:url]]];
    [self updateWindowFrame];
}

- (void)openAppFromFavority:(NSMenuItem *)item {
    FavoriteAppEntity * app = self.hkt.favoriteAppsSigleArray[item.tag];
    [self.hkt openAppWindows:app.path];
}


@end
