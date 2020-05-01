//
//  FavoriteColumnEntity.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteColumnEntity : NSObject

@property (nonatomic, copy  ) NSString * columnID;
@property (nonatomic, copy  ) NSString * title;
@property (nonatomic, copy  ) NSString * tip;
@property (nonatomic        ) NSInteger  width;
@property (nonatomic        ) NSInteger  miniWidth;

@end

NS_ASSUME_NONNULL_END
