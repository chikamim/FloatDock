//
//  FloatDockVC.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.

#import "FloatDockVC.h"
#import "FloatDockVCPresenter.h"
#import "FloatDockVCInteractor.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "DragView.h"
#import "AppInfoView.h"
#import "AppInfoViewVM.h"
#import "AppInfoMenuVM.h"
#import "AppWindowTool.h"

@interface FloatDockVC ()

@property (nonatomic, strong) FloatDockVCPresenter * present;

@property (nonatomic, strong) DragView * dv;

@property (nonatomic, strong) AppInfoViewVM * appInfoViewVM;
@property (nonatomic, strong) AppInfoMenuVM * appInfoMenuVM;


@end

@implementation FloatDockVC
@synthesize appInfoEntity;
@synthesize infoCvSV;
@synthesize infoCV;
@synthesize infoCvLayout;
@synthesize awt;
@synthesize appActiveDic;


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"FloatDockVC";
    }
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

#pragma mark - VCProtocol
- (NSViewController *)vc {
    return self;
}

- (void)updateAppIconWidth {
    [self updateAppIconSize];
    [self updateWindowFrame];
    
}

- (void)updateAppIconSize {
    [self.infoCvSV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.awt.appIconWidthNum.floatValue +10);
    }];
}

- (void)updateWindowFrame {
    CGFloat width  = 20 + self.awt.appIconWidthNum.floatValue *self.appInfoEntity.appPathArray.count + 10*(self.appInfoEntity.appPathArray.count-1);
    CGFloat height = self.awt.appIconWidthNum.floatValue + 20;
    [self.view.window setFrame:CGRectMake(self.appInfoEntity.x, self.appInfoEntity.y, width, height) display:YES];
    
    self.infoCvLayout.itemSize = CGSizeMake(self.awt.appIconWidthNum.floatValue, self.awt.appIconWidthNum.floatValue);
    
    [self.infoCV reloadData];
}

#pragma mark - viper views
- (void)assembleViper {
    if (!self.present) {
        FloatDockVCPresenter * present = [FloatDockVCPresenter new];
        FloatDockVCInteractor * interactor = [FloatDockVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    
    self.awt = [AppWindowTool share];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat width = 20 + self.awt.appIconWidthNum.floatValue *self.appInfoEntity.appPathArray.count + 10*(self.appInfoEntity.appPathArray.count-1);
        [self.view.window setFrame:CGRectMake(self.appInfoEntity.x, self.appInfoEntity.y, width, 70) display:YES];
        
        //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    });
    
    [self addDvs];
    self.infoCV = [self addCV];
    
    //[self.view setWantsLayer:YES];
    //[self.view.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
    
    
    //    [self addViews_vm];
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------

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

- (void)addViews_vm {
    
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
- (void)checkDockAppActive:(NSMutableDictionary *)dic {
    //[self.appInfoViewVM checkDockAppActive:dic];
    self.appActiveDic = dic;
    
    [self.infoCV reloadData];
}

- (NSCollectionView *)addCV {
    
    self.infoCvLayout = ({
        NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(self.awt.appIconWidthNum.floatValue, self.awt.appIconWidthNum.floatValue);
        
        layout;
    });
    
   
    
    
    CGRect rect = CGRectZero;
    NSCollectionView *collectionView = [[NSCollectionView alloc] initWithFrame:rect];
    collectionView.collectionViewLayout = self.infoCvLayout;
    
    collectionView.dataSource = self.present;
    collectionView.delegate   = self.present;
    
    [collectionView registerClass:[AppIconItem class] forItemWithIdentifier:AppIconItemKey];
    
    NSClipView *clip = [[NSClipView alloc] initWithFrame:rect];
    clip.documentView = collectionView;
    
    self.infoCvSV = ({
        NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:CGRectZero];
        scrollView.contentView = clip;
        [self.dv addSubview:scrollView];
        
        scrollView;
    });
    
    [self.infoCvSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.awt.appIconWidthNum.floatValue +10);
        
        //make.top.mas_equalTo(0);
        //make.bottom.mas_equalTo(0);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
        //make.centerY.mas_equalTo(0);
        //make.height.mas_equalTo(self.awt.appIconWidthNum.floatValue);
    }];
    
    {   // 此为保证小白点显示出来第二步
        self.infoCvSV.wantsLayer = YES;
        self.infoCvSV.backgroundColor   = [NSColor clearColor];
        self.infoCvSV.layer.masksToBounds = NO;
        
        collectionView.wantsLayer = YES;
        collectionView.backgroundColors = @[[NSColor clearColor]];
        collectionView.layer.masksToBounds = NO;
        
        clip.wantsLayer = YES;
        clip.backgroundColor = [NSColor clearColor];
        clip.layer.masksToBounds = NO;
    
    }
    // 需要延迟处理 滑动条, 不然边缘的滑动条会影响拖拽动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.infoCvSV.verticalScroller.hidden = YES;
        self.infoCvSV.horizontalScroller.hidden = YES;
    });
    
    return collectionView;
}

@end
