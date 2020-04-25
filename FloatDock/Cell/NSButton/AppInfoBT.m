//
//  AppInfoBT.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/25.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "AppInfoBT.h"

@interface AppInfoBT ()

@property (nonatomic, strong) NSMutableArray * MenuItemAry;

@end

@implementation AppInfoBT

- (id)init {
    if (self = [super init]) {
        _MenuItemAry = [NSMutableArray new];
    }
    return self;
}

// https://www.jianshu.com/p/215a80c66cd1
- (void)rightMouseDown:(NSEvent *)theEvent {
    
    //新建菜单
    NSMenu* newMenu = [[NSMenu allocWithZone:NSDefaultMallocZone()] initWithTitle:@"Name"];
    NSMenuItem* newItem = [[NSMenuItem alloc]init];
    
    //设置菜单内容
    NSRect frameRect = NSMakeRect(0, 0, 200, 80);
    NSView *boundView = [[NSView alloc]initWithFrame:frameRect];
    
    NSRect frameTitle1 = NSMakeRect(2, 58, 30, 20);
    NSTextField *title1 = [[NSTextField alloc]initWithFrame:frameTitle1];
    title1.backgroundColor = [NSColor windowBackgroundColor];
    title1.stringValue = @"Title";
    title1.enabled = NO;
    title1.bordered = NO;
    NSRect frameText1 = NSMakeRect(32, 58, 160, 20);
    NSTextField *Text1 = [[NSTextField alloc]initWithFrame:frameText1];
    Text1.stringValue = self.title;
    
    NSRect frameTitle2 = NSMakeRect(2, 36, 35, 20);
    NSTextField *title2 = [[NSTextField alloc]initWithFrame:frameTitle2];
    title2.backgroundColor = [NSColor windowBackgroundColor];
    title2.stringValue = @"CMD";
    title2.enabled = NO;
    title2.bordered = NO;
    NSRect frameText2 = NSMakeRect(32, 36, 160, 20);
    NSTextField *Text2 = [[NSTextField alloc]initWithFrame:frameText2];
    Text2.stringValue = self.alternateTitle;
    
    NSRect frameCancel = NSMakeRect(30, 10, 60, 20);
    NSButton *cancle = [[NSButton alloc]initWithFrame:frameCancel];
    //    [cancle setBordered:NO];
    [cancle setAction:@selector(cancleButton:)];
    [cancle setBezelStyle:NSBezelStyleRounded];
    cancle.title = @"取消";
    NSRect frameOK = NSMakeRect(100, 10, 60, 20);
    NSButton *OK = [[NSButton alloc]initWithFrame:frameOK];
    //    [OK setBordered:NO];
    [OK setBezelStyle:NSBezelStyleRounded];
    OK.title = @"保存";
    [OK setAction:@selector(OKButton:)];
    //    [OK setKeyEquivalent:@"/r"];
    [boundView addSubview:title1];
    [boundView addSubview:Text1];
    [boundView addSubview:title2];
    [boundView addSubview:Text2];
    [boundView addSubview:cancle];
    [boundView addSubview:OK];
    
    [self.MenuItemAry removeAllObjects];
    [self.MenuItemAry addObjectsFromArray:@[newMenu,Text1,Text2]];
    [newItem setView:boundView];
    
    [newItem setEnabled:YES];
    [newItem setTarget:self];
    [newMenu addItem:newItem];
    
    //设置菜单响应委托
    [NSMenu popUpContextMenu:newMenu withEvent:theEvent forView:self];
}

- (void)cancleButton:(id)cancle{
    NSMenu *aa = self.MenuItemAry[0];
    [aa cancelTracking];
}

- (void)OKButton:(id)ok{
    NSTextField *Title = self.MenuItemAry[1];
    NSTextField *Text  = self.MenuItemAry[2];
    self.title = Title.stringValue;
    self.alternateTitle = Text.stringValue;
    NSLog(@"%@",self.alternateTitle);
    NSMenu *aa = self.MenuItemAry[0];
    [aa cancelTracking];
}

@end
