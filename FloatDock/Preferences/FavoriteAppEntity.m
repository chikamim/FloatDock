//
//  FavoriteAppEntity.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteAppEntity.h"

@implementation FavoriteAppEntity

// 允许参数为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


- (NSImage *)imageFavorite {
    if (!_imageFavorite && _path.length > 7) {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSImage *finderIcon;
        //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
        finderIcon = [workspace iconForFile:[_path substringFromIndex:7]];
        [finderIcon setSize:NSMakeSize(ImageStatusBarWidth, ImageStatusBarWidth)];
        
        _imageFavorite = finderIcon;
    }
    return _imageFavorite;
}

- (NSImage *)imageMenu {
    if (!_imageMenu && _path.length > 7) {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSImage *finderIcon;
        //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
        finderIcon = [workspace iconForFile:[_path substringFromIndex:7]];
        [finderIcon setSize:NSMakeSize(ImageStatusBarWidth, ImageStatusBarWidth)];
        
        _imageMenu = finderIcon;
    }
    return _imageMenu;
}

- (NSImage *)imageStatusBar {
    if (!_imageStatusBar && _path.length > 7) {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSImage *finderIcon;
        //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
        finderIcon = [workspace iconForFile:[_path substringFromIndex:7]];
        [finderIcon setSize:NSMakeSize(ImageStatusBarWidth, ImageStatusBarWidth)];
        
        _imageStatusBar = finderIcon;
    }
    return _imageStatusBar;
}

@end

@implementation FavoriteAppArrayEntity

- (id)init {
    if (self = [super init]) {
        _array = [NSMutableArray<FavoriteAppEntity> new];
    }
    return self;
}

// 允许参数为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
