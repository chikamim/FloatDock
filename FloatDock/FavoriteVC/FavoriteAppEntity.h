//
//  FavoriteAppEntity.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteAppEntity : JSONModel

@property (nonatomic        ) NSInteger  index;
@property (nonatomic, copy  ) NSString * appPath;
@property (nonatomic, copy  ) NSString * hotKey;  // 快捷键

@end

NS_ASSUME_NONNULL_END
