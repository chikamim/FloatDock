//
//  AppDelegate.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak  ) NSWindow * window;

- (IBAction)alphaUp:(id)sender;
- (IBAction)alphaDown:(id)sender;

@end

