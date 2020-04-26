//
//  ViewController.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "DragView.h"
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
        [vm addMenus];
        
        vm;
    });
    
    // MARK: 通过 rac 替换相互之间的引用关系
    @weakify(self);
    // 新增 app icon
    [[self.appInfoViewVM rac_signalForSelector:@selector(addAppAction)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        
        [self.appInfoMenuVM addAppAction];
    }];
    
    // 新增 app icon url 数组
    [[self.appInfoMenuVM rac_signalForSelector:@selector(addAppUrlArray:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.appInfoViewVM addAppUrlArray:(NSArray *)x.first];
    }];
    // 新增 app icon path 数组
    [[self.appInfoMenuVM rac_signalForSelector:@selector(addAppPathArray:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.appInfoViewVM addAppPathArray:(NSArray *)x.first];
    }];
    
    // 清空 dock
    [[self.appInfoMenuVM rac_signalForSelector:@selector(clearDockAppAction)] subscribeNext:^(RACTuple * _Nullable x) {
       @strongify(self);
        [self.appInfoViewVM clearDockAppAction];
    }];
    
    // 删除 dock
    [[self.appInfoMenuVM rac_signalForSelector:@selector(deleteDockAction)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.appInfoViewVM deleteDockAction];
    }];
    
}

// MARK: 检查 APP 运行状态
- (void)checkActive:(NSSet *)appRunningSet dic:(NSMutableDictionary *)dic {
    [self.appInfoViewVM checkDockAppActive:appRunningSet dic:dic];
}

@end
