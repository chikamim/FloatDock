//
//  ViewController.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "ViewController.h"

#import "DragView.h"
#import <Masonry/Masonry.h>
#import "AppInfoView.h"
#import "AppInfoViewVM.h"
#import "AppInfoMenuVM.h"

@interface ViewController() 

@property (nonatomic, strong) DragView * dv;

@property (nonatomic, strong) AppInfoViewVM * appInfoViewVM;
@property (nonatomic, strong) AppInfoMenuVM * appInfoMenuVM;

@end

@implementation ViewController

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDvs];
    [self addViews];
}

- (void)addDvs {
    self.dv = [DragView new];
    
    [self.view addSubview:self.dv];
    [self.dv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.dv.dragAppBlock = ^(NSArray * array) {
        [weakSelf.appInfoViewVM addAppUrlArray:array];
        [AppInfoTool updateEntity];
    };
}

- (void)addViews {
    
    self.appInfoViewVM = ({
        AppInfoViewVM * vm = [AppInfoViewVM new];
        vm.appInfoEntity = self.appInfoEntity;
        vm.view          = self.view;
        [vm showBeforeAppPaths];
        
        vm;
    });
    
    self.appInfoMenuVM = ({
        AppInfoMenuVM * vm = [AppInfoMenuVM new];
        vm.view          = self.view;
        vm.appInfoEntity = self.appInfoEntity;
        vm.appInfoViewVM = self.appInfoViewVM;
        [vm addMenus];
        
        vm;
    });
    
}

// MARK: 检查 APP 运行状态
- (void)checkActive:(NSSet *)appRunningSet dic:(NSMutableDictionary *)dic {
    [self.appInfoViewVM checkDockAppActive:appRunningSet dic:dic];
}

@end
