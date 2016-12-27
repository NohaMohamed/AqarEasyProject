//
//  UIPickerView+Type.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/6/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    aqarType=0,
    bathroomCounterType,
    bedroomCounterType,
    parkingCounterType,
     countriesCounterType,
     citiesCounterType,
     streetCounterType,
    contractType,
    carStationType,
    builtYearType,
    regionType,
    coinType
}PickerViewType;

@interface UIPickerView (Type)
@property (nonatomic) PickerViewType pickerViewType;

//@property (nonatomic) NSIndexPath *indexPathToDelete;

@end
