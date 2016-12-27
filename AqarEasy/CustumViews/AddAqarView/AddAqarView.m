//
//  AddAqarView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/17/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AddAqarView.h"
#import "UITextField+PlaceHolder.h"
#import "UIPickerView+Type.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "PropertyModel.h"
#import "Constant.h"
#import "Utility.h"
//#import "lelib.h"

@implementation AddAqarView
@synthesize aqarTypeTextField,contractTypeTextField,builtYearTextField,countryTextField,bathroomCounterTextField,bedroomCounterTextField,coinTextField;

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
        [[NSBundle mainBundle] loadNibNamed:@"AddAqarView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
        
        //set border of setLocationButton
        self.setLocationButton.layer.borderWidth = 1.0;
        self.setLocationButton.layer.borderColor = [UIColor brownColor].CGColor;
        
        //set border of currentLocationButton
        self.currentLocationButton.layer.borderWidth = 1.0;
        self.currentLocationButton.layer.borderColor = [UIColor brownColor].CGColor;
        
        
        //iniitalize picker views
        [self initializePickerViews];
        
        //get location,type and contract types from server
        [self getDatafromServerWithTaxsonomy:location andParent:@"0"];
        [self getCurrentLocationButton:nil];
    }
    return self;
}

-(void)initializePickerViews{
    self.countryId=@"";
    self.cityId=@"";
    self.carSationValue=@"";
    // Initialize aqarTypePickerView
    aqarTypePickerView = [[UIPickerView alloc]init];
    aqarTypePickerView.dataSource = self;
    aqarTypePickerView.delegate = self;
    aqarTypePickerView.showsSelectionIndicator = YES;
    aqarTypePickerView.pickerViewType = aqarType;
    aqarTypeTextField.inputView = aqarTypePickerView;
    
    // Initialize contractTypePickerView
    contractTypePickerView = [[UIPickerView alloc]init];
    contractTypePickerView.dataSource = self;
    contractTypePickerView.delegate = self;
    contractTypePickerView.showsSelectionIndicator = YES;
    contractTypePickerView.pickerViewType = contractType;
    contractTypeTextField.inputView = contractTypePickerView;
   
    
    // Initialize carStationPickerView
    carStationPickerView = [[UIPickerView alloc]init];
    carStationPickerView.dataSource = self;
    carStationPickerView.delegate = self;
    carStationPickerView.showsSelectionIndicator = YES;
    carStationPickerView.pickerViewType = carStationType;
    _carStationTextField.inputView = carStationPickerView;
    carStationArray = @[@{@"key":@"نعم",@"val":@"yes"},@{@"key":@"لا",@"val":@"no"}];
    
    [_carStationTextField setText:@"نعم"];
    _carSationValue=@"yes";
    
    // Initialize builtYearPickerView
    builtYearPickerView = [[UIPickerView alloc]init];
    builtYearPickerView.dataSource = self;
    builtYearPickerView.delegate = self;
    builtYearPickerView.showsSelectionIndicator = YES;
    builtYearPickerView.pickerViewType = builtYearType;
    
    //Get Current Year into currentYear
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
   // [[LELog sharedInstance] log:@"start==============================="];
    //[[LELog sharedInstance] log:[NSString stringWithFormat:@"date from user device=============%@",[[NSDate date] description]]];
    //[[LELog sharedInstance] log:formatter];
    
    int currentYear  = [[formatter stringFromDate:[NSDate date]] intValue];
    //[[LELog sharedInstance] log:@(currentYear)];
    
    if (currentYear <2015) {
        currentYear=2015;
    }
    
    //[[LELog sharedInstance] log:@"end==================================="];
    //Create Years Array from 1960 to This year
    builtYearArray = [[NSMutableArray alloc]init];
    [builtYearArray addObject:@""];
    for (int i=1960; i<=currentYear; i++) {
        [builtYearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    builtYearTextField.inputView = builtYearPickerView;
    
    // Initialize regionPickerview
    regionPickerView = [[UIPickerView alloc]init];
    regionPickerView.dataSource = self;
    regionPickerView.delegate = self;
    regionPickerView.showsSelectionIndicator = YES;
    regionPickerView.pickerViewType = regionType;
    _regionTextField.inputView = regionPickerView;
    
    // Initialize countryPickerView
    countryPickerView = [[UIPickerView alloc]init];
    countryPickerView.dataSource = self;
    countryPickerView.delegate = self;
    countryPickerView.showsSelectionIndicator = YES;
    countryPickerView.pickerViewType = countriesCounterType;
    countryTextField.inputView = countryPickerView;
    
    // Initialize cityPickerView
    cityPickerView = [[UIPickerView alloc]init];
    cityPickerView.dataSource = self;
    cityPickerView.delegate = self;
    cityPickerView.showsSelectionIndicator = YES;
    cityPickerView.pickerViewType = citiesCounterType;
    _cityTextField.inputView = cityPickerView;
    
    
    // Initialize streetPickerView
    streetPickerView = [[UIPickerView alloc]init];
    streetPickerView.dataSource = self;
    streetPickerView.delegate = self;
    streetPickerView.showsSelectionIndicator = YES;
    streetPickerView.pickerViewType = streetCounterType;
    _streetTextField.inputView = streetPickerView;
    
    
    
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
    
    // Initialize coinPickerView
    coinPickerView = [[UIPickerView alloc]init];
    coinPickerView.dataSource = self;
    coinPickerView.delegate = self;
    coinPickerView.showsSelectionIndicator = YES;
    coinPickerView.pickerViewType = coinType;
   // coinArray = @[@"ريال سعودي",@"دولار أمريكي"];
    coinArray=@[@{@"name":@"ريال سعودي",@"tid":@"SAR"},@{@"name":@"دولار أمريكي",@"tid":@"USD"},@{@"name":@"يورو",@"tid":@"EUR"}];
    coinTextField.inputView = coinPickerView;
    
}

-(void)getDatafromServerWithTaxsonomy:(Taxonomy)Ttype andParent:(NSString*)parent{
    
    contractTypeArray=@[@{@"name":@"ايجار",@"tid":@"658"},@{@"name":@"بيع",@"tid":@"659"}];
    //aqarTypeArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AqarType" ofType:@"plist"]];
   
    
    
    [Utility showLoading];

    
    [[APIControlManager sharedInstance]getTreewithVId:Ttype andParent:parent withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
        
        regionArray = resultArray;
//        NSLog(@"locationArrayCount: %li",[locationArray count]);
        if(errorMessage == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIControlManager sharedInstance]getTreewithVId:type andParent:@"0" withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
                    aqarTypeArray = resultArray;
                    //                NSLog(@"aqarTypeArrayCount: %li",[aqarTypeArray count]);
                     if(errorMessage == nil)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if(errorMessage == nil)
                             {
                                 
                                 [Utility hideLoading];
                             }
                             else{
                                 [Utility showAlert:@"عفوا" message:errorMessage];
                                 [Utility hideLoading];
                             }
                         });
                      
                }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة أخرى"];
                     [Utility hideLoading];
                     });
                 }
                }];
            });

        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
             [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة أخرى"];
            [Utility hideLoading];
                 });
        }
            }];
    
 
}


