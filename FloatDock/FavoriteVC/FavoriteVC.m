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

static int CellHeight = 32;
static NSString * HotKeyDefaultText = @"请设置";

@interface FavoriteVC () <NSTableViewDelegate, NSTableViewDataSource>

//@property (nonatomic, strong) NSTextField  * tipTF;
@property (nonatomic, strong) NSTextView   * tipTextView;

@property (nonatomic, strong) NSTableView  * infoTV;
@property (nonatomic, strong) NSScrollView * infoTV_CSV;
@property (nonatomic, strong) NSMenu       * infoTVClickMenu;

@property (nonatomic, weak  ) FavoriteAppTool * favoriteAppTool;
@property (nonatomic, weak  ) HotKeyTool      * hotKeyTool;

@property (nonatomic, strong) RACDisposable   * editHotkeyDisposable;
@property (nonatomic, weak  ) LLCustomBT * editHotkeyCellBT;

@end

@implementation FavoriteVC

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    //[self addTFs];
    [self addTextViews];
    
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
    
    [self.view needsLayout];
}

/*
- (void)addTFs {
    self.tipTF = ({
        NSTextField * tf = [NSTextField new];
        tf.backgroundColor = [NSColor clearColor];//[NSColor textBackgroundColor];
        tf.textColor       = [NSColor textColor];
        tf.alignment       = NSTextAlignmentLeft;
        tf.font            = [NSFont systemFontOfSize:14];
        tf.bordered        = NO;
        tf.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        tf.editable        = NO;

        tf.maximumNumberOfLines = 3;

        [self.view addSubview:tf];
        tf;
    });

    self.tipTF.stringValue = @"全局快捷键需要您在 [系统偏好设置] > [安全与隐私] > [辅助功能] 中选中 FloatDock, 并且重启APP.";

    [self.tipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
        //make.bottom.mas_equalTo(-20);
        //make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
    }];
}
//*/

