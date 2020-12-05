//
//  FavoriteVM.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/5/1.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteVM.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import "EditableTextField.h"
#import "NSView+Address.h"
#import "LLCustomBT.h"
#import "HotKeyTool.h"
#import "HotKeyLocal.h"
#import "HotKeyMas.h"

typedef void(^BlockPDic) (NSDictionary * dic);

@interface FavoriteVM ()

@property (nonatomic, weak  ) HotKeyTool * hotKeyTool;
@property (nonatomic, weak  ) HotKeyLocal * hotKeyLocal;
@property (nonatomic, weak  ) HotKeyMas * hotKeyMas;


@property (nonatomic, weak  ) LLCustomBT * editHotkeyCellBT;
@property (nonatomic, strong) RACDisposable   * editHotkeyDisposable;
@property (nonatomic, copy  ) NSString * hotKeyDefaultText;
@end

@implementation FavoriteVM

- (id)init {
    if (self = [super init]) {
        _hotKeyTool  = [HotKeyTool share];
        _hotKeyLocal = [HotKeyLocal share];
        _hotKeyMas   = [HotKeyMas share];
        
        _hotKeyDefaultText = NSLS(@"FD_DefaultHotkey");
    }
    return self;
}

// MARK: NSTV delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return self.hotKeyTool.favoriteAppArrayEntity.array.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return FavoriteCellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    static NSColor * TextColorNormal;
    static NSColor * TextColorEnable;
    static NSColor * TextColorUnable;
    if (!TextColorNormal) {
        TextColorNormal = [NSColor textColor];
        TextColorEnable = [NSColor colorWithRed:252/255.0 green:65/255.0 blue:58/255.0 alpha:1];
        TextColorUnable = [NSColor yellowColor];
    }
    //__weak typeof(self) weakSelf = self;
    NSInteger column = [[tableColumn.identifier substringFromIndex:tableColumn.identifier.length-1] intValue];
    //NSLog(@"column: %li", column);
    NSView *cell;
    FavoriteAppEntity * entity = self.hotKeyTool.favoriteAppArrayEntity.array[row];
    if (!entity) {
        NSLog(@"self.interactor.moveEntityArray count: %li", self.hotKeyTool.favoriteAppArrayEntity.array.count);
        return nil;
    }
    //NSLog(@"%li - %li", row, column);
    switch (column) {
        case 1:{ // 开关
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
                [cellBT setButtonType:NSButtonTypeSwitch];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellBtSwitchAction:)];
                cellBT.title = @"";
            }
            cellBT.tag   = row;
            cellBT.state = entity.enable ? NSControlStateValueOn:NSControlStateValueOff;
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
            cellTF.stringValue = entity.name;
            cell = cellTF;
            
            cellTF.textColor = entity.enable ? TextColorEnable:TextColorNormal ;
            break;
        }
        case 3:{ // 快捷键
            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            if (!cellBT) {
                //使用方法
                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
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
                cellBT.defaultTitle = self.hotKeyDefaultText;
                cellBT.defaultTitleColor = entity.enable ? TextColorUnable:TextColorNormal;
            } else {
                cellBT.defaultTitle = entity.hotKey;
                cellBT.defaultTitleColor = entity.enable ? TextColorEnable:TextColorNormal;
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
            cellTF.stringValue = entity.path ? :@"";
            cell = cellTF;
            break;
        }
        case 5:{//删除快捷键
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
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
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
                
                cellBT.layer.backgroundColor = [NSColor clearColor].CGColor;
                [cellBT setTarget:self];
                [cellBT setAction:@selector(closeEditHotkeyInner)];
            }
            cellBT.tag = row;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            [cellBT setImage:entity.imageFavorite];
            
            break;
        }
            
        case 7:{//删除收藏
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
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
    // ???: owner:self.view => owner:self 会有啥问题吗?
    EditableTextField * cellTF = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (!cellTF) {
        int font = 15;
        cellTF = [[EditableTextField alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, FavoriteCellHeight)];
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
    [self closeEditHotkeyInner];
}

// 是否允许点击
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
}

