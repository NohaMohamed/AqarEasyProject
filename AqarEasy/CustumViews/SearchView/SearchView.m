//
//  SearchView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "SearchView.h"
#import "UIPickerView+Type.h"
#import "Utility.h"
#import "UITextField+PlaceHolder.h"
#import "APIControlManager.h"
#import "Constant.h"

@implementation SearchView

@synthesize areaSlider,priceSlider,aqarTypeTextField,bathroomCounterTextField,bedroomCounterTextField,parkingCounterTextField,isEmpty,countryTextField,cityTextField,streetTextFiled,aqarContractTextField;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
       
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
         
        // 2.Add as a subview
        [self addSubview:self.view];
        
       // UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNearByView:)];
        //[self.nearByView addGestureRecognizer:tapGR];
        
        // Set Border to nearByButton
        //self.nearByView.layer.borderWidth = 1.0;
        //self.nearByView.layer.borderColor = [UIColor brownColor].CGColor;
       // NSLog(@"===============%@",  NSStringFromCGRect(SCRL_holder.frame));
        //initalize range sliders of area and price
        [self initializeRangeSliders];
        
        //iniitalize picker views
        [self initializePickerViews];
        
    
        
        //get type of property from server
        
        [NSThread detachNewThreadSelector:@selector(getPickerViewsArrays) toTarget:self withObject:nil];
    }
    return self;
}

-(void)layoutSubviews{
    
    areaSlider.frame = self.areaRangeSliderView.bounds;
    [areaSlider resetFrame:areaSlider.frame];
    
    priceSlider.frame = self.priceRangeSliderView.bounds;
    [priceSlider resetFrame:priceSlider.frame];
    
}

-(void)initializePickerViews{
    
    aqarTypeArray=[NSArray new];
    countriesCounterArray=[NSArray new];
    citiesCounterArray=[NSArray new];
    streetsCounterArray=[NSArray new];
    
   // _SRbathrooms=@"1";
   // _SRbedrooms=@"1";
    _SRprice_from=@"10000";
    _SRprice_to=@"10000000";
    
        
    
    // Initialize aqarTypePickerView
    aqarTypePickerView = [[UIPickerView alloc]init];
    aqarTypePickerView.dataSource = self;
    aqarTypePickerView.delegate = self;
    aqarTypePickerView.showsSelectionIndicator = YES;
    aqarTypePickerView.pickerViewType = aqarType;
    aqarTypeTextField.inputView = aqarTypePickerView;
    
    
    // Initialize aqarTypePickerView
    aqarContractTypePickerView = [[UIPickerView alloc]init];
    aqarContractTypePickerView.dataSource = self;
    aqarContractTypePickerView.delegate = self;
    aqarContractTypePickerView.showsSelectionIndicator = YES;
    aqarContractTypePickerView.pickerViewType = contractType;
    aqarContractTypeArray=@[@"بيع",@"ايجار"];
    aqarContractTextField.inputView = aqarContractTypePickerView;
    
    // Initialize bathroomCounterPickerView
    bathroomCounterPickerView = [[UIPickerView alloc]init];
    bathroomCounterPickerView.dataSource = self;
    bathroomCounterPickerView.delegate = self;
    bathroomCounterPickerView.showsSelectionIndicator = YES;
    bathroomCounterPickerView.pickerViewType = bathroomCounterType;
    bathroomCounterArray = @[@"",@"1",@"2",@"3",@"4",@"5",@"+6"];
    bathroomCounterTextField.inputView = bathroomCounterPickerView;
    
    // Initialize bedroomCounterPickerView
    bedroomCounterPickerView = [[UIPickerView alloc]init];
    bedroomCounterPickerView.dataSource = self;
    bedroomCounterPickerView.delegate = self;
    bedroomCounterPickerView.showsSelectionIndicator = YES;
    bedroomCounterPickerView.pickerViewType = bedroomCounterType;
    bedroomCounterArray = @[@"",@"1",@"2",@"3",@"4",@"5",@"+6"];
    bedroomCounterTextField.inputView = bedroomCounterPickerView;
    
    // Initialize parkingCounterPickerView
    parkingCounterPickerView = [[UIPickerView alloc]init];
    parkingCounterPickerView.dataSource = self;
    parkingCounterPickerView.delegate = self;
    parkingCounterPickerView.showsSelectionIndicator = YES;
    parkingCounterPickerView.pickerViewType = parkingCounterType;
    parkingCounterArray = @[@"",@"1",@"2",@"3",@"4",@"5",@"+6"];
    parkingCounterTextField.inputView = parkingCounterPickerView;
    
    //initialize countries picker view
    countriesCounterPickerView = [[UIPickerView alloc]init];
    countriesCounterPickerView.dataSource = self;
    countriesCounterPickerView.delegate = self;
    countriesCounterPickerView.showsSelectionIndicator = YES;
    countriesCounterPickerView.pickerViewType = countriesCounterType;
    countryTextField.inputView = countriesCounterPickerView;
    
    //init picker for cities
    citiesCounterPickerView = [[UIPickerView alloc]init];
    citiesCounterPickerView.dataSource = self;
    citiesCounterPickerView.delegate = self;
    citiesCounterPickerView.showsSelectionIndicator = YES;
    citiesCounterPickerView.pickerViewType = citiesCounterType;
    self.cityTextField.inputView = citiesCounterPickerView;
    
    //init for streets
    streetCounterPickerView = [[UIPickerView alloc]init];
    streetCounterPickerView.dataSource = self;
    streetCounterPickerView.delegate = self;
    streetCounterPickerView.showsSelectionIndicator = YES;
    streetCounterPickerView.pickerViewType = streetCounterType;
    self.streetTextFiled.inputView = streetCounterPickerView;
    
}

