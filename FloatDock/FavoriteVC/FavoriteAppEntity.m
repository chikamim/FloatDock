//
//  FavoriteAppEntity.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteAppEntity.h"
#import "DataSavePath.h"

static NSString * FavoriteDBPath = @"favority";

@implementation FavoriteAppEntity

// 允许参数为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation FavoriteAppArrayEntity

- (id)init {
    if (self = [super init]) {
        _appArray = [NSMutableArray<FavoriteAppEntity> new];
    }
    return self;
}

// 允许参数为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation FavoriteAppTool

+ (instancetype)share {
    static dispatch_once_t once;
    static FavoriteAppTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.arrayEntity = [FavoriteAppTool getFavoriteAppArrayEntity];
    });
    return instance;
}


+ (FavoriteAppArrayEntity *)getFavoriteAppArrayEntity {
    //DataSavePath * path = [DataSavePath share];
    //NSData * data = [NSData dataWithContentsOfFile:path.DBPath];
    NSString * txt = [NSString stringWithContentsOfFile:[self savePath] encoding:NSUTF8StringEncoding error:nil];
    if (txt) {
        //NSString * txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //AppInfoArrayEntity * entity = [[AppInfoArrayEntity alloc] initWithData:data error:nil];
        FavoriteAppArrayEntity * entity = [[FavoriteAppArrayEntity alloc] initWithString:txt error:nil];
        if (entity) {
            return entity;
        } else {
            return [FavoriteAppArrayEntity new];
        }
    } else {
        return [FavoriteAppArrayEntity new];
    }
}

+ (void)updateEntity {
    [self saveAppInfoArrayEntity:[FavoriteAppTool share].arrayEntity];
}

+ (void)saveAppInfoArrayEntity:(FavoriteAppArrayEntity *)entity {
    if (entity) {
        [entity.toJSONString writeToFile:[self savePath] atomically:yearMask encoding:NSUTF8StringEncoding error:nil];
        //[[NSFileManager defaultManager] createDirectoryAtPath:path.cachesPath withIntermediateDirectories:YES attributes:nil error:nil]; // 放在单例中执行
    }
}

+ (NSString *)savePath {
    DataSavePath * path = [DataSavePath share];
#if DEBUG
    return [NSString stringWithFormat:@"%@/%@Debug.txt", path.cachesPath, FavoriteDBPath];
#else
    return [NSString stringWithFormat:@"%@/%@.txt", path.cachesPath, FavoriteDBPath];
#endif
}

- (void)addFavoriteAppEntity:(FavoriteAppEntity *)entity {
    [[self.arrayEntity mutableArrayValueForKey:@"appArray"] addObject:entity];
    
    [FavoriteAppTool updateEntity];
}

- (void)removeFavoriteAppEntity:(FavoriteAppEntity *)entity {
    [[self.arrayEntity mutableArrayValueForKey:@"appArray"] removeObject:entity];
    
    [FavoriteAppTool updateEntity];
}

@end



