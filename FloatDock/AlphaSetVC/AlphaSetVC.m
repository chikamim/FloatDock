//
//  AlphaSetVC.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/28.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AlphaSetVC.h"
#import <Masonry/Masonry.h>

@interface AlphaSetVC ()

@end

@implementation AlphaSetVC

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.layer.backgroundColor = NSColor.clearColor.CGColor;
    
    self.alphaTF = ({
        NSTextField * tf   = [NSTextField new];
        tf.alignment       = NSTextAlignmentCenter;
        tf.font            = [NSFont systemFontOfSize:50];
        tf.backgroundColor = NSColor.clearColor;
        tf.textColor       = NSColor.whiteColor;
        tf.bordered        = NO;
        tf.editable        = NO;
        
        [self.view addSubview:tf];
        tf;
    });
    
    [self.alphaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(0);
        
        make.height.mas_equalTo(70);
    }];
}

@end
