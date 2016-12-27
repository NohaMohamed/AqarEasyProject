//
//  MapSearchViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/27/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "MapSearchViewController.h"
#import "SWRevealViewController.h"
#import "Constant.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "CustomAnnotation.h"
#import "PropertyModel.h"
#import "PropertyInfoViewController.h"
#import "SDK_API_Controller.h"
#import <WYPopoverController.h>
#import "mapPopUpViewController.h"
#import "PropertyInfoViewController.h"

@interface MapSearchViewController ()<WYPopoverControllerDelegate,BTNDelg>
{
    WYPopoverController* popoverController;
    __weak IBOutlet UITableView *TBL_search;
    BOOL firstTimeOnly;
    //PropertyModel *activeModel;
    NSMutableArray *ArrSearchModels;
    NSMutableArray *ArrSearchResult;
    NSMutableArray *ArrAnotations;
    int page;
    __weak IBOutlet NSLayoutConstraint *COnst_summeryH;
}
@end

@implementation MapSearchViewController
//#define METERS_PER_MILE 1609.344

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //if (activeModel) {
     // [self.summaryViewiPhone setDataFromModel:activeModel];
    //}
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    firstTimeOnly=YES;
   // activeModel=nil;
    ArrSearchResult=[NSMutableArray new];
    ArrSearchModels=[NSMutableArray new];
    ArrAnotations=[NSMutableArray new];
    // Do any additional setup after loading the view.
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    [self initializeLocationServices];
   
    
    self.searchBar.hidden = YES;
    self.overlaymMapView.hidden = YES;
    
    self.overlaySummaryView.hidden = YES;
    
    //self.summaryViewiPhone.alpha=0;
    //COnst_summeryH.constant=0;
}


/*

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"PropertyInfo_Segue"]&&activeModel != nil)
    {
        PropertyInfoViewController * propertyInfoViewController = [segue destinationViewController];
        propertyInfoViewController.propertyModel = activeModel;
    }
    
}
*/

-(void)initializeLocationServices
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        //        [locationManager requestAlwaysAuthorization];
    }
    
        [locationManager startUpdatingLocation];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied)
    {
        [Utility showAlert:@"تنبيه" message:@"من فضلك قم بتفعيل خدمة تحديد المواقع على الجهاز"];
    }
    else{
        [Utility showAlert:@"تنبيه" message:@"يوجد خطأ في تحديد موقعك"];
    }
    NSLog(@"error location %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if (locations.lastObject != nil&&firstTimeOnly)
    {
        firstTimeOnly=NO;
       // NSLog(@"sdsd %f %f", locationManager.location.coordinate.longitude, locationManager.location.coordinate.latitude);
        /*
        MKCoordinateRegion region ;//= { { 0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = locationManager.location.coordinate.latitude;
        region.center.longitude = locationManager.location.coordinate.longitude;
        //region.span.latitudeDelta = 0.0187f;
        //region.span.longitudeDelta = 0.0137f;
        [self.mapView.mapView setRegion:region animated:YES];
        */
        [self loadNearByAqars];
        [locationManager stopUpdatingLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        self.mapView.mapView.showsUserLocation = YES;
        [self.mapView.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchButton:(id)sender {
    
    self.overlaymMapView.hidden = NO;
    self.overlaySummaryView.hidden = NO;

    self.searchBar.hidden = NO;
     self.searchBar.alpha = 1;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForText:[NSString stringWithFormat:@"%@",searchBar.text]];
     //NSLog(@"===============%@",  searchBar.text);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    self.searchBar.hidden = NO;
    self.overlaymMapView.hidden = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
   // NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
    self.searchBar.text = @"";

    self.searchBar.hidden = YES;
    self.overlaymMapView.hidden = YES;
    self.overlaySummaryView.hidden=YES;
    TBL_search.hidden=YES;
   
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(void)searchForText:(NSString*)txt{
    [ArrSearchResult removeAllObjects];
    for (PropertyModel *model in ArrSearchModels) {
        if ([model.nodeTitle rangeOfString:txt].location !=NSNotFound||
            [model.AdvertiserName rangeOfString:txt].location !=NSNotFound
            ) {
            [ArrSearchResult addObject:model];
            
        }
    }
    TBL_search.hidden=NO;
    [TBL_search reloadData];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma - mark
#pragma - mark table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ArrSearchResult.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=((PropertyModel*)ArrSearchResult[indexPath.row]).nodeTitle;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // activeModel=ArrSearchResult[indexPath.row];
    
    // [self performSegueWithIdentifier:@"PropertyInfo_Segue" sender:self];
    
    
    PropertyModel *model=ArrSearchResult[indexPath.row];
  PropertyInfoViewController *ctrl=  [self.storyboard instantiateViewControllerWithIdentifier:@"PropertyInfoViewController"];
    ctrl.propertyModel=model;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}



-(void)loadNearByAqars{
    [Utility showLoading];
   // NSString * lat = @"51.518653";
    //NSString* lng = @"-0.281137";
    
   // NSString *lat=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
  //  NSString *lng=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    /*
    [[APIControlManager sharedInstance]getPropertiesNearBywithLatitude:lat Longitude:lng Distance:@"200000" andPath:[NSString stringWithFormat:@"aqarnearby"] withCompletionBlock:^(NSMutableArray *propertyArray, NSString *errorMessage) {
        
        ArrSearchModels=[NSArray arrayWithArray:propertyArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMapWithArray:propertyArray andErorr:errorMessage];
        });
    }];

    */
    //////////
    
    
    [Utility showLoading];
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"admap?page=0" andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        
        NSMutableArray *temp=[NSMutableArray new];
        
       // NSMutableArray *arr=[NSMutableArray new];
        for(NSDictionary *dic in result)
        {
            PropertyModel * propertyModel = [[PropertyModel alloc]init];
            [propertyModel PropertyFromDictionary:dic];
           // [ArrSearchModels addObject:propertyModel];
            [temp addObject:propertyModel];
        }
        [ArrSearchModels addObjectsFromArray:temp];
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMapWithArray:ArrSearchModels andErorr:error.localizedDescription];
        });
    }];
    
    [NSThread detachNewThreadSelector:@selector(getALlData) toTarget:self withObject:nil];
    
