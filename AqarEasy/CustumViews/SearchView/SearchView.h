//
//  SearchView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RangeSlider.h"
#import "UIPickerView+Type.h"
#import "UIKeyboardViewController.h"

@interface SearchView : UIView <UIPickerViewDataSource,UIPickerViewDelegate,UIKeyboardViewControllerDelegate>
{    
    UIPickerView *aqarTypePickerView;
    UIPickerView *aqarContractTypePickerView;
    UIPickerView *bathroomCounterPickerView;
    UIPickerView *bedroomCounterPickerView;
    UIPickerView *parkingCounterPickerView;
    UIPickerView *countriesCounterPickerView;
    UIPickerView *citiesCounterPickerView;
    UIPickerView *streetCounterPickerView;
    
    
    NSArray *aqarTypeArray;
    NSArray *aqarContractTypeArray;
    
    NSArray *bathroomCounterArray;
    NSArray *bedroomCounterArray;
    NSArray *parkingCounterArray;
    
    NSArray *countriesCounterArray;
    NSArray *citiesCounterArray;
    NSArray *streetsCounterArray;
    
    __weak IBOutlet UIScrollView *SCRL_holder;
    __weak IBOutlet UILabel *LBL_area;
    
    __weak IBOutlet UILabel *LBL_price;
    
}
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextFiled;

//@property (weak, nonatomic) IBOutlet UIView *nearByView;
@property (weak, nonatomic) IBOutlet UIView *areaRangeSliderView;
@property (weak, nonatomic) IBOutlet UIView *priceRangeSliderView;

@property (strong,nonatomic) RangeSlider *areaSlider;
@property (strong,nonatomic) RangeSlider *priceSlider;
@property (weak, nonatomic) IBOutlet UITextField *aqarTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *aqarContractTextField;

@property (weak, nonatomic) IBOutlet UITextField *bathroomCounterTextField;
@property (weak, nonatomic) IBOutlet UITextField *bedroomCounterTextField;
@property (weak, nonatomic) IBOutlet UITextField *parkingCounterTextField;

//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (nonatomic)BOOL isEmpty;
//field to pass for search
@property(nonatomic)NSInteger SRcontract_type;
@property(nonatomic,strong)NSString *SRprice_from;
@property(nonatomic,strong)NSString *SRprice_to;
@property(nonatomic,strong)NSString *SRtype;
@property(nonatomic,strong)NSString *SRregion;
@property(nonatomic,strong)NSString *SCountry;
@property(nonatomic,strong)NSString *SCity;


@property(nonatomic,strong)NSString *SRbedrooms;
@property(nonatomic,strong)NSString *SRbathrooms;

-(BOOL)validation;


@end
