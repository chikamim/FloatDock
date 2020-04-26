//
//  AppInfoMenuVM.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/26.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AppInfoEntity.h"

@class AppInfoViewVM;

NS_ASSUME_NONNULL_BEGIN

typedef void(^FloatDockBlockPVoid) (void);

@interface AppInfoMenuVM : NSObject

@property (nonatomic, weak  ) NSView * view;
@property (nonatomic, weak  ) AppInfoEntity  * appInfoEntity;
@property (nonatomic, weak  ) AppInfoViewVM  * appInfoViewVM;

- (void)addMenus;

@end

NS_ASSUME_NONNULL_END
