//
//  LLCustomBT.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/25.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// LLCustomBtn : https://www.jianshu.com/p/7817de7df005

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    
    LLRectCornerTopLeft     = 1 << 0,
    LLRectCornerTopRight    = 1 << 1,
    LLRectCornerBottomLeft  = 1 << 2,
    LLRectCornerBottomRight = 1 << 3,
    LLRectCornerAllCorners  = ~0UL
} LLRectCorner;

typedef enum {
    
    LLTextAlignmentLeft  = 0, //左对齐
    LLTextAlignmentCenter,    //居中
    LLTextAlignmentRight      //右对齐
    
}LLTextAlignment;

typedef enum {
    
    LLTextUnderLineStyleNone  = 0,     //无下划线
    LLTextUnderLineStyleSingle,        //单下划线
    LLTextUnderLineStyleDouble,        //双下划线
    LLTextUnderLineStyleDeleteSingle,  //单删除线
    LLTextUnderLineStyleDeleteDouble   //双删除线
    
}LLTextUnderLineStyle;

@interface LLCustomBT : NSView

@property (nullable, weak) id target;
@property (nullable) SEL action;

///当鼠标移动到控件时，是否显示"小手"
@property (nonatomic, assign) BOOL isHandCursor;

///圆角
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) LLRectCorner rectCorners;

///按钮文字
@property (nonatomic, nullable, strong) NSString *defaultTitle;
@property (nonatomic, nullable, strong) NSString *selectedTitle;

///按钮文字对齐方式
@property (nonatomic, assign) LLTextAlignment textAlignment;

///按钮文字下划线样式
@property (nonatomic, assign) LLTextUnderLineStyle textUnderLineStyle;

///按钮文字颜色
@property (nonatomic, nullable, strong) NSColor  *defaultTitleColor;
@property (nonatomic, nullable, strong) NSColor  *selectedTitleColor;

///按钮字体
@property (nonatomic, nullable, strong) NSFont   *defaultFont;
@property (nonatomic, nullable, strong) NSFont   *selectedFont;

///当背景图片存在时，背景色无效
@property (nonatomic, nullable, strong) NSImage  *defaultBackgroundImage;
@property (nonatomic, nullable, strong) NSImage  *selectedBackgroundImage;

///当背景图片不存在时，显示背景色
@property (nonatomic, nullable, strong) NSColor  *defaultBackgroundColor;
@property (nonatomic, nullable, strong) NSColor  *selectedBackgroundColor;

@end

NS_ASSUME_NONNULL_END


//使用方法
//LLCustomBtn *btn = [[LLCustomBtn alloc] initWithFrame:CGRectMake(200, 200, 100, 20)];
//btn.isHandCursor = YES;
//btn.defaultTitle = @"未选中";
//btn.selectedTitle = @"已选中";
//btn.defaultTitleColor = [NSColor whiteColor];
//btn.selectedTitleColor = [NSColor blackColor];
//btn.defaultFont = [NSFont systemFontOfSize:10];
//btn.selectedFont = [NSFont systemFontOfSize:10];
//btn.defaultBackgroundColor = [NSColor greenColor];
//btn.selectedBackgroundColor = [NSColor blueColor];
//btn.defaultBackgroundImage = [NSImage imageNamed:@""];
//btn.selectedBackgroundImage = [NSImage imageNamed:@""];
//btn.rectCorners = LLRectCornerTopLeft|LLRectCornerBottomLeft;
//btn.radius = 15;
//btn.textAlignment = LLTextAlignmentLeft;
//btn.textUnderLineStyle = LLTextUnderLineStyleDeleteDouble;
//[btn setTarget:self];
//[btn setAction:@selector(btnCilck:)];
//[self.view addSubview:btn];
