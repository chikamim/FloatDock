//
//  FavoriteAppEntity.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FavoriteAppEntity;
@interface FavoriteAppEntity : JSONModel

//@property (nonatomic        ) NSInteger  index;
@property (nonatomic, copy  ) NSString * name;
@property (nonatomic, copy  ) NSString * path;
@property (nonatomic, strong) NSImage<Ignore> * imageFavorite;// 收藏页面用的图片
@property (nonatomic, strong) NSImage<Ignore> * imageMenu;    // menu中用的图片
@property (nonatomic, copy  , nullable) NSString * hotKey;    // 快捷键可视化
//@property (nonatomic, copy  , nullable) NSString * hotKeyCode;// 快捷键Code, 就不做这个优化了, 发现效果不理想, 而且维护成本上升很多
@property (nonatomic, weak  ) NSRunningApplication<Ignore> * runningApp;

//---
@property (nonatomic        ) BOOL enable;

@end


@protocol FavoriteAppArrayEntity;
@interface FavoriteAppArrayEntity : JSONModel

@property (nonatomic, strong) NSMutableArray<FavoriteAppEntity> * array;

@end

NS_ASSUME_NONNULL_END
