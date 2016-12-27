//
//  UISwipeGestureRecognizer+Extras.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/7/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    aqarType=0,
    bathroomCounterType,
    bedroomCounterType,
    parkingCounterType
}PickerViewType;


@interface  UISwipeGestureRecognizer (Extras)
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic) PickerViewType pickerViewType;

@end