// !!!: row 排序模块
// [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]];
// https://juejin.im/entry/5795deb90a2b580061c7eb74
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes requiringSecureCoding:NO error:nil];
    //NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [pboard declareTypes:@[NSPasteboardNameDrag] owner:self];
    
    [pboard setData:data forType:NSPasteboardNameDrag];
    [pboard setString:[NSString stringWithFormat:@"%li", [rowIndexes firstIndex]] forType:NSPasteboardNameDrag];
    return YES;
    
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    if (dropOperation == NSTableViewDropAbove) {
        return NSDragOperationMove;
    }else{
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSString * currencyCode = [info.draggingPasteboard stringForType:NSPasteboardNameDrag];
    NSInteger from = [currencyCode integerValue];
    
    [self resortTV:tableView form:from to:row array:self.hotKeyTool.favoriteAppArrayEntity.array];
    
    [self.hotKeyTool updateEntitySaveJson];
    return YES;
    
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
    [self closeEditHotkeyInner];
    
    FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
    //cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
    entity.enable = cellBT.state==NSControlStateValueOn ? YES:NO;
    
    [self.hotKeyTool updateEntitySaveJson];
    [self.infoTV reloadData];
}

// 名称APP
- (void)cellViewBTAction:(LLCustomBT *)cellBT {
    [self closeEditHotkeyInner];
    //FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
}

// !!!: 设置快捷键
- (void)cellViewBTSetHotkeyAction:(LLCustomBT *)cellBT {
    
    [self closeEditHotkeyInner];
    [self.hotKeyLocal monitorKeyboard:YES];
    [self.hotKeyMas monitorKeyboard:NO];
    
    self.editHotkeyCellBT = cellBT;
    cellBT.defaultBackgroundColor = [NSColor selectedTextBackgroundColor];
    //cellBT.defaultTitleColor      = [NSColor selectedTextColor];
    
    RACSignal * signal;
    signal = RACObserve(self.hotKeyLocal, localFlagsKey);
    @weakify(cellBT);
    @weakify(self);
    self.editHotkeyDisposable = [[signal skip:1] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(cellBT);
        @strongify(self);
        FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
        //NSLog(@"设置快捷键 : %@", x);
        if ([x hasSuffix:HotKeyEnd] ) {
            if (x.length> HotKeyEnd.length+1) {
                
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
                entity.hotKey       = cellBT.defaultTitle;
                entity.codeNum      = self.hotKeyLocal.localCode;
                entity.flagNum      = self.hotKeyLocal.localFlags;
                
                [self.hotKeyTool updateEntitySaveJson];
                
                [self closeEditHotkeyInner];
                [self.infoTV reloadData];
            } else {
                cellBT.defaultTitle = [x substringToIndex:x.length - HotKeyEnd.length];
            }
        }
        else if (x.length == 0) {
            cellBT.defaultTitle = entity.hotKey ? :self.hotKeyDefaultText;
        }
        else {
            cellBT.defaultTitle = x;
        }
    }];
}

// 关闭监测键盘输入事件 和 本地键盘监测事件
- (void)closeEditHotkeyInner {
    [self closeEditHotkey:NO];
}

- (void)closeEditHotkeyOuter {
    [self closeEditHotkey:YES];
}

- (void)closeEditHotkey:(BOOL)andMoniter {
    if (self.editHotkeyCellBT) {
        self.editHotkeyCellBT.defaultBackgroundColor = [NSColor clearColor];
        //self.editHotkeyCellBT.defaultTitleColor      = [NSColor textColor];
    }
    if (self.editHotkeyDisposable) {
        [self.editHotkeyDisposable dispose];
        self.editHotkeyDisposable = nil;
    }
    if (andMoniter) {
        [self.hotKeyLocal monitorKeyboard:NO];
        [self.hotKeyMas monitorKeyboard:YES];
    }
}

- (void)cellBtDeleteHotKeyAction:(NSButton *)cellBT {
    [self closeEditHotkeyInner];
    FavoriteAppEntity * entity = (FavoriteAppEntity *)cellBT.weakEntity;
    entity.hotKey = nil;
    [self.hotKeyTool updateEntitySaveJson];
    [self.infoTV reloadData];
}

- (void)cellBtFavoriteAction:(NSButton *)cellBT {
    [self closeEditHotkeyInner];
    [self.hotKeyTool racRemoveFavoriteAppEntity:cellBT.weakEntity];
}

- (void)mouseDown:(NSEvent *)event {
    [self closeEditHotkeyInner];
}

- (void)tvClickAction {
    [self closeEditHotkeyInner];
}

@end
