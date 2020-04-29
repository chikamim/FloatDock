//
//  NSView+Address.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/18.
//  Copyright © 2019 popor. All rights reserved.
//

#import "NSView+Address.h"

#import <objc/runtime.h>

@implementation NSView (Address)
@dynamic weakEntity;

- (void)setWeakEntity:(id)weakEntity {
    objc_setAssociatedObject(self, @"weakEntity", weakEntity, OBJC_ASSOCIATION_ASSIGN);
}

- (id)weakEntity {
    return objc_getAssociatedObject(self, @"weakEntity");
}

@end