- (void)addTextViews {
    
    self.tipTextView = ({
        NSTextView * tv = [NSTextView new];
        tv.backgroundColor = [NSColor clearColor];//[NSColor textBackgroundColor];
        tv.textColor       = [NSColor textColor];
        tv.alignment       = NSTextAlignmentLeft;
        tv.font            = [NSFont systemFontOfSize:13];
        //tf.bordered        = NO;
        //tf.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        tv.editable        = NO;
        
        
        //tf.maximumNumberOfLines = 3;
        
        [self.view addSubview:tv];
        tv;
    });
    
    [self.tipTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        //make.bottom.mas_equalTo(-20);
        //make.height.mas_equalTo(60);
        make.right.mas_equalTo(-5);
        make.height.mas_lessThanOrEqualTo(40);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    self.tipTextView.string = @"全局快捷键需要您在 [系统偏好设置] > [安全与隐私] > [辅助功能] 中选中 FloatDock, 并且重启APP.";
    //[self.tipTextView sizeToFit];
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(closeEditHotkey)];
    [self.tipTextView addGestureRecognizer:click];
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
    FavoriteColumnEntity * eFavorite = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eIcon  = [FavoriteColumnEntity new];
    
    eName.title = @"名称(拖拽排序)";
    eName.columnID = @"2";
    eName.tip = @"APP 名称";
    eName.width = 200;
    eName.miniWidth = 70;
    
    eHotkey.title = @"全局快捷键";
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

    
    eDelete.title = @"删除快捷键";
    eDelete.columnID = @"5";
    eDelete.tip = @"删除快捷键";
    eDelete.width = 60;
    eDelete.miniWidth = 60;
    
    eIcon.title = @"图标";
    eIcon.columnID = @"6";
    eIcon.tip = @"图标";
    eIcon.width = CellHeight;
    eIcon.miniWidth = CellHeight;
    
    eFavorite.title = @"取消收藏";
    eFavorite.columnID = @"7";
    eFavorite.tip = @"取消收藏";
    eFavorite.width = 60;
    eFavorite.miniWidth = 60;
    
    NSArray * array = @[eSwitch, eIcon, eName, eHotkey, eDelete, eFavorite]; //ePath
    
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
    [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]]; // 注册可拖拽
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.tipTextView.mas_bottom).mas_offset(10);
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
    //NSLog(@"%li - %li", row, column);
    switch (column) {
        case 1:{ // 开关
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
            
        case 2:{ // 名称
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
                tf.editable  = NO;
            }];
            cellTF.stringValue = entity.appName;
            cell = cellTF;
            
            //            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            //            if (!cellBT) {
            //                //使用方法
            //                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
            //                cellBT.isHandCursor = YES;
            //                cellBT.defaultTitle = @"";
            //                //cellBT.selectedTitle = @"已选中";
            //                cellBT.defaultTitleColor  = [NSColor textColor]; //[NSColor whiteColor];
            //                //cellBT.selectedTitleColor = [NSColor blackColor];
            //                cellBT.defaultFont  = [NSFont systemFontOfSize:15];
            //                //cellBT.selectedFont = [NSFont systemFontOfSize:10];
            //                cellBT.defaultBackgroundColor  = [NSColor clearColor];
            //                cellBT.selectedBackgroundColor = [NSColor selectedTextBackgroundColor];
            //                cellBT.defaultBackgroundImage  = [NSImage imageNamed:@""];
            //                cellBT.selectedBackgroundImage = [NSImage imageNamed:@""];
            //                //cellBT.rectCorners = LLRectCornerTopLeft|LLRectCornerBottomLeft;
            //                //cellBT.radius = 15;
            //                cellBT.textAlignment = LLTextAlignmentLeft;
            //                //cellBT.textUnderLineStyle = LLTextUnderLineStyleDeleteDouble;
            //
            //                [cellBT setTarget:self];
            //                [cellBT setAction:@selector(cellViewBTAction:)];
            //
            //            }
            //            cellBT.weakEntity = entity;
            //            cellBT.defaultTitle = entity.appName;
            //            //cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            //            cell = cellBT;
            
            break;
        }
        case 3:{ // 快捷键
            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                //使用方法
                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                cellBT.isHandCursor = YES;
                //cellBT.defaultTitle = HotKeyDefaultText;
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
                cellBT.defaultTitle = HotKeyDefaultText;
            } else {
                cellBT.defaultTitle = entity.hotKey;
            }
            //cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            break;
        }
        case 4:{// 路径
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:NO initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.appPath ? :@"";
            cell = cellTF;
            break;
        }
        case 5:{//删除快捷键
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellBtDeleteHotKeyAction:)];
                [cellBT setImage:[NSImage imageNamed:@"delete"]];
                
                //[cellBT set]
                //cellBT.layer.backgroundColor = [NSColor redColor].CGColor;
                //cellBT.cell.backgroundStyle = NSBackgroundStyleLowered;
                
            }
            cellBT.tag = row;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            
            break;
        }
            
        case 6:{// 图标
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                //[cellBT setTarget:self];
                //[cellBT setAction:@selector(cellBtDeleteHotKeyAction:)];
                
                cellBT.layer.backgroundColor = [NSColor clearColor].CGColor;
            }
            cellBT.tag = row;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            if (!entity.appImage) {
                NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
                NSImage *finderIcon;
                //= [workspace iconForFile:[workspace absolutePathForAppBundleWithIdentifier:@"com.apple.Finder"]];
                finderIcon = [workspace iconForFile:[entity.appPath substringFromIndex:7]];
                [finderIcon setSize:NSMakeSize(CellHeight, CellHeight)];
                
                entity.appImage = finderIcon;
            }
            [cellBT setImage:entity.appImage];
            
            break;
        }
            
        case 7:{//删除收藏
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellBtFavoriteAction:)];
                [cellBT setTitle:@"❤️"];
                //[cellBT setImage:[NSImage imageNamed:@"delete"]];
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

