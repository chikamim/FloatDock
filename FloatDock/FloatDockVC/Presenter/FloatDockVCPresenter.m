//
//  FloatDockVCPresenter.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import "FloatDockVCPresenter.h"
#import "FloatDockVCInteractor.h"
#import "AppWindowTool.h"

static CGFloat AppWidth  = 48;
static CGFloat AppHeight = 58;

@interface FloatDockVCPresenter ()

@property (nonatomic, weak  ) id<FloatDockVCProtocol> view;
@property (nonatomic, strong) FloatDockVCInteractor * interactor;

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
        [finderIcon setSize:NSMakeSize(AppWidth, AppWidth)];
        
        [item.appBT setImage:finderIcon];
        
        //self.view.appActiveDic;
        
        NSRunningApplication * runningApp = self.view.appActiveDic[str];
        item.activeIV.hidden = !runningApp;
        
    }
    
    
    
    return item;
}


#pragma mark - VC_EventHandler

#pragma mark - Interactor_EventHandler

@end
