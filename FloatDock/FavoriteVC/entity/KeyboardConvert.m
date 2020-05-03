//
//  KeyboardConvert.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/5/3.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "KeyboardConvert.h"

@implementation KeyboardConvert

// 键盘修饰符 https://www.jianshu.com/p/f46a5f5dfed7
+ (NSString *)convertFlag:(NSEventModifierFlags)flags {
    if (flags == 256) {
        return @"";
    }
    NSMutableString * flagsString = [NSMutableString new];
    if (flags & NSEventModifierFlagFunction) {
        [flagsString appendString:@"Fn"];
    }
    if (flags & NSEventModifierFlagShift) {
        [flagsString appendString:@"⇧"];
    }
    if (flags & NSEventModifierFlagControl) {
        [flagsString appendString:@"⌃"];
    }
    if (flags & NSEventModifierFlagOption) {
        [flagsString appendString:@"⌥"];
    }
    if (flags & NSEventModifierFlagCommand) {
        [flagsString appendString:@"⌘"];
    }
    return flagsString;
}

// 键盘字母符 https://blog.csdn.net/weixin_33862514/article/details/89664156
+ (NSString *)convertKeyboard:(int)keycode {
    NSString * str;
    switch (keycode) {
        case kVK_ANSI_A:{
            str = @"A";
            break;
        }
        case kVK_ANSI_B:{
            str = @"B";
            break;
        }
        case kVK_ANSI_C:{
            str = @"C";
            break;
        }
        case kVK_ANSI_D:{
            str = @"D";
            break;
        }
        case kVK_ANSI_E:{
            str = @"E";
            break;
        }
        case kVK_ANSI_F:{
            str = @"F";
            break;
        }
        case kVK_ANSI_G:{
            str = @"G";
            break;
        }
        case kVK_ANSI_H:{
            str = @"H";
            break;
        }
        case kVK_ANSI_I:{
            str = @"I";
            break;
        }
        case kVK_ANSI_J:{
            str = @"J";
            break;
        }
        case kVK_ANSI_K:{
            str = @"K";
            break;
        }
        case kVK_ANSI_L:{
            str = @"L";
            break;
        }case kVK_ANSI_M:{
            str = @"M";
            break;
        }
        case kVK_ANSI_N:{
            str = @"N";
            break;
        }
        case kVK_ANSI_O:{
            str = @"O";
            break;
        }
        case kVK_ANSI_P:{
            str = @"P";
            break;
        }
        case kVK_ANSI_Q:{
            str = @"Q";
            break;
        }
        case kVK_ANSI_R:{
            str = @"R";
            break;
        }
        case kVK_ANSI_S:{
            str = @"S";
            break;
        }
        case kVK_ANSI_T:{
            str = @"T";
            break;
        }
        case kVK_ANSI_U:{
            str = @"U";
            break;
        }
        case kVK_ANSI_V:{
            str = @"V";
            break;
        }
        case kVK_ANSI_W:{
            str = @"W";
            break;
        }
        case kVK_ANSI_X:{
            str = @"X";
            break;
        }
        case kVK_ANSI_Y:{
            str = @"Y";
            break;
        }
        case kVK_ANSI_Z:{
            str = @"Z";
            break;
        }
        case kVK_ANSI_0:{
            str = @"0";
            break;
        }
        case kVK_ANSI_1:{
            str = @"1";
            break;
        }
        case kVK_ANSI_2:{
            str = @"2";
            break;
        }
        case kVK_ANSI_3:{
            str = @"3";
            break;
        }
        case kVK_ANSI_4:{
            str = @"4";
            break;
        }
        case kVK_ANSI_5:{
            str = @"5";
            break;
        }
        case kVK_ANSI_6:{
            str = @"6";
            break;
        }
        case kVK_ANSI_7:{
            str = @"7";
            break;
        }
        case kVK_ANSI_8:{
            str = @"8";
            break;
        }
        case kVK_ANSI_9:{
            str = @"9";
            break;
        }
        case kVK_ANSI_Minus:{
            str = @"_";
            break;
        }
        case kVK_ANSI_Equal:{
            str = @"=";
            break;
        }
        case kVK_ANSI_LeftBracket:{
            str = @"[";
            break;
        }
        case kVK_ANSI_RightBracket:{
            str = @"]";
            break;
        }
        case kVK_ANSI_Semicolon:{
            str = @";";
            break;
        }
        case kVK_ANSI_Quote:{
            str = @"'";
            break;
        }
        case kVK_ANSI_Comma:{
            str = @",";
            break;
        }
        case kVK_ANSI_Period:{
            str = @".";
            break;
        }
        case kVK_ANSI_Slash:{
            str = @"/";
            break;
        }
        case kVK_ANSI_Backslash:{
            //str = @"/"; 删除
            break;
        }
        case kVK_Delete:{
            str = @"⌫";
            break;
        }
        case kVK_Escape: {
            str = @"Esc";
            break;
        }
            // F1 - F16
        case kVK_F1:{
            str = @"F1";
            break;
        }
        case kVK_F2:{
            str = @"F2";
            break;
        }
        case kVK_F3:{
            str = @"F3";
            break;
        }
        case kVK_F4:{
            str = @"F4";
            break;
        }
        case kVK_F5:{
            str = @"F5";
            break;
        }
        case kVK_F6:{
            str = @"F6";
            break;
        }
        case kVK_F7:{
            str = @"F7";
            break;
        }
        case kVK_F8:{
            str = @"F8";
            break;
        }
        case kVK_F9:{
            str = @"F9";
            break;
        }
        case kVK_F10:{
            str = @"F10";
            break;
        }
        case kVK_F11:{
            str = @"F11";
            break;
        }
        case kVK_F12:{
            str = @"F12";
            break;
        }
        case kVK_F13:{
            str = @"F13";
            break;
        }
        case kVK_F14:{
            str = @"F14";
            break;
        }
        case kVK_F15:{
            str = @"F15";
            break;
        }
        case kVK_F16:{
            str = @"F16";
            break;
        }
            // 数字键盘
        case kVK_ANSI_KeypadDecimal : {
            str = @"N.";
            break;
        }
        case kVK_ANSI_KeypadMultiply : {
            str = @"N*";
            break;
        }
        case kVK_ANSI_KeypadPlus : {
            str = @"N+";
            break;
        }
        case kVK_ANSI_KeypadClear : {
            str = @"NClear";
            break;
        }
        case kVK_ANSI_KeypadDivide : {
            str = @"N/";
            break;
        }
        case kVK_ANSI_KeypadEnter : {
            str = @"NEnter";
            break;
        }
        case kVK_ANSI_KeypadMinus : {
            str = @"N-";
            break;
        }
        case kVK_ANSI_KeypadEquals : {
            str = @"N=";
            break;
        }
        case kVK_ANSI_Keypad0 : {
            str = @"N0";
            break;
        }
        case kVK_ANSI_Keypad1 : {
            str = @"N1";
            break;
        }
        case kVK_ANSI_Keypad2 : {
            str = @"N2";
            break;
        }
        case kVK_ANSI_Keypad3 : {
            str = @"N3";
            break;
        }
        case kVK_ANSI_Keypad4 : {
            str = @"N4";
            break;
        }
        case kVK_ANSI_Keypad5 : {
            str = @"N5";
            break;
        }
        case kVK_ANSI_Keypad6 : {
            str = @"N6";
            break;
        }
        case kVK_ANSI_Keypad7 : {
            str = @"N7";
            break;
        }
        case kVK_ANSI_Keypad8 : {
            str = @"N8";
            break;
        }
        case kVK_ANSI_Keypad9 : {
            str = @"N9";
            break;
        }
            // other
        case kVK_Home: {
            str = @"Home";
            break;
        }
        case kVK_PageUp: {
            str = @"PageUp";
            break;
        }
        case kVK_ForwardDelete: {
            str = @"Delete";
            break;
        }
        case kVK_End: {
            str = @"End";
            break;
        }
        case kVK_PageDown: {
            str = @"PageDown";
            break;
        }
        case kVK_LeftArrow: {
            str = @"←";
            break;
        }
        case kVK_RightArrow: {
            str = @"→";
            break;
        }
        case kVK_DownArrow: {
            str = @"↓";
            break;
        }
        case kVK_UpArrow: {
            str = @"↑";
            break;
        }
            
        default:
            break;
    }
    //NSLog(@"转换 keycode: %i, str: %@", keycode, str);
    return str;
}
@end
