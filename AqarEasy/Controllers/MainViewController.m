//
//  MainViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "MainViewController.h"
#import "PropertyInfoViewController.h"
#import "AdCollectionViewCell.h"
#import "APIControlManager.h"
#import "Constant.h"
#import "Utility.h"
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "AqarEasyUser.h"
#import "PropertyModel.h"

@interface MainViewController ()
{
    int page;
    NSMutableDictionary *dicFav;
    NSString *current;
    BOOL canLoadNexPage;
    NSString *latitude,*longitude;
    BOOL firstTimeLoad;
}
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(goToSearchPage:)];
    
    
    page=0;
    canLoadNexPage=YES;
    firstTimeLoad=YES;
    dicFav=[[NSMutableDictionary alloc] initWithDictionary:[Utility getAllFavourites]];

    
    [self initializeLocationServices];
    _propertyArray = [[NSMutableArray alloc]init];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    self.revealViewController.delegate = self;
    
    
    //initialize Segment Control
    [self initializeSegmentControl];
    
    [self initializewithSelectedSegmentIndex:2];
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [self initializewithSelectedSegmentIndex:index];
    }];
    
    UICollectionViewFlowLayout * collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width , 210);
        
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self resizeView];
        }
    collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width/2.0-2, 210);
        
    }
    collectionViewFlowLayout.minimumInteritemSpacing = 3;
    collectionViewFlowLayout.minimumLineSpacing = 1;
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    
}

-(void)goToSearchPage:(UIBarButtonItem*)sender{

    [self performSegueWithIdentifier:@"showSearchFromMain" sender:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationItem.title=@"الرئيسية";

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    dicFav=[[NSMutableDictionary alloc] initWithDictionary:[Utility getAllFavourites]];
    [self.collectionView reloadData];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)resizeView{
    //Change the width of a table view
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width = self.view.frame.size.height;
    viewFrame.size.height = self.view.frame.size.width;
    self.view.frame = viewFrame;
}

-(void)initializeSegmentControl{//أحدث العقارات
    self.segmentedControl.sectionTitles = @[@" قريب مني",@"العقارات المميزة",@"أحدث العقارات "];
    
    self.segmentedControl.selectionIndicatorHeight = 3.0f;
    self.segmentedControl.selectedSegmentIndex = 2;
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:72/255.0 green:73/255.0 blue:64/255.0 alpha:1];
    self.segmentedControl.textColor = [UIColor whiteColor]; //#999999  rgb(153,153,153)
    self.segmentedControl.selectedTextColor = [UIColor whiteColor];
    self.segmentedControl.selectionIndicatorColor =  [UIColor whiteColor];//[UIColor colorWithRed:0.2235 green:0.7098 blue:0.2902 alpha:1];  // #39B54A  rgb(57,181,74)
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.font = [UIFont fontWithName:@"DroidArabicNaskh-Bold" size:14.0f];
    self.segmentedControl.tag = 3;
    
    self.segmentedControl.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor;
    
    UIImageView *imgv=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *0.33, 15, 1, self.segmentedControl.frame.size.height-30)];
    imgv.image=[UIImage imageNamed:@"menu_sprator"];
    
    [self.segmentedControl addSubview:imgv];

    UIImageView *imgv2=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *0.66, 15, 1, self.segmentedControl.frame.size.height-30)];
    imgv2.image=[UIImage imageNamed:@"menu_sprator"];
    
    [self.segmentedControl addSubview:imgv2];
}

-(void)initializewithSelectedSegmentIndex:(NSInteger)segmentIndex
{
    page=0;
    switch (segmentIndex) {
        case latestPropertySelected:  // احدث العقارات
        {
            [_propertyArray removeAllObjects];
            current=@"recent";
            [self loadPageWithUrl:[NSString stringWithFormat:@"adall?page=0&time=%f",[[NSDate date] timeIntervalSince1970]]];
            
            break;
        }
        case mostViewedSelected: {// الاكثر مشاهدة
            [_propertyArray removeAllObjects];
            current=@"promoted";
            [self loadPageWithUrl:[NSString stringWithFormat:@"promotedaqars?page=0&time=%f",[[NSDate date] timeIntervalSince1970]]];
            
            break;
        }
        case nearBySelected: // قريب مني
            [_propertyArray removeAllObjects];
            current=@"nearBy";
             firstTimeLoad=YES;
            if(IS_OS_8_OR_LATER) {
                [locationManager requestWhenInUseAuthorization];
                
            }
            
            [locationManager startUpdatingLocation];
            
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_propertyArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    PropertyModel * propertModel = [self.propertyArray objectAtIndex:indexPath.row];
    
    if (dicFav[propertModel.nid]) {
        cell.summaryView.favouritebutton.selected=YES;
        propertModel.isFavorite=YES;
        
    }else{
        cell.summaryView.favouritebutton.selected=NO;
        propertModel.isFavorite=NO;
    }
    
    [cell setData:propertModel];
        [cell.summaryView.favouritebutton addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
        cell.summaryView.favouritebutton.tag=indexPath.row;

    
    return cell;
    
}





-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==self.propertyArray.count-1&&canLoadNexPage) {
        canLoadNexPage=NO;
        [self loadNextPage];
    }

}


