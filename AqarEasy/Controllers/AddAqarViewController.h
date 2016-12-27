//
//  AddAqarViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/17/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
#import "AddAqarView.h"
#import "AssetsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "AZDraggableAnnotationView.h"
#import "MapView.h"

@interface AddAqarViewController : UIViewController
<UIKeyboardViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AssetsViewControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate, UIGestureRecognizerDelegate, AZDraggableAnnotationViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIKeyboardViewController *keyBoardController;
    NSMutableArray *attachedImages;
    
    CLLocationManager *locationManager;
    MKPointAnnotation *annotation;
    MapView * mapview;
    CLLocationCoordinate2D propertyLocation;
    CLLocationCoordinate2D selectedLocation;
    
    
     IBOutletCollection(UIView) NSArray *VIEWS_SERVICES;
    
    __weak IBOutlet UISegmentedControl *SegmCarStation;
    __weak IBOutlet UISegmentedControl *SegmContractType;
    
    IBOutletCollection(UIView) NSArray *VIEWS;
    
    __weak IBOutlet UILabel *LBL_errorImageNum;
    __weak IBOutlet UILabel *LBL_imagesNum;
    __weak IBOutlet UILabel *LBL_region;
    __weak IBOutlet UILabel *LBL_countries;
    __weak IBOutlet UILabel *LBL_city;
    __weak IBOutlet UILabel *LBL_street;
    
    __weak IBOutlet UIButton *BTN_setLocFromMap;
    __weak IBOutlet UIButton *BTN_CurrentLocation;
    
    __weak IBOutlet UILabel *LBL_aqarType;
    __weak IBOutlet UIButton *BTN_coin;
    
    __weak IBOutlet UILabel *LBL_bedRoomCount;
    
    __weak IBOutlet UILabel *LBL_bathRoomCount;
    __weak IBOutlet UICollectionView *ThumbCollection;
    
    __weak IBOutlet UITextField *TXT_address;
    __weak IBOutlet UITextField *TXT_price;
    __weak IBOutlet UITextField *TXT_area;
    __weak IBOutlet UITextField *TXT_desc;
    __weak IBOutlet UITextField *TXT_Buildyear;
    __weak IBOutlet UITextField *TXT_distanceToAirport;
    __weak IBOutlet UITextField *TXT_distanceMidTown;
    __weak IBOutlet UITextField *TXT_distanceToHighWay;
    



}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property(nonatomic,strong) NSString *nodeId;

- (IBAction)chooseContractType:(id)sender;


- (IBAction)addAqar:(id)sender;
- (IBAction)chooseCoin:(id)sender;

- (IBAction)takePicture:(id)sender;
- (IBAction)chooseLocationFromMap:(id)sender;
- (IBAction)ChooseCurrentLocation:(id)sender;

- (IBAction)chooseAqarType:(id)sender;

@end
