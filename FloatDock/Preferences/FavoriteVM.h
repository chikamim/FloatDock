//
//  FavoriteVM.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/5/1.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static int FavoriteCellHeight = 32;

@interface FavoriteVM : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak  ) NSTableView * infoTV;
- (void)closeEditHotkeyOuter;
- (void)closeEditHotkeyInner;

@end

NS_ASSUME_NONNULL_END
