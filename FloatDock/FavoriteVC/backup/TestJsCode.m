//
//  TestJsCode.m
//  FloatDock
//
//  Created by popor on 2020/9/16.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "TestJsCode.h"

@implementation TestJsCode


//- (void)javaScriptDemo {
//    BOOL scriptSuccess = YES;
//    {   // 执行 脚本语言, 这个可以设置打开隐藏, 但是还不能拦截系统按键.
//        NSString * appName = [appPath lastPathComponent];//.stringByRemovingPercentEncoding
//        if ([appName hasSuffix:@".app"]) {
//            appName = [appName substringToIndex:appName.length -4];
//
//            NSString * script =
//            [NSString stringWithFormat:@"\n\
//             tell application \"System Events\" to tell process \"%@\" \n\
//             if visible is true then \n\
//             set visible to false \n\
//             else \n\
//             tell application \"%@\" to activate \n\
//             end if \n\
//             end tell", appName, appName];
//            NSLog(@"%@", script);
//
//            NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:script];
//
//            NSDictionary * errorDic;
//            NSAppleEventDescriptor * returnDescriptor = [scriptObject executeAndReturnError:&errorDic];
//
//            if (errorDic) {
//                scriptSuccess = NO;
//            }
//            if (returnDescriptor != NULL) {
//                // successful execution
//                if (kAENullEvent != [returnDescriptor descriptorType]) {
//                    // script returned an AppleScript result
//                    if (cAEList == [returnDescriptor descriptorType]) {
//                        // result is a list of other descriptors
//                    } else {
//                        // coerce the result to the appropriate ObjC typeŒ
//                    }
//                }
//            } else {
//                // no script result, handle error here
//                scriptSuccess = NO;
//            }
//
//        } else {
//
//        }
//    }
//    //return;
//}

// 一个设置快捷键的方法, 好像是APP内部的.
// https://blog.csdn.net/zz110731/article/details/52712372
//#import <Carbon/Carbon.h>
//OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
//
//    EventHotKeyID hotKeyRef;
//
//    GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyRef), NULL, &hotKeyRef);
//
//    unsigned int hotKeyId = hotKeyRef.id;
//
//    switch (hotKeyId) {
//        case 4:
//            // do something
//            NSLog(@"%d", hotKeyId);
//            break;
//        default:
//            break;
//    }
//    return noErr;
//}
//
//// 注册快捷键
//- (void)costomHotKey {
//
//    // 1、声明相关参数
//    EventHotKeyRef myHotKeyRef;
//    EventHotKeyID myHotKeyID;
//    EventTypeSpec myEvenType;
//    myEvenType.eventClass = kEventClassKeyboard;    // 键盘类型
//    myEvenType.eventKind = kEventHotKeyPressed;     // 按压事件
//
//    // 2、定义快捷键
//    myHotKeyID.signature = 'yuus';  // 自定义签名
//    myHotKeyID.id = 4;              // 快捷键ID
//
//    // 3、注册快捷键
//    // 参数一：keyCode; 如18代表1，19代表2，21代表4，49代表空格键，36代表回车键
//    // 快捷键：command+4
//    RegisterEventHotKey(21, cmdKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
//
//    // 快捷键：command+option+4
//    //    RegisterEventHotKey(21, cmdKey + optionKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
//
//    // 5、注册回调函数，响应快捷键
//    InstallApplicationEventHandler(&hotKeyHandler, 1, &myEvenType, NULL, NULL);
//}


@end
