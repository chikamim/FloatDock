//
//  FavoriteVC.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteVC.h"
#import <Masonry/Masonry.h>
#import "FavoriteAppEntity.h"
#import "FavoriteColumnEntity.h"


#import "EditableTextField.h"
#import "NSView+Address.h"
#import "LLCustomBT.h"
#import "HotKeyTool.h"

#import <ReactiveObjC/ReactiveObjC.h>

typedef void(^BlockPDic) (NSDictionary * dic);

static int CellHeight = 23;

@interface FavoriteVC () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSTableView  * infoTV;
@property (nonatomic, strong) NSScrollView * infoTV_CSV;
@property (nonatomic, strong) NSMenu       * infoTVClickMenu;

@property (nonatomic, weak  ) FavoriteAppTool * favoriteAppTool;
@property (nonatomic, weak  ) HotKeyTool      * hotKeyTool;

@property (nonatomic, strong) RACDisposable   * editHotkeyDisposable;

@end

@implementation FavoriteVC

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.favoriteAppTool = [FavoriteAppTool share];
    self.hotKeyTool      = [HotKeyTool share];
    [self addTagTVs];
    [self.infoTV reloadData];
    
    [self.infoTV setTarget:self];
    [self.infoTV setAction:@selector(tvClickAction)];
    
    @weakify(self);
    [RACObserve(self.favoriteAppTool.arrayEntity, appArray) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self.infoTV reloadData];
    }];
}


// MARK: tv
- (NSScrollView *)addTagTVs {
    CGFloat width = 100;
    // create a table view and a scroll view
    NSScrollView * tableContainer  = [[NSScrollView alloc] initWithFrame:CGRectZero];
    NSTableView * tableView        = [[NSTableView alloc] initWithFrame:tableContainer.bounds];
    tableView.tag = 0;
    
    FavoriteColumnEntity * eName = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eHotkey = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eSwitch = [FavoriteColumnEntity new];
    FavoriteColumnEntity * ePath = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eDelete = [FavoriteColumnEntity new];
    
    eName.title = @"名称";
    eName.columnID = @"2";
    eName.tip = @"APP 名称";
    eName.width = 100;
    eName.miniWidth = 70;
    
    eHotkey.title = @"快捷键";
    eHotkey.columnID = @"3";
    eHotkey.tip = @"APP 快捷键";
    eHotkey.width = 90;
    eHotkey.miniWidth = 50;
    
    eSwitch.title = @"开关";
    eSwitch.columnID = @"1";
    eSwitch.tip = @"快捷键开关";
    eSwitch.width = 30;
    eSwitch.miniWidth = 30;
    
    ePath.title = @"路径";
    ePath.columnID = @"4";
    ePath.tip = @"APP 路径";
    ePath.width = 300;
    ePath.miniWidth = 100;

    
    eDelete.title = @"删除";
    eDelete.columnID = @"5";
    eDelete.tip = @"取消收藏";
    eDelete.width = 30;
    eDelete.miniWidth = 30;
    
    
    NSArray * array = @[eSwitch, eName, eHotkey, eDelete, ePath];
    
    for (int i=0; i<array.count; i++) {
        FavoriteColumnEntity * entity = array[i];
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:entity.columnID];
        column.width         = entity.width;
        column.minWidth      = entity.miniWidth;
        column.title         = entity.title;
        column.headerToolTip = entity.tip;
        
        [tableView addTableColumn:column];
        
        width = entity.width;
    }
    
    tableView.delegate                   = self;
    tableView.dataSource                 = self;
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(30);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.infoTV = tableView;
    
    return tableContainer;
}

