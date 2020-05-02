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
@property (nonatomic, strong) NSImage<Ignore> * image;
@property (nonatomic, copy  , nullable) NSString * hotKey;  // 快捷键
@property (nonatomic, weak  ) NSRunningApplication<Ignore> * runningApp;

//---
@property (nonatomic        ) BOOL receive;

@end


@protocol FavoriteAppArrayEntity;
@interface FavoriteAppArrayEntity : JSONModel

@property (nonatomic, strong) NSMutableArray<FavoriteAppEntity> * array;

@end

NS_ASSUME_NONNULL_END