-(void)getDatafromServerWithtype:(Taxonomy)taxsonomyType andParent:(NSString*)parent andDifeerType:(NSString*)differ{
    [Utility showLoading];
    
    [[APIControlManager sharedInstance]getTreewithVId:taxsonomyType andParent:parent withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
        
        switch (taxsonomyType) {
                
            case location:
                
                if ([differ isEqualToString:@"cities"]) {
                    citiesArray=resultArray;
                    
                } else if([differ isEqualToString:@"streets"]) {
                    streetsArray=resultArray;
                    
                }else{
                    countriesArray=resultArray;
                }
                
                break;
                
            default:
                break;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView:errorMessage];
        });
        
    }];
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
            return [contractTypeArray count];
        case builtYearType:
            return [builtYearArray count];
        case regionType:
            return [regionArray count];
        case countriesCounterType:
            return [countriesArray count];
        case citiesCounterType:
            return [citiesArray count];
        case streetCounterType:
            return [streetsArray count];
        case bathroomCounterType:
            return [bathroomCounterArray count];
        case bedroomCounterType:
            return[bedroomCounterArray count];
        case coinType:
            return[coinArray count];
        case carStationType:
            return [carStationArray count];
        default:
            return 0;
    }
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (pickerView.pickerViewType) {
        case aqarType:
            aqarTypeTextField.text=aqarTypeArray[row][@"name"];
            _aqarTypeId=aqarTypeArray[row][@"tid"];
            break;
        case contractType:
            contractTypeTextField.text=contractTypeArray[row][@"name"];
            _contractTypeId=contractTypeArray[row][@"tid"];
            break;
        case builtYearType:
            [builtYearTextField setText:[builtYearArray objectAtIndex:row]];
            break;
        case regionType:
            _regionTextField.text=regionArray[row][@"name"];
            _regionId=regionArray[row][@"tid"];
            [self getDatafromServerWithtype:location andParent:regionArray[row][@"tid"] andDifeerType:@"country"];
            break;
            
        case countriesCounterType:
            countryTextField.text=countriesArray[row][@"name"];
            _countryId=countriesArray[row][@"tid"];
            [self getDatafromServerWithtype:location andParent:countriesArray[row][@"tid"] andDifeerType:@"cities"];
            break;
            
        case citiesCounterType:
            _cityTextField.text=citiesArray[row][@"name"];
            _cityId=citiesArray[row][@"tid"];
            [self getDatafromServerWithtype:location andParent:citiesArray[row][@"tid"] andDifeerType:@"streets"];
            break;
        case streetCounterType:
            _streetTextField.text=streetsArray[row][@"name"];
            _streetId=streetsArray[row][@"tid"];
            break;
            
        case bathroomCounterType:
            [bathroomCounterTextField setText:[bathroomCounterArray objectAtIndex:row]];
            break;
        case bedroomCounterType:
            [bedroomCounterTextField setText:[bedroomCounterArray objectAtIndex:row]];
            break;
        case coinType:
            [coinTextField setText:coinArray[row][@"name"]];
            _currency=coinArray[row][@"tid"];
            break;
        case carStationType:
            [_carStationTextField setText:carStationArray[row][@"key"]];
            _carSationValue=carStationArray[row][@"val"];
            break;
        default:
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.pickerViewType) {
        case aqarType:
            return [aqarTypeArray objectAtIndex:row][@"name"];
        case contractType:
            return [contractTypeArray objectAtIndex:row][@"name"];
        case builtYearType:
            return [builtYearArray objectAtIndex:row];
        case regionType:
            return [regionArray objectAtIndex:row][@"name"];
        case countriesCounterType:
            return [countriesArray objectAtIndex:row][@"name"];
        case citiesCounterType:
            return [citiesArray objectAtIndex:row][@"name"];
        case streetCounterType:
            return [streetsArray objectAtIndex:row][@"name"];
        case bathroomCounterType:
            return [bathroomCounterArray objectAtIndex:row];
        case bedroomCounterType:
            return [bedroomCounterArray objectAtIndex:row];
        case coinType:
            return [coinArray objectAtIndex:row][@"name"];
        case carStationType:
            return carStationArray[row][@"key"];
        default:
            return @"";
    }
}