-(void)initializeRangeSliders{
    
    //initialize area slider
    areaSlider = [[RangeSlider alloc] initWithFrame:self.areaRangeSliderView.bounds];
    areaSlider.minimumValue = 1;
    areaSlider.selectedMinimumValue = 1;
    areaSlider.maximumValue = 10;
    areaSlider.selectedMaximumValue = 10;
    areaSlider.minimumRange = 2;
    [areaSlider addTarget:self action:@selector(updateAreaRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [self.areaRangeSliderView addSubview:areaSlider];
    
    //initialize price slider
    priceSlider = [[RangeSlider alloc] initWithFrame:self.priceRangeSliderView.bounds];
    priceSlider.minimumValue = 1;
    priceSlider.selectedMinimumValue = 1;
    priceSlider.maximumValue = 10;
    priceSlider.selectedMaximumValue = 10;
    priceSlider.minimumRange = 2;
    [priceSlider addTarget:self action:@selector(updatePriceRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [self.priceRangeSliderView addSubview:priceSlider];
}

-(void)getPickerViewsArrays{
    
    [self getDatafromServerWithtype:type andParent:@"0" andDifeerType:nil];
    [self getDatafromServerWithtype:location andParent:@"0" andDifeerType:nil];
    
   
}


-(void)getDatafromServerWithtype:(Taxonomy)taxsonomyType andParent:(NSString*)parent andDifeerType:(NSString*)differ{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility showLoading];
    
    });
    
    [[APIControlManager sharedInstance]getTreewithVId:taxsonomyType andParent:parent withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
       
        switch (taxsonomyType) {
            case type:
                aqarTypeArray = resultArray;
                
                break;
            case location:
                
                if ([differ isEqualToString:@"cities"]) {
                    citiesCounterArray=resultArray;
                    
                } else if([differ isEqualToString:@"streets"]) {
                    streetsCounterArray=resultArray;
                    
                }else{
                    countriesCounterArray=resultArray;
                }
                
                break;
                
            default:
                break;
        }
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
           if(!errorMessage)[self updateView:errorMessage];
            else  [Utility hideLoading];
        });
        
    }];
}

-(void)updateAreaRangeLabel:(RangeSlider *)slider{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *max = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMaximumValue*1000]];
    
    NSString *min = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMinimumValue*100]];
    //min= [min stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //max= [max stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSString *area=[NSString stringWithFormat:@" المساحه من%0.0f الي%0.0f م٢", slider.selectedMinimumValue*100, slider.selectedMaximumValue*10000 ];
    
    
    LBL_area.text=[NSString stringWithFormat:@"المساحه من %@ الى %@  م٢",min,max];
    
}

-(void)updatePriceRangeLabel:(RangeSlider *)slider{
    
    //Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.currencyCode=@"USD";
   
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *max = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMaximumValue*1000000]];
    
    NSString *min = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMinimumValue*10000]];
   //min= [min stringByReplacingOccurrencesOfString:@"$" withString:@""];
     //max= [max stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *price=[NSString stringWithFormat:@"السعر من  %@ الى %@ دولار", min, max];
    LBL_price.text=price;
    
    _SRprice_from=min;
    _SRprice_to=max;
    
}

