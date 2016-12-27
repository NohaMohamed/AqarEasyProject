//
//  MainViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "HMSegmentedControl.h"
#import "PropertyModel.h"
#import "AddAqarViewController.h"
#import <CoreLocation/CoreLocation.h>

enum selectedSegmentinMainScreen{
    nearBySelected =0,
    mostViewedSelected,
    latestPropertySelected
    
};

@interface MainViewController : UIViewController <SWRevealViewControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * propertyArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)initializeSegmentControl;

@end