// open camera and take a photo
- (IBAction)takePhoto:(id)sender {
    [_delegate takePhoto];
}

- (IBAction)openGallery:(id)sender {
    [_delegate openGallery];
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
            if([textField.text length]==0&&textField.tag==70&&self.editAqar==NO){
                isEmpty = YES;
                NSLog(@"Please fill...");
                if([subviews[0] isKindOfClass:[UILabel class]])
                {
                   UILabel *label = (UILabel *)[subviews objectAtIndex:0];
                    label.hidden = NO;
                }
            }
            else{
                if([subviews[0] isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)[subviews objectAtIndex:0];
                    label.hidden = YES;
                }
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
        [Utility showAlert:@"" message:@"ارجوا تعبئة البيانات التي امامها نجمة حمراء"];
    return !isEmpty;

}

- (IBAction)getCurrentLocationButton:(id)sender {
    [_delegate getCurrentLocation];
    
    //set border of setLocationButton
    self.setLocationButton.layer.borderWidth = 0.50;
    self.setLocationButton.layer.borderColor = [UIColor brownColor].CGColor;
    
    //set border of currentLocationButton
    self.currentLocationButton.layer.borderWidth = 3.0;
    self.currentLocationButton.layer.borderColor = [UIColor brownColor].CGColor;
    
    
}

- (IBAction)setLocationButton:(id)sender {
    [_delegate setLocationfromMap];
    //set border of setLocationButton
    self.setLocationButton.layer.borderWidth = 3.0;
    self.setLocationButton.layer.borderColor = [UIColor brownColor].CGColor;
    
    //set border of currentLocationButton
    self.currentLocationButton.layer.borderWidth = 0.5;
    self.currentLocationButton.layer.borderColor = [UIColor brownColor].CGColor;


}


-(void)updateView:(NSString*) errorMessage{
    
    if(errorMessage != nil)
    {
        [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة أخرى"];
    }
    
    [Utility hideLoading];
    
    [countryPickerView reloadAllComponents];
    [streetPickerView reloadAllComponents];
    [cityPickerView reloadAllComponents];
    
    [Utility hideLoading];
}

-(void)setAqarInfo:(PropertyModel*)model{

    
    
/*
 @property (weak, nonatomic) IBOutlet UITextField *areaTextField;
 @property (weak, nonatomic) IBOutlet UITextField *titleTextField;
 @property (weak, nonatomic) IBOutlet UITextField *priceTextField;
 @property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
 @property (weak, nonatomic) IBOutlet UITextField *regionTextField;>>>>>ask abu fahd
 @property (weak, nonatomic) IBOutlet UITextField *countryTextField;>>>>ask abu fahd
 @property (weak, nonatomic) IBOutlet UITextField *cityTextField;>>>>>>ask abu fahd
 @property (weak, nonatomic) IBOutlet UITextField *streetTextField;>>>>ask abu fahd
 
 
 @property (weak, nonatomic) IBOutlet UITextField *aqarTypeTextField;
 @property (weak, nonatomic) IBOutlet UITextField *contractTypeTextField;
 @property (weak, nonatomic) IBOutlet UITextField *builtYearTextField;
 @property (weak, nonatomic) IBOutlet UITextField *bathroomCounterTextField;
 @property (weak, nonatomic) IBOutlet UITextField *bedroomCounterTextField;
 @property (weak, nonatomic) IBOutlet UIButton *setLocationButton;
 @property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
 
 @property (weak, nonatomic) IBOutlet UILabel *LBL_counterImg;
 
 @property (weak, nonatomic) IBOutlet UILabel *addImagesErrorLabel;
 @property (weak, nonatomic) IBOutlet UILabel *starLabel;
 @property (weak, nonatomic) IBOutlet UITextField *coinTextField;
 
 @property(nonatomic,strong) NSString * contractTypeId;
 @property(nonatomic,strong) NSString * aqarTypeId;
 @property(nonatomic,strong)NSString*countryId;
 @property(nonatomic,strong)NSString*cityId;
 @property(nonatomic,strong)NSString*streetId;
 @property(nonatomic,strong)NSString *regionId;
 
 @property (weak, nonatomic) IBOutlet UICollectionView *ThumbCollection;
 
 
 @property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToHighway;
 
 @property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToMidTown;
 
 @property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToAirPort;
 @property(nonatomic,strong)NSString*currency;
 */
    
    NSLog(@"===============%@",  model.nodeTitle);
    NSLog(@"===============%@",  model.contract_type_id);
    
    
    _areaTextField.text=model.area;
    _titleTextField.text=model.nodeTitle;
    _priceTextField.text=model.price;
   // _descriptionTextField.text=model.nodeDescription;
    _regionId=model.regoin_id;
    aqarTypeTextField.text = model.aqarType;
    self.aqarTypeId=model.aqarTypeId;
    self.contractTypeTextField.text=model.contractType;
    self.contractTypeId=model.contract_type_id;
    self.builtYearTextField.text=model.yearBuilt;
    self.bathroomCounterTextField.text=model.bathroomCount;
    self.bedroomCounterTextField.text=model.bedroomCount;
    self.addImagesErrorLabel.hidden=YES;
    self.coinTextField.text=model.currencyName;
    self.currency=model.currencyId;
    self.TXT_distanceToAirPort.text=model.distanceLocationModel.distanceToAirport;
    self.TXT_distanceToHighway.text=model.distanceLocationModel.distanceToHighWay;
    self.TXT_distanceToMidTown.text=model.distanceLocationModel.distanceToDownTown;
    self.editAqar=YES;
    
    
}


@end
