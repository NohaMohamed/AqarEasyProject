//
//  UISwipeGestureRecognizer+Extras.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/7/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "UISwipeGestureRecognizer+Extras.h"
#import <objc/runtime.h>

static char const * const Key = "oKey";

@implementation UISwipeGestureRecognizer (Extras)
@dynamic tag,pickerViewType;

- (void) setTag:(NSInteger)tag
{
    objc_setAssociatedObject(self,
                             Key,
                             (id)@(tag),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)tag
{
    return (NSInteger)objc_getAssociatedObject(self, Key);
}

-(void)setPickerViewType:(PickerViewType)pickerViewType{
    objc_setAssociatedObject(self,
                             Key,
                             (id)@(pickerViewType),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(PickerViewType)pickerViewType{
     return (PickerViewType)objc_getAssociatedObject(self, Key);
}

@end
