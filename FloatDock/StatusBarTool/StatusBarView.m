//
//  StatusBarView.m
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "StatusBarView.h"

#import <Masonry/Masonry.h>
//#define menuItem ([self enclosingMenuItem])

static CGFloat StatusBarViewLeft = 6;

@implementation StatusBarView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    NSRect theRect = NSMakeRect(0, 0, 100, 20);
    self = [super initWithFrame:theRect];
    if (self) {
        [self addView];
        
        // // 监听鼠标划入事件
        // // https://stackoverrun.com/cn/q/4795031
        // NSTrackingArea * trackingArea = [[NSTrackingArea alloc] initWithRect:theRect
        //                                                              options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingActiveAlways)
        //                                                                owner:self userInfo:nil];
        // [self addTrackingArea:trackingArea];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    BOOL isHighlighted = [[self enclosingMenuItem] isHighlighted];
    if (isHighlighted) {
        [[NSColor controlAccentColor] setFill];
        // 圆角填充
        //static NSBezierPath * border;
        NSBezierPath * border;
        if (!border) {
            CGRect fillRect = CGRectMake(StatusBarViewLeft, 0, rect.size.width -StatusBarViewLeft*2 -5, rect.size.height);
            border = [NSBezierPath bezierPathWithRoundedRect:fillRect xRadius:4 yRadius:4];
        }
        
        [border fill];
    } else {
        [[NSColor clearColor] setFill];
    }
    
    // NSLog(@"witdh : %f", rect.size.width);
    
    // 直角填充
    //CGRect fillRect = CGRectMake(self.subtitleTF.frame.origin.x, self.subtitleTF.frame.origin.y, CGRectGetMaxX(self.hotkeyTF.frame) -self.subtitleTF.frame.origin.x, rect.size.height);
    //CGRect fillRect = CGRectMake(6, 0, rect.size.width -12, rect.size.height);
    //NSRectFill(fillRect);
    
    [super drawRect:rect];
}

- (void)mouseUp:(NSEvent*)event {
    //    NSMenuItem * mitem = [self enclosingMenuItem];
    //    NSMenu * m = [mitem menu];
    //    [m cancelTracking];
    //
    //    NSLog(@"you clicked the %ld item", [m indexOfItem: mitem]);
    
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}

//- (void)mouseDown:(NSEvent *)event {
//    NSLog(@"11");
//}

- (void)addView {
    
    self.iconBT = ({
        NSButton * cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, ImageStatusBarWidth, ImageStatusBarWidth)];
        cellBT.bezelStyle = NSBezelStyleDisclosure;
        cellBT.layer.backgroundColor = [NSColor clearColor].CGColor;
        cellBT.title = @"";
        
        [self addSubview:cellBT];
        cellBT;
    });
    
    self.nameTF = ({
        NSTextField * tf   = [NSTextField new];
        tf.alignment       = NSTextAlignmentLeft;
        tf.font            = [NSFont systemFontOfSize:12];
        tf.backgroundColor = NSColor.clearColor;
        tf.textColor       = NSColor.textColor;
        tf.bordered        = NO;
        tf.editable        = NO;
        
        [self addSubview:tf];
        tf;
    });
    self.hotkeyTF = ({
        NSTextField * tf   = [NSTextField new];
        tf.alignment       = NSTextAlignmentRight;
        tf.font            = [NSFont systemFontOfSize:12];
        tf.backgroundColor = NSColor.clearColor;
        tf.textColor       = NSColor.textColor;
        tf.bordered        = NO;
        tf.editable        = NO;
        
        [self addSubview:tf];
        tf;
    });
    self.statusTF = ({
        NSTextField * tf   = [NSTextField new];
        tf.alignment       = NSTextAlignmentCenter;
        tf.font            = [NSFont systemFontOfSize:16];
        tf.backgroundColor = NSColor.clearColor;
        tf.textColor       = NSColor.textColor;
        tf.bordered        = NO;
        tf.editable        = NO;
        tf.stringValue     = @"•";
        [self addSubview:tf];
        tf;
    });
    
    CGFloat left = StatusBarViewLeft*2;
   
    [self.iconBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(self.iconBT.frame.size);
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconBT.mas_right).mas_offset(2);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.nameTF.font.pointSize *1.3);
    }];
    
    [self.hotkeyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.hotkeyTF.font.pointSize *1.3);
        
        make.left.mas_equalTo(self.nameTF.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.statusTF.mas_left).mas_offset(0);
    }];
    [self.statusTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self);
        
        make.width.mas_equalTo(16);
        make.right.mas_equalTo(2);
    }];
}

@end
