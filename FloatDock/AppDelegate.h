//
//  AppDelegate.h
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/24.
//  Copyright © 2020 王凯庆. All rights reserved.
//

/*
 icon 地址:https://www.easyicon.net/1179953-Autocad_icon.html
 https://www.easyicon.net/iconsearch/%E8%BD%AF%E4%BB%B6dock%E6%A0%8F/21/?m=yes&f=_all&s=
 
 */

#import <Cocoa/Cocoa.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)alphaUp:(id)sender;
- (IBAction)alphaDown:(id)sender;

- (IBAction)createNewDock:(id)sender;

@end

