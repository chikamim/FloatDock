//
//  AppInfoEntity.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * AppInfoUrl_Finder = @"file:///System/Library/CoreServices/Finder.app";

@protocol AppInfoEntity;
@interface AppInfoEntity : JSONModel

@property (nonatomic        ) CGFloat x;
@property (nonatomic        ) CGFloat y;

@property (nonatomic, strong) NSMutableArray<NSString *> * appPathArray;

@end

@protocol AppInfoArrayEntity;
@interface AppInfoArrayEntity : JSONModel

@property (nonatomic        ) CGFloat   windowAlpha;
@property (nonatomic        ) NSInteger appIconWidth;

@property (nonatomic, strong) NSMutableArray<AppInfoEntity> * windowArray;

@end

@interface AppInfoTool : NSObject

@property (nonatomic, strong) AppInfoArrayEntity * appInfoArrayEntity;

+ (instancetype)share;

+ (AppInfoArrayEntity *)getAppInfoArrayEntity;

+ (void)updateEntity;

//+ (void)saveAppInfoArrayEntity:(AppInfoArrayEntity *)entity;

@end

NS_ASSUME_NONNULL_END