//    [[APIControlManager sharedInstance]getPropertiesNearBywithLatitude:lat Longitude:lng Distance:@"10000" andPath:[NSString stringWithFormat:@"aqarnearby?page=%d",0] withCompletionBlock:^(NSMutableArray *propertyArray, NSString *errorMessage) {
//        
//        
//        ArrSearchModels=[NSArray arrayWithArray:propertyArray];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateMapWithArray:propertyArray andErorr:errorMessage];
//        });
//        
//    }];
    
}


-(void)getALlData{
    
    
        [[SDK_API_Controller sharedInstance] sendrequestWithPath:[NSString stringWithFormat:@"admap?page=%d",page] andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
            
            
            if ([result count]>0) {
                // NSMutableArray *arr=[NSMutableArray new];
                for(NSDictionary *dic in result)
                {
                    PropertyModel * propertyModel = [[PropertyModel alloc]init];
                    [propertyModel PropertyFromDictionary:dic];
                    [ArrSearchModels addObject:propertyModel];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateMapWithArray:ArrSearchModels andErorr:error.localizedDescription];
                });
                page++;
                
                [self getALlData];
            }
            
        }];
        
    
    
    
}

-(void)updateMapWithArray:(NSArray*)arr andErorr:(NSString*)errorMessage{
    
    if(errorMessage == nil)
    {
        if([arr count] == 0&&ArrSearchModels.count==0)
            [Utility showAlert:@"عفوا" message:@"لا توجد بيانات"];
        else{
            self.mapView.mapView.delegate=self;
            if (ArrSearchModels.count>0) {
                [self.mapView.mapView removeAnnotations:ArrAnotations];
            }
            
            for (NSInteger i=0;i< ArrSearchModels.count;i++) {
               
                PropertyModel *model=arr[i];
                if (model.latitude==0||model.longitude==0) {
                     NSLog(@"id=%@ ============= name =%@",model.nid,model.nodeTitle);
                    continue;
                }
                if (24<model.latitude&& model.latitude < 25) {
                    NSLog(@"nid = %@===   lat=%f  ==== lng=%f  \n",  model.nid,model.latitude,model.longitude);
                }
                
                CustomAnnotation * customAnnotation = [[CustomAnnotation alloc]initWithLocation: CLLocationCoordinate2DMake(model.latitude,model.longitude)];
                customAnnotation.title=@" ";
                customAnnotation.subtitle=@" ";
                customAnnotation.type = property;
                customAnnotation.model=model;
                customAnnotation.Index=i;
                
                [self.mapView.mapView addAnnotation:customAnnotation];
                [ArrAnotations addObject:customAnnotation];

            }

        }
    }
    else
    {
        [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة اخرى"];
    }
    
    
    [Utility hideLoading];
    //[_activityIndicator stopAnimating];
}

#pragma - mark
#pragma - mark map methods
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
   //NSLog(@"===============%@", NSStringFromCGRect(view.frame));
    if ([view isKindOfClass:[CustomAnnotaionView class]]) {
        CustomAnnotaionView * annot =(CustomAnnotaionView*)view;
     
//    activeModel = annot.customAnnot.model;

    
  mapPopUpViewController *info=  [self.storyboard instantiateViewControllerWithIdentifier:@"mapPopUpViewController"];
       // info.view.frame=CGRectMake(0, 0, 300, 200);
        //info.preferredContentSize=CGSizeMake(300, 200);
        
       // PropertyModel *tempModel=ArrSearchModels[annot.customAnnot.Index];
        info.model=annot.customAnnot.model;
        info.delg=self;
   // NSLog(@"===============%@", annot.customAnnot.model.nid);
     //   NSLog(@"lat===============%f",  annot.customAnnot.model.latitude);
      //  NSLog(@"lng===============%f",  annot.customAnnot.model.longitude);
        
       // [info.View_summeryIphone setDataFromModel:annot.customAnnot.model];
        
        
    popoverController = [[WYPopoverController alloc] initWithContentViewController:info];
    popoverController.delegate = self;
        popoverController.contentViewController.preferredContentSize=CGSizeMake(300, 200);
        
    [popoverController presentPopoverFromRect:view.frame inView:self.mapView permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        
    }
   
}

-(void)ButtonClickedWithModel:(PropertyModel *)model{
    
   /* if (model) {
        activeModel=model;
    }
    [popoverController dismissPopoverAnimated:YES];
 
     [self performSegueWithIdentifier:@"PropertyInfo_Segue" sender:self];
    
    */
    
    [popoverController dismissPopoverAnimated:YES];
    PropertyInfoViewController *ctrl=  [self.storyboard instantiateViewControllerWithIdentifier:@"PropertyInfoViewController"];
    ctrl.propertyModel=model;
    [self.navigationController pushViewController:ctrl animated:YES];

}



- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[CustomAnnotation class]]) //if this class is my custom pin class
    {
        
          CustomAnnotaionView *annotationView=[[CustomAnnotaionView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
            annotationView.customAnnot=annotation;
            annotationView.image=[UIImage imageNamed:@"home22"];
        
        
        return annotationView;
    }
    else
        return nil;
    
}





@end
