//
//  PropertyInfoViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "PropertyModel.h"
#import "LocationViewController.h"
#import "MapView.h"
#import "AqarView.h"
#import "AdvertiserView.h"

@import MessageUI.MFMailComposeViewController;
@import MessageUI.MFMessageComposeViewController;

enum selectedSegment{
    locationSelected=0,
    mapSelected,
    aqarSelected
};

@interface PropertyInfoViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    
    __weak IBOutlet UIScrollView *imageContainerScrollView;
    __weak IBOutlet UIView *ViewHolder;
    __weak IBOutlet NSLayoutConstraint *Constr_bottom;
    __weak IBOutlet NSLayoutConstraint *Constr_viewParentHeight;
    
    __weak IBOutlet NSLayoutConstraint *Constr_nearByHeight;
    __weak IBOutlet UIImageView *IMGV_imgAqar;
    __weak IBOutlet UILabel *LBL_imagesNum;
    __weak IBOutlet UILabel *LBL_aqarLocation;
    
    __weak IBOutlet UITableView *TBL_aqarInfo;
    
    __weak IBOutlet UILabel *LBL_aqarDisc;
    
    __weak IBOutlet NSLayoutConstraint *Constr_showMore;
    __weak IBOutlet UIView *View_highway;
    __weak IBOutlet UIView *View_highwayVal;
    __weak IBOutlet UILabel *LBL_highwayVal;

    __weak IBOutlet UIView *View_airport;
    __weak IBOutlet UIView *View_airportVal;
    __weak IBOutlet UILabel *LBL_airportVal;
    
    __weak IBOutlet UIView *View_midtown;
    __weak IBOutlet UIView *View_midtownVal;
    __weak IBOutlet UILabel *LBL_midtownVal;

    __weak IBOutlet MKMapView *MAP_aqarLoc;
    
    
     __weak IBOutlet UIView *View_NearByServicesHolder;
     __weak IBOutlet UIView *View_NearByServices;
    
    __weak IBOutlet AdvertiserView *__AdvertiserView;

    
    
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong,nonatomic)PropertyModel * propertyModel;

@property(strong,nonatomic)LocationViewController * locationViewController;
- (IBAction)showMore:(id)sender;
- (IBAction)openInGoogleNavigator:(id)sender;

- (IBAction)back:(id)sender;
//-(void)initializeSegmentControl;
//-(void)initializePropertyView:(NSInteger)segmentIndex;
@end