-(void)addToFav:(UIButton*)sender{
    
    if (![[AqarEasyUser sharedInstance] isUserLogged]) {
        [Utility showAlert:@"عفواً" message:@"من فضلك قم بتسجيل الدخول"];
        return;
    }

    PropertyModel * propertModel = [self.propertyArray objectAtIndex:sender.tag];
    
    if (sender.selected) {
        sender.selected=NO;
        [Utility DeleteFromFav:propertModel.nid];
        [dicFav removeObjectForKey:propertModel.nid];
        propertModel.isFavorite=NO;
        
    }else{
     sender.selected=YES;
        [Utility AddToFavourite:propertModel.nid];
        dicFav[propertModel.nid]=@"favs";
         propertModel.isFavorite=YES;
    }
    
    
}



-(void)initializeLocationServices
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied)
    {
         [Utility showAlert:@"عفواً" message:@"من فضلك قم بتمكين خدمات الموقع على الجهاز"];
    }
    else{
        [Utility showAlert:@"عفواً" message:@"حدث خطأ في تحديد موقعك"];
    }
    NSLog(@"error location %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if (locations.lastObject != nil&&firstTimeLoad)
    {
        firstTimeLoad=NO;
        //[_activityIndicator startAnimating];
        //_activityIndicator.hidden = NO;
        //[Utility showLoading];
        
         CLLocation *location = [locations lastObject];
        latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        
        //=========================
        //for testing
       //latitude = @"51.518653";
        //longitude = @"-0.281137";
        //=========================
        
        [self loadNearBy];
        
        
        [locationManager stopUpdatingLocation];
    }
}

-(void)updateView:(NSString*) errorMessage{
    
    if(errorMessage == nil)
    {
        if([_propertyArray count] == 0)
            [Utility showAlert:@"عفواً" message:@"لا توجد بيانات"];
    }
    else
    {
        [Utility showAlert:@"عفواً" message:@"يوجد خطأ في الاتصال بالانترنت الرجاء المحاولة مرة أخرى"];
    }
    
    [_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
    [Utility hideLoading];
    });
    
    //[_activityIndicator stopAnimating];
}


#pragma - mark
#pragma - mark load next page

-(void)loadNextPage{
   
   
     page++;
    
    if ([current isEqualToString:@"recent"]) {
        [self loadPageWithUrl:[NSString stringWithFormat:@"adall?page=%d&time=%f",page,[[NSDate date] timeIntervalSince1970]
                               ]];
        
    } else if([current isEqualToString:@"promoted"]) {
        
        [self loadPageWithUrl:[NSString stringWithFormat:@"promotedaqars?page=%d&time=%f",page,[[NSDate date] timeIntervalSince1970]]];
    }else if([current isEqualToString:@"nearBy"]){
       
        [self loadNearBy];
    }
    
}

-(void)loadPageWithUrl:(NSString*)url{
    
    [Utility showLoading];
    [[APIControlManager sharedInstance]getData:url withCompletionBlock:^(NSMutableArray * propertyArray, NSString *errorMessage) {
        if (propertyArray.count>0) {
           [_propertyArray addObjectsFromArray:propertyArray];
            
            _propertyArray=[self removeDublicateFromArr:_propertyArray];


            canLoadNexPage=YES;
        }else{
            canLoadNexPage=NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView:errorMessage];
        });

    }];
}

-(void)loadNearBy{
    
    [Utility showLoading];
    //24.807223,46.646452
    //latitude=@"24.807223";
    //longitude=@"46.646452";
    [[APIControlManager sharedInstance]getPropertiesNearBywithLatitude:latitude Longitude:longitude Distance:@"5" andPath:[NSString stringWithFormat:@"aqarnearby?page=%d",page] withCompletionBlock:^(NSMutableArray *propertyArray, NSString *errorMessage) {
        if (propertyArray.count>0) {
           // [_propertyArray removeAllObjects];
            [_propertyArray addObjectsFromArray:propertyArray];
            _propertyArray=[self removeDublicateFromArr:_propertyArray];

            canLoadNexPage=YES;
        }else{
            canLoadNexPage=NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView:errorMessage];
        });
    }];

    
}


-(void)prepareForSegue:(UIStoryboardSegue *) segue sender: (id)sender{
    
    
    //case go to search
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setNavigationBarHidden:NO];
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
        };
        
    }else{
        //case go to details
        PropertyInfoViewController * propertyInfoViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        // get the cell object
        
        PropertyModel * prop = [self.propertyArray objectAtIndex:indexPath.row];
        propertyInfoViewController.propertyModel = prop;

    }
    
}

#pragma - mark
#pragma  -mark remove dublicate

-(NSMutableArray*)removeDublicateFromArr:(NSArray*)arr{
//    NSMutableArray *result = [NSMutableArray new];
//   
//    for (PropertyModel *obj in arr) {
//        
//        if (![result containsObject:obj]) {
//            
//            [result addObject:obj];
//        }
//    }
//    return result;
    
    /*
    NSArray *copyArray = [_propertyArray copy];
    NSInteger index = [copyArray count] - 1;
    for (id object in [copyArray reverseObjectEnumerator]) {
        if ([_propertyArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [_propertyArray removeObjectAtIndex:index];
        }
        index--;
    }*/
    return _propertyArray;
}
@end