// MARK: NSTV delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return self.favoriteAppTool.arrayEntity.appArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return CellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    //__weak typeof(self) weakSelf = self;
    NSInteger column = [[tableColumn.identifier substringFromIndex:tableColumn.identifier.length-1] intValue];
    //NSLog(@"column: %li", column);
    NSView *cell;
    FavoriteAppEntity * entity = self.favoriteAppTool.arrayEntity.appArray[row];
    if (!entity) {
        NSLog(@"self.interactor.moveEntityArray count: %li", self.favoriteAppTool.arrayEntity.appArray.count);
        return nil;
    }
    NSLog(@"%li - %li", row, column);
    switch (column) {
        case 1:{
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                [cellBT setButtonType:NSButtonTypeSwitch];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellBtSwitchAction:)];
                cellBT.title = @"";
            }
            cellBT.tag = row;
            cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            
            break;
        }
            
        case 2:{
            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                //使用方法
                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                cellBT.isHandCursor = YES;
                cellBT.defaultTitle = @"单独查看";
                //cellBT.selectedTitle = @"已选中";
                cellBT.defaultTitleColor  = [NSColor textColor]; //[NSColor whiteColor];
                //cellBT.selectedTitleColor = [NSColor blackColor];
                cellBT.defaultFont  = [NSFont systemFontOfSize:15];
                //cellBT.selectedFont = [NSFont systemFontOfSize:10];
                cellBT.defaultBackgroundColor  = [NSColor clearColor];
                cellBT.selectedBackgroundColor = [NSColor selectedTextBackgroundColor];
                cellBT.defaultBackgroundImage  = [NSImage imageNamed:@""];
                cellBT.selectedBackgroundImage = [NSImage imageNamed:@""];
                //cellBT.rectCorners = LLRectCornerTopLeft|LLRectCornerBottomLeft;
                //cellBT.radius = 15;
                cellBT.textAlignment = LLTextAlignmentLeft;
                //cellBT.textUnderLineStyle = LLTextUnderLineStyleDeleteDouble;
               
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellViewBTAction:)];
                
            }
            cellBT.weakEntity = entity;
            cellBT.defaultTitle = entity.appName;
            //cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            
            break;
        }
        case 3:{
            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                //使用方法
                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                cellBT.isHandCursor = YES;
                //cellBT.defaultTitle = @"请设置";
                //cellBT.selectedTitle = @"已选中";
                cellBT.defaultTitleColor  = [NSColor textColor]; //[NSColor whiteColor];
                //cellBT.selectedTitleColor = [NSColor blackColor];
                cellBT.defaultFont  = [NSFont systemFontOfSize:15];
                //cellBT.selectedFont = [NSFont systemFontOfSize:10];
                cellBT.defaultBackgroundColor  = [NSColor clearColor];
                cellBT.selectedBackgroundColor = [NSColor selectedTextBackgroundColor];
                cellBT.defaultBackgroundImage  = [NSImage imageNamed:@""];
                cellBT.selectedBackgroundImage = [NSImage imageNamed:@""];
                //cellBT.rectCorners = LLRectCornerTopLeft|LLRectCornerBottomLeft;
                //cellBT.radius = 15;
                cellBT.textAlignment = LLTextAlignmentLeft;
                //cellBT.textUnderLineStyle = LLTextUnderLineStyleDeleteDouble;
               
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellViewBTSetHotkeyAction:)];
                
            }
            cellBT.weakEntity = entity;
            if (entity.hotKey.length == 0) {
                cellBT.defaultTitle = @"请设置";
            } else {
                cellBT.defaultTitle = entity.hotKey;
            }
            //cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            break;
        }
        case 4:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:NO initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.appPath ? :@"";
            cell = cellTF;
            break;
        }
        case 5:{
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellBtDeleteAction:)];
                
                [cellBT setImage:[NSImage imageNamed:@"delete"]];
                cellBT.layer.backgroundColor = [NSColor clearColor].CGColor;
            }
            cellBT.tag = row;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            
            break;
        }
        default: {
            break;
        }
    }
    
    
    return cell;
    // */
}

// 返回编辑状态下成白色的背景色的TF.
- (EditableTextField *)tableView:(NSTableView *)tableView cellTFForColumn:(NSTableColumn *)tableColumn row:(NSInteger)row edit:(BOOL)edit initBlock:(BlockPDic)block {
    EditableTextField * cellTF = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
    if (!cellTF) {
        int font = 15;
        cellTF = [[EditableTextField alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
        cellTF.font            = [NSFont systemFontOfSize:font];
        cellTF.alignment       = NSTextAlignmentCenter;
        cellTF.editable        = edit;
        cellTF.identifier      = tableColumn.identifier;
        
        cellTF.backgroundColor = [NSColor clearColor];
        cellTF.bordered        = NO;
        
        cellTF.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        if (block) {
            block(@{@"tf":cellTF});
        }
    }
    cellTF.tag = row;
    return cellTF;
}

// 点击 column
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    //NSLog(@"clumn : %@", tableColumn.identifier);
    [self closeEditHotkey];
}

// 开关
- (void)cellBtSwitchAction:(NSButton *)cellBT {
    [self closeEditHotkey];
    
    FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
    //cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
    entity.receive = cellBT.state==NSControlStateValueOn ? YES:NO;
    
    [FavoriteAppTool updateEntity];
}

// 名称APP
- (void)cellViewBTAction:(LLCustomBT *)cellBT {
    [self closeEditHotkey];
    //FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
}

// 设置快捷键
- (void)cellViewBTSetHotkeyAction:(LLCustomBT *)cellBT {
    
    [self closeEditHotkey];
    
    RACSignal * signal;
    signal = RACObserve(self.hotKeyTool, currentKeyboard);
    @weakify(cellBT);
    @weakify(self);
    self.editHotkeyDisposable = [[signal skip:1] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(cellBT);
        @strongify(self);
        
        if ([x hasSuffix:HotKeyEnd] ) {
            if (x.length> HotKeyEnd.length+1) {
                FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
                
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
                entity.hotKey       = cellBT.defaultTitle;
                [FavoriteAppTool updateEntity];
                
                [self.editHotkeyDisposable dispose];
                self.editHotkeyDisposable = nil;
            } else {
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
            }
            
        } else {
            cellBT.defaultTitle = x;
        }
    }];
}

- (void)closeEditHotkey {
    if (self.editHotkeyDisposable) {
        [self.editHotkeyDisposable dispose];
        self.editHotkeyDisposable = nil;
    }
}

- (void)cellBtDeleteAction:(NSButton *)cellBT {
    [[FavoriteAppTool share] removeFavoriteAppEntity:cellBT.weakEntity];
}

- (void)mouseDown:(NSEvent *)event {
    [self closeEditHotkey];
}

- (void)tvClickAction {
    [self closeEditHotkey];
}

@end
