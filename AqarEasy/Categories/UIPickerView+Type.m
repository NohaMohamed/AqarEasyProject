//
//  UIPickerView+Type.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/6/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "UIPickerView+Type.h"
#import <objc/runtime.h>
static char const * const Key = "oKey";

@implementation UIPickerView (Type)
@dynamic pickerViewType;


-(void)setPickerViewType:(PickerViewType)pickerViewType{
    objc_setAssociatedObject(self,
                             Key,
                             (id)@(pickerViewType),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//-(PickerViewType)pickerViewType{
//    return (PickerViewType)objc_getAssociatedObject(self, Key);
//}

-(PickerViewType)pickerViewType{
    return (PickerViewType)((NSNumber *)objc_getAssociatedObject(self, Key)).intValue;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
