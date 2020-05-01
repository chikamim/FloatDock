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
