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
@property (nonatomic, copy  ) NSString * appName;
@property (nonatomic, copy  ) NSString * appPath;
@property (nonatomic, copy  ) NSString * hotKey;  // 快捷键
@property (nonatomic, weak  ) NSRunningApplication<Ignore> * runningApp;

//---
@property (nonatomic        ) BOOL receive;

@end


@protocol FavoriteAppArrayEntity;
@interface FavoriteAppArrayEntity : JSONModel

@property (nonatomic, strong) NSMutableArray<FavoriteAppEntity> * appArray;

@end

@interface FavoriteAppTool : JSONModel

@property (nonatomic, strong) FavoriteAppArrayEntity * arrayEntity;
+ (instancetype)share;

- (void)addFavoriteAppEntity:(FavoriteAppEntity *)entity;
- (void)removeFavoriteAppEntity:(FavoriteAppEntity *)entity;

+ (void)updateEntity;

@end


NS_ASSUME_NONNULL_END
