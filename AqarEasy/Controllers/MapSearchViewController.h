//
//  MapSearchViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/27/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewiPhone.h"
#import "MapView.h"


@interface MapSearchViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIView *overlaySummaryView;

- (IBAction)searchButton:(id)sender;
@property (weak, nonatomic) IBOutlet SummaryViewiPhone *summaryViewiPhone;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *overlaymMapView;

//- (void)showPropertyInfo:(UITapGestureRecognizer *)recognizer;
-(void)initializeLocationServices;
@end
