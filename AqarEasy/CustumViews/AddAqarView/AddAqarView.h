//
//  AddAqarView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/17/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyModel.h"
@protocol AddAqarViewDelegate <NSObject>

-(void)takePhoto;
-(void)openGallery;
-(void)getCurrentLocation;
-(void)setLocationfromMap;

@end

@interface AddAqarView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *aqarTypePickerView;
    UIPickerView *contractTypePickerView;
    UIPickerView *builtYearPickerView;
   
    UIPickerView *bathroomCounterPickerView;
    UIPickerView *bedroomCounterPickerView;
    UIPickerView *coinPickerView;

    UIPickerView *regionPickerView;
    UIPickerView *countryPickerView;
    UIPickerView *cityPickerView;
    UIPickerView *streetPickerView;
    UIPickerView *carStationPickerView;
    
    NSMutableArray *regionArray;
    NSMutableArray *countriesArray;
    NSMutableArray *citiesArray;
    NSMutableArray *streetsArray;
    NSArray *carStationArray;

    NSArray *contractTypeArray;
    NSArray *aqarTypeArray;
    NSMutableArray *builtYearArray;
    NSArray *bathroomCounterArray;
    NSArray *bedroomCounterArray;
    NSArray *coinArray;
    __weak IBOutlet UIScrollView *SCRL_holder;
    
    BOOL isEmpty;
}
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak,nonatomic)id <AddAqarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *carStationTextField;
@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;


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
@property(nonatomic,strong) NSString*countryId;
@property(nonatomic,strong) NSString*cityId;
@property(nonatomic,strong) NSString*streetId;
@property(nonatomic,strong) NSString *regionId;
@property(nonatomic,strong) NSString *carSationValue;

@property (weak, nonatomic) IBOutlet UICollectionView *ThumbCollection;


@property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToHighway;

@property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToMidTown;

@property (weak, nonatomic) IBOutlet UITextField *TXT_distanceToAirPort;
@property(nonatomic,strong)NSString*currency;
@property(nonatomic,assign)BOOL editAqar;

-(BOOL)validation;
- (IBAction)getCurrentLocationButton:(id)sender;
- (IBAction)setLocationButton:(id)sender;


- (IBAction)takePhoto:(id)sender;
- (IBAction)openGallery:(id)sender;

-(void)setAqarInfo:(PropertyModel*)model;

@end
