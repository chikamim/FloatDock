//
//  ViewController.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppInfoEntity.h"

static CGFloat VcHeight = 70;

typedef void(^FloatDockBlockPVoid) (void);

@interface ViewController : NSViewController

@property (nonatomic, weak  ) AppInfoEntity * appInfoEntity;
@property (nonatomic, copy  ) FloatDockBlockPVoid addDockBlock;

- (void)checkActive:(NSSet *)appRunningSet;


@end