// 是否允许点击
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
}

// !!!: row 排序模块
// [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]];
// https://juejin.im/entry/5795deb90a2b580061c7eb74
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    if (tableView == self.infoTV) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes requiringSecureCoding:NO error:nil];
        //NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [pboard declareTypes:@[NSPasteboardNameDrag] owner:self];
        
        [pboard setData:data forType:NSPasteboardNameDrag];
        [pboard setString:[NSString stringWithFormat:@"%li", [rowIndexes firstIndex]] forType:NSPasteboardNameDrag];
        return YES;
    }else{
        return NO;
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    if (tableView == self.infoTV) {
        if (dropOperation == NSTableViewDropAbove) {
            return NSDragOperationMove;
        }else{
            return NSDragOperationNone;
        }
    }else{
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSString * currencyCode = [info.draggingPasteboard stringForType:NSPasteboardNameDrag];
    NSInteger from = [currencyCode integerValue];
    if(tableView == self.infoTV){
        [self resortTV:tableView form:from to:row array:self.favoriteAppTool.arrayEntity.appArray];
        
        [FavoriteAppTool updateEntity];
        return YES;
    }else{
        return NO;
    }
}

- (void)resortTV:(NSTableView *)tableView form:(NSInteger)from to:(NSInteger)to array:(NSMutableArray *)array {
    if (array.count > 1 && from != to && (from-to) != -1) {
        //NSLog(@"move tableview cell from: %li, to:%li", from, to);
        id entity = array[from];
        [array removeObject:entity];
        if (from > to) {
            [array insertObject:entity atIndex:to];
        }else{
            [array insertObject:entity atIndex:to-1];
        }
        [tableView reloadData];
    }
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

// !!!: 设置快捷键
- (void)cellViewBTSetHotkeyAction:(LLCustomBT *)cellBT {
    
    [self closeEditHotkey];
    self.editHotkeyCellBT = cellBT;
    cellBT.defaultBackgroundColor = [NSColor selectedTextBackgroundColor];
    //cellBT.defaultTitleColor      = [NSColor selectedTextColor];
    
    RACSignal * signal;
    signal = RACObserve(self.hotKeyTool, currentKeyboard);
    @weakify(cellBT);
    @weakify(self);
    self.editHotkeyDisposable = [[signal skip:1] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(cellBT);
        @strongify(self);
        FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
        NSLog(@"设置快捷键 : %@", x);
        if ([x hasSuffix:HotKeyEnd] ) {
            if (x.length> HotKeyEnd.length+1) {
                
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
                entity.hotKey       = cellBT.defaultTitle;
                [FavoriteAppTool updateEntity];
                
                [self closeEditHotkey];
            } else {
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
            }
            NSLog(@"1");
        }
        else if (x.length == 0) {
            cellBT.defaultTitle = entity.hotKey ? :HotKeyDefaultText;
        }
        else {
            cellBT.defaultTitle = x;
        }
    }];
}

- (void)closeEditHotkey {
    if (self.editHotkeyCellBT) {
        self.editHotkeyCellBT.defaultBackgroundColor = [NSColor clearColor];
        //self.editHotkeyCellBT.defaultTitleColor      = [NSColor textColor];
    }
    if (self.editHotkeyDisposable) {
        [self.editHotkeyDisposable dispose];
        self.editHotkeyDisposable = nil;
    }
}

- (void)cellBtDeleteHotKeyAction:(NSButton *)cellBT {
    [self closeEditHotkey];
    FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
    entity.hotKey = nil;
    [FavoriteAppTool updateEntity];
    [self.infoTV reloadData];
}

- (void)cellBtFavoriteAction:(NSButton *)cellBT {
    [self closeEditHotkey];
    [[FavoriteAppTool share] removeFavoriteAppEntity:cellBT.weakEntity];
}

- (void)mouseDown:(NSEvent *)event {
    [self closeEditHotkey];
}

- (void)tvClickAction {
    [self closeEditHotkey];
}

@end
