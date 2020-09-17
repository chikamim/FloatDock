//
//  NSParameterName.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/5/2.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "NSParameterName.h"

#import <objc/runtime.h>

@implementation NSParameterName

+ (NSString *)entity:(id _Nullable)entity equalTo:(id)compareValue {
    NSString * parameterName;
    
    unsigned propertyCount;
    
    objc_property_t *properties = class_copyPropertyList([entity class],&propertyCount);
    for(int i=0;i<propertyCount;i++){
        NSString * propNameString;
        NSString * propAttributesString;
        
        objc_property_t prop=properties[i];
        
        const char *propName = property_getName(prop);
        propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        const char * propAttributes=property_getAttributes(prop);
        propAttributesString =[NSString stringWithCString:propAttributes encoding:NSASCIIStringEncoding];
        
        id value = [entity valueForKey:propNameString];
        if ([value isEqualTo:compareValue]) {
            //NSLog(@"NSParameterName %@ : %@", propNameString, value);
            parameterName = propNameString;
            break;
        }
    } // end for.
    free(properties);
    
    return parameterName;
}

@end
