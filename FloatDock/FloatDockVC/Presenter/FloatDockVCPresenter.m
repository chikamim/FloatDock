//
//  FloatDockVCPresenter.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import "FloatDockVCPresenter.h"
#import "FloatDockVCInteractor.h"
#import "AppWindowTool.h"
#import "HotKeyTool.h"

@interface FloatDockVCPresenter () <AppIconItemProtocol>

@property (nonatomic, weak  ) id<FloatDockVCProtocol> view;
@property (nonatomic, strong) FloatDockVCInteractor * interactor;
@property (nonatomic, weak  ) HotKeyTool * hkt;

@end

@implementation FloatDockVCPresenter

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setMyInteractor:(FloatDockVCInteractor *)interactor {
    self.interactor = interactor;
    
}

- (void)setMyView:(id<FloatDockVCProtocol>)view {
    self.view = view;
    
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    self.hkt = [HotKeyTool share];
    
}

#pragma mark - VC_DataSource
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.view.appInfoEntity;
    return self.view.appInfoEntity.appPathArray.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    AppIconItem *item = [collectionView makeItemWithIdentifier:AppIconItemKey forIndexPath:indexPath];
    //item.textLabel.stringValue = [NSString stringWithFormat:@"第%zi个", indexPath.item];
    
    NSString * str = self.view.appInfoEntity.appPathArray[indexPath.item];
    // NSLog(@"str: %@", str);
    if (str.length == 0) {
        [item.appBT setImage:[NSImage imageNamed:@"icon48"]];
        
    } else {
        // http://hk.uwenku.com/question/p-vrwwdiql-bnz.html
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSImage *finderIcon;
        //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
        finderIcon = [workspace iconForFile:[str substringFromIndex:7]];
        //[finderIcon setSize:NSMakeSize(AppWidth, AppWidth)];
        [finderIcon setSize:NSMakeSize(self.view.awt.appIconWidthNum.floatValue, self.view.awt.appIconWidthNum.floatValue)];
        
        [item.appBT setImage:finderIcon];
        
        //self.view.appActiveDic;
        
        NSRunningApplication * runningApp = self.view.appActiveDic[str];
        item.activeIV.hidden = !runningApp;
        
        item.runningApp = runningApp;
    }
    
    item.appPath  = str;
    item.row      = indexPath.item;
    item.delegate = self;
    
    return item;
}

#pragma mark - AppIconItemProtocol
- (void)open:(AppIconItem *)appIconItem {
    //[AppIconItem.runningApp terminate];
    //NSLog(@"AppIconItem.runningApp.processIdentifier: %i", AppIconItem.runningApp.processIdentifier);
    //NSApplication * app = [NSRunningApplication runningApplicationWithProcessIdentifier:AppIconItem.runningApp.processIdentifier];
    
    // https://stackoverrun.com/cn/q/3714068
    //CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
    
    //    // 无效的代码, 不知为何.
    //    if (AppIconItem.runningApp) {
    //        [AppIconItem.runningApp forceTerminate];
    //    }
    
    [self.hkt openAppWindows:appIconItem.appPath];
}

- (void)delete:(AppIconItem *)appIconItem {
    [self.view.appInfoEntity.appPathArray removeObjectAtIndex:appIconItem.row];
    [self.view updateWindowFrame]; //[self.view.infoCV reloadData];
    
    [AppInfoTool updateEntity];
}

- (void)moveLeft:(AppIconItem *)appIconItem  {
    if (appIconItem.row > 0) {
        [self.view.appInfoEntity.appPathArray exchangeObjectAtIndex:appIconItem.row withObjectAtIndex:appIconItem.row -1];
        
        [self.view.infoCV reloadData];
        [AppInfoTool updateEntity];
    }
}

- (void)moveRight:(AppIconItem *)appIconItem {
    if (appIconItem.row +1 < self.view.appInfoEntity.appPathArray.count) {
        [self.view.appInfoEntity.appPathArray exchangeObjectAtIndex:appIconItem.row withObjectAtIndex:appIconItem.row +1];
        
        [self.view.infoCV reloadData];
        [AppInfoTool updateEntity];
    }
}

//- (void)getPid:(AppIconItem *)appIconItem {
//    //NSLog(@"AppIconItem.runningApp.processIdentifier: %i", AppIconItem.runningApp.processIdentifier);
//    NSString * pid = [NSString stringWithFormat:@"%i", appIconItem.runningApp.processIdentifier];
//
//    NSPasteboard * pb = [NSPasteboard generalPasteboard];
//    [pb clearContents];
//    [pb setString:pid forType:NSPasteboardTypeString];
//}

- (void)favorite:(AppIconItem *)appIconItem {
    FavoriteAppEntity * entity = [FavoriteAppEntity new];
    entity.path = appIconItem.appPath;
    entity.name = entity.path.lastPathComponent;
    entity.name = entity.name.stringByDeletingPathExtension;
    
    [[HotKeyTool share] racAddFavoriteAppEntity:entity];
    //self.favoriteAppTool.arrayEntity
    //[[FavoriteAppTool share].arrayEntity.appArray addObject:entity];
}

- (void)lldbFront:(AppIconItem *)appIconItem {
    NSString * lldb =
    [NSString stringWithFormat:@"\
     process attach --pid %i \n\
     e NSApplication $app = [NSApplication sharedApplication];\n\
     e NSWindow $win = $app.windows[0];\n\
     e [$win setLevel: 3];\n\
     exit \n\
     y \n", appIconItem.runningApp.processIdentifier];
    
    lldb = [lldb stringByReplacingOccurrencesOfString:@"     " withString:@""];
    
    NSPasteboard * pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:lldb forType:NSPasteboardTypeString];
}

- (void)lldbNormal:(AppIconItem *)appIconItem {
    NSString * lldb =
    [NSString stringWithFormat:@"\
     process attach --pid %i \n\
     e NSApplication $app = [NSApplication sharedApplication];\n\
     e NSWindow $win = $app.windows[0];\n\
     e [$win setLevel: 0];\n\
     exit \n\
     y \n", appIconItem.runningApp.processIdentifier];
    
    lldb = [lldb stringByReplacingOccurrencesOfString:@"     " withString:@""];
    
    NSPasteboard * pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb setString:lldb forType:NSPasteboardTypeString];
}



#pragma mark - VC_EventHandler

#pragma mark - Interactor_EventHandler

@end