- (void)showNearByView:(UITapGestureRecognizer *)recognizer {
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"NearByButtonPressed" object:nil];
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  
    switch (pickerView.pickerViewType) {
        case aqarType:
            return [aqarTypeArray count];
        case contractType:
            return [aqarContractTypeArray count];
        case bathroomCounterType:
            return [bathroomCounterArray count];
        case bedroomCounterType:
            return[bedroomCounterArray count];
        case parkingCounterType:
            return [parkingCounterArray count];
        case countriesCounterType:
            return countriesCounterArray.count;
        case citiesCounterType:
            return citiesCounterArray.count;
        case streetCounterType:
            return streetsCounterArray.count;
        default:
            return 0;
    }
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (pickerView.pickerViewType) {
        case aqarType:
            if (aqarTypeArray.count>row) {
                [aqarTypeTextField setText:aqarTypeArray[row][@"name"]];
                _SRtype = aqarTypeArray[row][@"tid"];
            }
           
//            [aqarTypeTextField resignFirstResponder];
            break;
        case contractType:{
            [aqarContractTextField setText:[aqarContractTypeArray objectAtIndex:row]];
            _SRcontract_type = (row==0)?659:658;
            break;
        }
        case bathroomCounterType:
            [bathroomCounterTextField setText:[bathroomCounterArray objectAtIndex:row]];
           // _SRbathrooms=[bathroomCounterArray objectAtIndex:row];
             _SRbathrooms=[NSString stringWithFormat:@"%d",[[bathroomCounterArray objectAtIndex:row] intValue]];
//            [bathroomCounterTextField resignFirstResponder];
            break;
        case bedroomCounterType:
            [bedroomCounterTextField setText:[bedroomCounterArray objectAtIndex:row]];
            //_SRbedrooms=[bedroomCounterArray objectAtIndex:row];
            _SRbedrooms=[NSString stringWithFormat:@"%d",[[bedroomCounterArray objectAtIndex:row] intValue]];
//            [bedroomCounterTextField resignFirstResponder];
            break;
        case parkingCounterType:
            [parkingCounterTextField setText:[parkingCounterArray objectAtIndex:row]];
//            [parkingCounterTextField resignFirstResponder];
            break;
        case countriesCounterType:
            if (countriesCounterArray.count>row) {
                countryTextField.text=countriesCounterArray[row][@"name"];
                _SRregion=countriesCounterArray[row][@"tid"];
                [self textFieldWillBeginEditing:cityTextField];
                [cityTextField becomeFirstResponder];
            }
            
            break;
           
        case citiesCounterType:
            if (citiesCounterArray.count>row) {
                self.cityTextField.text=citiesCounterArray[row][@"name"];
                _SCountry=citiesCounterArray[row][@"tid"];
                [self textFieldWillBeginEditing:streetTextFiled];
                [streetTextFiled becomeFirstResponder];
            }
         
            break;
        
        case streetCounterType:
            if (streetsCounterArray.count>row) {
                self.streetTextFiled.text=streetsCounterArray[row][@"name"];
                _SCity=streetsCounterArray[row][@"tid"];
            }
          
            break;
            
        default:
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.pickerViewType) {
        case contractType:
            return aqarContractTypeArray[row];
        case aqarType:
            return aqarTypeArray[row][@"name"];
        case bathroomCounterType:
            return [bathroomCounterArray objectAtIndex:row];
        case bedroomCounterType:
            return [bedroomCounterArray objectAtIndex:row];
        case parkingCounterType:
            return [parkingCounterArray objectAtIndex:row];
        case countriesCounterType:
            return countriesCounterArray[row][@"name"];
        case citiesCounterType:
            return citiesCounterArray[row][@"name"];
        case streetCounterType:
            return streetsCounterArray[row][@"name"];
        default:
            return @"";
    }
}


- (void)listSubviewsOfView:(UIView *)view {
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0)
        return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            //if([textField.text length]==0&& (textField.tag != 885)&&(textField.tag !=886)&&(textField.tag !=889))
            if([textField.text length]==0&& (textField.tag == 885))
            {
                isEmpty = YES;
                NSLog(@"Please fill...");
                textField.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];// [UIColor redColor];
            }
            else{
                textField.backgroundColor = [UIColor clearColor];
            }
        }
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
    
}
-(BOOL)validation{
    isEmpty = NO;
    [self listSubviewsOfView:self.view];
    if(isEmpty)
        [Utility showAlert:@"" message:@"الرجاء تعبئة البيانات في الخانات الملونة باللون الاحمر"];
    return !isEmpty;
}

-(void)updateView:(NSString*) errorMessage{
    
    if(errorMessage != nil)
    {
        [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة أخرى"];
    }
    
    [_overlayView setHidden:YES];
    
    [aqarTypePickerView reloadAllComponents];
    [countriesCounterPickerView reloadAllComponents];
    [citiesCounterPickerView reloadAllComponents];
    [streetCounterPickerView reloadAllComponents];

    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility hideLoading];
        
    });
    
}

#pragma - mark
#pragma - mark textfileds delegates
-(void)textFieldWillBeginEditing:(UITextField *)textField{
    
    if (textField==countryTextField&&countriesCounterArray.count <1 ) {
         [self getDatafromServerWithtype:location andParent:@"0" andDifeerType:nil];

    }else if (textField==cityTextField){
        NSInteger selectedrow=[countriesCounterPickerView selectedRowInComponent:0];
        if (selectedrow >=0) {
            NSDictionary *dic=countriesCounterArray[selectedrow];
            [self getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:@"cities"];
        } else {
            [Utility showAlert:@"عفواً" message:@"من فضلك اختر المنطقة"];
        }
        
    }else if (textField==streetTextFiled){
        NSInteger selectedrow=[citiesCounterPickerView selectedRowInComponent:0];
        if (selectedrow >=0) {
            NSDictionary *dic=citiesCounterArray[selectedrow];
            [self getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:@"streets"];
        } else {
            [Utility showAlert:@"عفواً" message:@"من فضلك اختر الدولة"];
        }
        
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
