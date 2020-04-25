//
//  AppInfoView.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class AppInfoView;

@protocol AppInfoViewProtocol <NSObject>

- (void)delete:(AppInfoView *)appInfoView;
- (void)moveLeft:(AppInfoView *)appInfoView;
- (void)moveRight:(AppInfoView *)appInfoView;

@end

@interface AppInfoView : NSView

@property (nonatomic, copy  ) NSString    * appPath;
@property (nonatomic, copy  ) NSString    * appUrlPath;
@property (nonatomic, strong) NSButton    * appBT;
@property (nonatomic, strong) NSImageView * activeIV;

@property (nonatomic, weak  ) id<AppInfoViewProtocol> delegate;

 
@end

NS_ASSUME_NONNULL_END
