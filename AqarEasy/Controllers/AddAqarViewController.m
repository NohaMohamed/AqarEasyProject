//
//  AddAqarViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/17/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AddAqarViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "AlbumTableViewController.h"
#import "Constant.h"
#import "AqarEasyUser.h"
#import "APIControlManager.h"
#import <DIOSUser.h>
#import "SDK_API_Controller.h"
#import <DIOSSession.h>
#import <DIOSFile.h>
#import <DIOSNode.h>
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "addAqarViewModel.h"
#import "SelectViewController.h"
#import "AqarEasyUser.h"

@interface UIImagePickerController (custom)

@end


@implementation UIImagePickerController(custom)

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        
        return  UIInterfaceOrientationPortrait;
    }else{
        return UIInterfaceOrientationLandscapeRight;
    }
    // return UIInterfaceOrientationMaskLandscapeRight;
    
    // return  UIInterfaceOrientation(UIInterfaceOrientationMaskLandscape);
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
}

@end


#define TAXSOMY_REGION @"Region"
#define TAXSOMY_COUNTRY @"Country"
#define TAXSOMY_CITY @"City"
#define TAXSOMY_STREET @"Street"
#define TAXSOMY_AqarType @"aqarType"
#define TAXSOMY_Coin @"coin"


#define TOOLBARHEIGHT ((int) 44)

@interface AddAqarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddAqarViewModelDelg,selectViewControllerDelegate>

{
    NSMutableArray *ArrImageIdsToBeDeleted;
    
    int contractTypeId;
    addAqarViewModel *addAqarVM;
    NSMutableArray *ArrRegions;
    NSMutableArray *ArrAqarType;
    
     NSMutableArray *ArrayCities;
     NSMutableArray *ArrayStreets;
     NSMutableArray *ArrayCountries;
     NSArray *ArrayCoin;
    
    NSString *CurrentTxasonmy;
    NSString* AqarTypeId;
    NSString *tid;
    NSString *cointypeId;
    NSString *carSationValue;
    NSString *countryId;
    NSString *cityId;
    
    BOOL canShowValidateFromCurrentLocation;
    
    PropertyModel *modelToEdited;
}
@end

@implementation AddAqarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ArrImageIdsToBeDeleted=[NSMutableArray new];
    if (self.nodeId) {
        [self getNodeDataForEdit];
        
    }else{
        [self ChooseCurrentLocation:BTN_CurrentLocation];
    }
    
    [self makeRoundCornerForViews];
    carSationValue=@"no";
    countryId=@"";
    cityId=@"";
    cointypeId=@"";
    
    [SegmContractType.layer setCornerRadius:5];
    [SegmContractType.layer setMasksToBounds:YES];
    
    addAqarVM=[[addAqarViewModel alloc] init];
    addAqarVM.delg=self;
    
    if([[AqarEasyUser sharedInstance] isUserLogged])[addAqarVM getDatafromServerWithTaxsonomy:location andParent:@"0"];
    
    contractTypeId=658;//default rent
    
    canShowValidateFromCurrentLocation=NO;
    
    
    canShowValidateFromCurrentLocation=YES;
    
    // Do any additional setup after loading the view.
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    //    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
    
    // inirialize keyboard with next,prev toolbar
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [keyBoardController addToolbarToKeyboard];
    
    CGFloat navigationHeight =  self.navigationController.navigationBar.frame.size.height;
    keyBoardController.viewFrameY = navigationHeight + self.view.frame.origin.y;
    
    
    attachedImages = [[NSMutableArray alloc]init];
    
    [[[Utility sharedInstance]selectedAssets] removeAllObjects];
    
    [self initializeLocationServices];
    
    ArrayCoin=@[@{@"name":@"ريال سعودي",@"tid":@"SAR"},@{@"name":@"دولار أمريكي",@"tid":@"USD"},@{@"name":@"يورو",@"tid":@"EUR"}];
    
}


-(void)makeRoundCornerForViews{
    
    for (UIView *view in VIEWS) {
        
        view.layer.cornerRadius=7;
        [view.layer setMasksToBounds:YES];
        view.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
        view.layer.borderWidth=1;
        
    }
    for (UIView *view in VIEWS_SERVICES) {
        
        view.layer.cornerRadius=7;
        [view.layer setMasksToBounds:YES];
        view.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
        view.layer.borderWidth=1;
        
    }
    LBL_bathRoomCount.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
    LBL_bathRoomCount.layer.borderWidth=1;
    
    LBL_bedRoomCount.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
    LBL_bedRoomCount.layer.borderWidth=1;
}

-(void)getNodeDataForEdit{
    
   
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility showLoading];
            
        });
        
        [[APIControlManager sharedInstance] getAqarInformationwithnNodeID:self.nodeId withCompletionBlock:^(NSMutableArray *propertyArray, NSString *errorMessage) {
            
            if (propertyArray.count>0) {
                PropertyModel* AqarInfoAdvertiserModel=propertyArray[0];
                
                
                [self setAqarEditData:AqarInfoAdvertiserModel];
                
                [LBL_errorImageNum setHidden:YES];
                [NSThread detachNewThreadSelector:@selector(getNResizeImages:) toTarget:self withObject:AqarInfoAdvertiserModel.ArrImages];
            }
            
            
            [Utility hideLoading];
        }];
        
    
}

-(void)setAqarEditData:(PropertyModel*)model{
    
    modelToEdited=model;
    
    if([model.contract_type_id intValue]==658){
        SegmContractType.selectedSegmentIndex=0;
        contractTypeId=658;
    }else{
        SegmContractType.selectedSegmentIndex=1;
        contractTypeId=659;
        
    }
    
    propertyLocation=CLLocationCoordinate2DMake(model.latitude, model.longitude);
    
    //set border of setLocationButton
    BTN_setLocFromMap.layer.borderWidth = 2.0;
    BTN_setLocFromMap.layer.borderColor = [UIColor redColor].CGColor;
    
    //set border of currentLocationButton
    BTN_CurrentLocation.layer.borderWidth = 0.5;
    BTN_CurrentLocation.layer.borderColor = [UIColor clearColor].CGColor;
    
    LBL_region.text=model.location_parent3;
    LBL_countries.text=model.location_parent2;
    LBL_city.text=model.location_parent;
    LBL_street.text=model.location;
   // LBL_street.text=mode
    
   // location_parent3_tid
    tid=model.location_tid;
    countryId=model.location_parent2_tid;
    cityId=model.location_parent_tid;
    cointypeId=model.currencyId;
    AqarTypeId=model.aqarTypeId;
    LBL_aqarType.text=model.aqarType;
    AqarTypeId=model.aqarTypeId;
    TXT_address.text=model.nodeTitle;
    TXT_price.text=model.price;
    [BTN_coin setTitle:model.currencyName forState:UIControlStateNormal];
    TXT_area.text=model.area;
    TXT_desc.text=model.nodeDescription;
    LBL_bedRoomCount.text=[NSString stringWithFormat:@"%@",model.bedroomCount];
    LBL_bathRoomCount.text=[NSString stringWithFormat:@"%@",model.bathroomCount];
    if (model.showParking) {
        SegmCarStation.selectedSegmentIndex=1;
        carSationValue=@"yes";
    }else{
        SegmCarStation.selectedSegmentIndex=0;
        carSationValue=@"no";
    }
    
    TXT_Buildyear.text=model.yearBuilt;
    TXT_distanceToAirport.text=model.distanceLocationModel.distanceToAirport;
    TXT_distanceToHighWay.text=model.distanceLocationModel.distanceToHighWay;
    TXT_distanceMidTown.text=model.distanceLocationModel.distanceToDownTown;
    
    
}

-(void)getNResizeImages:(NSArray*)arr{

    if(arr.count>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [attachedImages addObjectsFromArray:arr];
            [ThumbCollection reloadData];
        });
     
    }
    
    
}


- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    //    [self.myTextFiled resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Aqar View Delegate Methods
- (IBAction)takePicture:(id)sender {
    switch ([sender tag]) {
        case 1:
            [self openGallery];
            break;
        case 2:
            [self takePhoto];
            break;
        default:
            break;
    }
}


// open camera and take a photo
-(void)takePhoto{
    [self.view endEditing:YES];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"landscacpe"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        [Utility showAlert:@"عفواً" message:@"لا يوجد كاميرا علي هذا الجهاز"];
    }
}

-(void)openGallery{
    [self.view endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Picker" bundle:nil];
    UINavigationController *nController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerNC"];
    AlbumTableViewController * viewController = [nController viewControllers][0];
    
    viewController.delegate = self;
    [Utility sharedInstance].pickerType = pickerTypePhoto;
    [self.navigationController pushViewController:viewController animated:YES];

    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        
        imageToUse=[UIImage imageWithCGImage:[imageToUse CGImage]
                                       scale:[imageToUse scale]
                                 orientation: UIImageOrientationRight];
        
        //UIImage *img=[self compressForUpload:imageToUse scale:0.25];
        NSData * imgData=UIImagePNGRepresentation(imageToUse);
        //NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(imageToUse, 0.25)];
        NSInteger imageSize   = imgData.length;
        NSLog(@"size of image in KB: %f ", imageSize/1024.0);
        
        if ( (imageSize/1024.0) < 2048) {
            UIImage *img=[[UIImage alloc] initWithData:imgData];
           
            UIImage* temp=[Utility imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
            
            [attachedImages addObject:@{@"img":temp}];
            
        }


        if (attachedImages.count>=3) {
            LBL_errorImageNum.hidden = YES;

        }
        
        [ThumbCollection reloadData];
        
         LBL_errorImageNum.text=[NSString stringWithFormat:@" لديك %ld صورة مضافة",(unsigned long)attachedImages.count];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"landscacpe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

- (IBAction)ChooseCurrentLocation:(id)sender {//ChooseCurrentLocation
    
    if (canShowValidateFromCurrentLocation) {
        
        if (!tid) {
            [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
            return ;
        }
        
        if (countryId.length < 1) {
            [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
            return ;
        }
        
        if (cityId.length < 1) {
            [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
            return ;
        }
    }
  
    
    
    [self startUpdatingLocation];
    
    
    //set border of setLocationButton
    BTN_setLocFromMap.layer.borderWidth = 0.50;
    BTN_setLocFromMap.layer.borderColor = [UIColor clearColor].CGColor;
    
    //set border of currentLocationButton
    BTN_CurrentLocation.layer.borderWidth = 2.0;
    BTN_CurrentLocation.layer.borderColor = [UIColor redColor].CGColor;

}

- (IBAction)chooseLocationFromMap:(id)sender {
    
    
    if (!tid) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
        return ;
    }
    
    if (countryId.length < 1) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
        return ;
    }
    
    if (cityId.length < 1) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"قم بتحديد الإقليم والدولة والمدينة " andType:SWarning];
        return ;
    }
    
    //set border of setLocationButton
    BTN_setLocFromMap.layer.borderWidth = 2.0;
    BTN_setLocFromMap.layer.borderColor = [UIColor redColor].CGColor;
    
    //set border of currentLocationButton
    BTN_CurrentLocation.layer.borderWidth = 0.5;
    BTN_CurrentLocation.layer.borderColor = [UIColor clearColor].CGColor;

    annotation = nil;
    
    mapview = [[MapView alloc]init];
    CGFloat statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect mapFrame = self.navigationController.view.bounds;
    mapFrame.origin.y = statusBarHeight;
    mapFrame.size.height = mapFrame.size.height - statusBarHeight ;
    
    mapview.frame = mapFrame;
    [self.navigationController.view addSubview:mapview];
    mapview.mapView.delegate = self;
    [mapview.mapView setShowsUserLocation:NO];
//    NSLog(@"propertyLocation.coordinate: %f",propertyLocation.latitude);
    [self moveAnnotationToCoordinate:propertyLocation];
    
    [mapview.mapView setRegion:MKCoordinateRegionMake(propertyLocation, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    [self showToolBar];
    
    if (!_nodeId) {
      [self geoCodeLocation];
    }
}



- (IBAction)chooseCoin:(id)sender {
    SelectViewController  *selct=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectViewController class])];
    selct.delgate=self;
    selct.arrData=ArrayCoin;
    CurrentTxasonmy=TAXSOMY_Coin;
    [self presentViewController:selct animated:YES completion:nil];
}

- (IBAction)chooseAqarType:(id)sender {
    
    SelectViewController  *selct=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectViewController class])];
    selct.delgate=self;
    selct.arrData=ArrAqarType;
    CurrentTxasonmy=TAXSOMY_AqarType;
    [self presentViewController:selct animated:YES completion:nil];
}

-(void)geoCodeLocation{
    [Utility showLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableString *address=[NSMutableString new];
        if (LBL_street.text.length>0) {
            [address appendString:LBL_street.text];
            
        }
        if (LBL_city.text.length>0) {
            [address appendString:@","];
            [address appendString:LBL_city.text];
            
        }
        if (LBL_countries.text.length>0) {
            [address appendString:@","];
            [address appendString:LBL_countries.text];
            
        }
        if (LBL_region.text.length>0) {
            [address appendString:@","];
            [address appendString:LBL_region.text];
            
        }
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@",address];
        url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
              if (data) {
                NSDictionary *resultTemp= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSArray *result=resultTemp[@"results"];
                if (result.count>0) {
                    NSDictionary *dic=result[0];
                    
                    if (dic[@"geometry"]) {
                        NSDictionary *temp=dic[@"geometry"][@"location"];
                        double lat= [temp[@"lat"] doubleValue];
                        double lng =[temp[@"lng"] doubleValue];
                        
                        [self moveAnnotationToCoordinate: CLLocationCoordinate2DMake(lat, lng)];
                        [mapview.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng), MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
                    }
                    
                }
            }
            
            [Utility hideLoading];
            });
          
        }];
        
        
    });
    

}


- (IBAction)addAqar:(id)sender {
    
    
    if (![[AqarEasyUser sharedInstance] isUserLogged]) {
        [Utility showAlert:@"عقواً" message:@"من فضلك قم بتسجيل الدخول "];
        return;
    }
    
    bool validateTextFields = [self validateForm];
    NSLog(@"validate:%@",validateTextFields?@"YES":@"NO");
    
    if(validateTextFields && LBL_errorImageNum.isHidden)
    {
        
        [self doAddAqar];
    }
}






-(void)doAddAqar{
    //latitude,long
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility showLoading];
    });
    
    NSMutableDictionary *nodeData = [NSMutableDictionary new];


    if (self.nodeId) {//edit mode
        
        // [nodeData setObject:@"10000953" forKey:@"uid"];
        [nodeData setObject:[[AqarEasyUser sharedInstance] getUserUid] forKey:@"uid"];
        [nodeData setObject:@{@"ar":@[@{@"value":TXT_address.text}]} forKey:@"title_field"];
        [nodeData setObject:@"0" forKey:@"status"];
        [nodeData setObject:@"language" forKey:@"und"];
        [nodeData setObject:@"ar" forKey:@"language"];
        
        [nodeData setObject:@"aqar" forKey:@"type"];
        
        
        [nodeData setObject:@{@"und":@{@"value":carSationValue}} forKey:@"field_parking"];
        
        
        if (tid) {
            NSDictionary *region=  @{@"und":@[@{@"tid":tid}]};
            [nodeData setObject:region forKey:@"field_region"];
        }
        
        
        [nodeData setObject:@{@"und": @{@"tid":@(contractTypeId)}} forKey:@"field_contract_type"];
        
        
        NSString *price=TXT_price.text;
        price=[price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        price= [price stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [nodeData setObject:@{@"und": @[@{@"value":price}]} forKey:@"field_price"];
        
        
        
        [nodeData setObject:@{@"und":@[@{@"value":TXT_Buildyear.text}]} forKey:@"field_building_year"];
        
        
        [nodeData setObject:@{@"und":@{@"tid":AqarTypeId}} forKey:@"field_type"];
        
        NSString *bedroom=[NSString stringWithFormat:@"%d",[LBL_bedRoomCount.text intValue]];
        
        [nodeData setObject:@{@"und":@{@"value":bedroom}}  forKey:@"field_bedrooms"];
        
        
        NSString *bathroom=[NSString stringWithFormat:@"%d",[LBL_bathRoomCount.text intValue]];
        
        [nodeData setObject:@{@"und":@{@"value":bathroom}} forKey:@"field_bathrooms"];
        
        [nodeData setObject:@{@"und":@[@{@"value":TXT_area.text}]} forKey:@"field_area"];
        
        [nodeData setObject:@{@"und":@{@"value":@"4"}} forKey:@"field_streets_around"];
        [nodeData setObject:@[] forKey:@"field_general_amenities"];
        
        
        [nodeData setObject:@{@"und":@[@{@"lid":countryId,@"city":cityId,@"longitude":@(propertyLocation.longitude),@"latitude":@(propertyLocation.latitude),@"locpick":@{@"user_longitude":@(propertyLocation.longitude),@"user_latitude":@(propertyLocation.latitude)}}]} forKey:@"field_location"];
        
        
        [nodeData setObject:@{@"ar":@[@{@"value":@"property"}]} forKey:@"field_icons_services"];
        
        
        [nodeData setObject:@{@"und":@[@{@"value":TXT_distanceToAirport.text}]} forKey:@"field_dist_airport"];
        
        // [nodeData setObject:@{@"und": @[@{@"value":TXT_desc.text}]} forKey:@"body"];
        [nodeData setObject:@{@"ar": @[@{@"value":TXT_desc.text}]} forKey:@"body"];
        
        [nodeData setObject:@{@"und":@[@{@"value":TXT_distanceMidTown.text}]} forKey:@"field_dist_downtown"];
        
        [nodeData setObject:@{@"und":@[@{@"value":TXT_distanceToHighWay.text}]} forKey:@"field_dist_highways"];
        
        [nodeData setObject:@[] forKey:@"field_dimensions"];
        
        [nodeData setObject:@{@"und":@{@"value":cointypeId}} forKey:@"field_currency"];
        
        
        [self saveNodeWithNodeData:nodeData andFilesArray:nil];
        
        
    } else {
        nodeData[@"title"]= TXT_address.text;
        nodeData[@"language"]=@"ar";
        nodeData[@"body"]= TXT_desc.text;
        if(tid) nodeData[@"region_tid"]=tid;
        nodeData[@"location[latitude]"]= @(propertyLocation.latitude);
        nodeData[@"location[longitude]"] = @(propertyLocation.longitude);
        nodeData[@"contract_type_tid"]=@(contractTypeId);
        nodeData[@"aqar_type_tid"]= AqarTypeId;
        nodeData[@"area"]= TXT_area.text;
        nodeData[@"dimensions"]= @"[]";
        
        NSString *bedroom=[NSString stringWithFormat:@"%d",[LBL_bedRoomCount.text intValue]];
        NSString *bathroom=[NSString stringWithFormat:@"%d",[LBL_bathRoomCount.text intValue]];
        
        nodeData[@"bedrooms"]= bedroom;
        nodeData[@"bathrooms"]= bathroom;
        
        nodeData[@"price"]= TXT_price.text;
        nodeData[@"currency"]= cointypeId;
        nodeData[@"building_year"]= TXT_Buildyear.text;
        nodeData[@"streets_around"]= @"4";
        nodeData[@"parking"]= carSationValue;
        nodeData[@"dist_airport"]=TXT_distanceToAirport.text;
        nodeData[@"dist_downtown"]= TXT_distanceMidTown.text;
        nodeData[@"dist_highways"]= TXT_distanceToHighWay.text;
        nodeData[@"status"]= @"1";
        nodeData[@"source"]= @"mobile_app_ios";
        
        
        
        [self addAqarWithImages:nodeData];
    }
    
   
    
    
    
    
   

   
}

-(void)addAqarWithImages:(NSMutableDictionary*)nodeData{

    for (int i=0; i<attachedImages.count; i++) {
        
        NSData *imageData1 = UIImagePNGRepresentation(attachedImages[i][@"img"]);
        NSString *base64Image1 =[[DIOSSession sharedSession] getbase64FromData:imageData1];
        nodeData[[NSString stringWithFormat:@"images[%d][filename]",i]]=[NSString stringWithFormat:@"img%d.jpg",i];
        nodeData[[NSString stringWithFormat:@"images[%d][data]",i]]=base64Image1;
        
    }
    
    NSString *path=@"http://aqareasy.com:8080/api/addAqarWithImages";//@"node";;

    
    
    
    [[APIControlManager sharedInstance] nativePostWithUrl2:path withParms:nodeData withCompletionBlock:^(id ret) {
        NSLog(@"===================%@",ret);
        [Utility hideLoading];
        
        if (ret) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utility ShowAlertWithTitle:@"" andMsg:@" تمت الاضافة بنجاح" andType:SSucess];

            });

            [self DeleteImages];

            
        } else {
            
            [Utility ShowAlertWithTitle:@"" andMsg:@" لقد حدث شئ ما ، من فضلك حاول مره اخري" andType:SFail];

        }

    }];
    
    /*return;
    
    [[APIControlManager sharedInstance] nativePostWithUrl:path withParms:nodeData andImgs:@[] withCompletionBlock:^(id ret) {
        NSLog(@"===================%@",ret);
        
        
        if ([ret isKindOfClass:[NSError class]]) {
            
            NSError *error=ret;
                [Utility hideLoading];
                NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
                if (data.length>0) {
                    
                    NSMutableString * strErr= [NSMutableString new];
                    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
                        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                            for (NSString *key in jsonObj[@"form_errors"]) {
                                
                                [strErr appendString:[Utility stringByStrippingHTML: jsonObj[@"form_errors"][key]]];
                                [strErr appendString:@"\n"];
                                
                            }
                        }
                        
                    }
                    [Utility showAlert:@"عفواً" message:strErr];
                    
                }else{
                    
                    [Utility showAlert:@"عفواً" message:error.localizedDescription];
                }
                
            
            
        } else {
            
            [self DeleteImages];
            [Utility hideLoading];

//            if (self.nodeId) {
//                [Utility ShowAlertWithTitle:@"" andMsg:@" تم التعديل بنجاح" andType:SSucess];
//            } else {
               [Utility ShowAlertWithTitle:@"" andMsg:@" تمت الاضافة بنجاح" andType:SSucess];
            
         //   }
         
        }
        
     
    }];
    */
    
    
}



-(void)saveNodeWithNodeData:(NSMutableDictionary*)nodeData andFilesArray:(NSArray*)arrFilesIds{

    NSString *path=@"node";;
    NSString *method=@"POST";
    if (self.nodeId) {
        path=[NSString stringWithFormat:@"%@/%@",path,self.nodeId];
        method=@"PUT";
    }
    
    
    
  
    
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:path andHttpMethod:method andParms:nodeData withCompletion:^(id result, NSError *error) {
        
        NSLog(@"===============%@",  result);
        if (result[@"nid"]) {
                       
            for (int i=0; i<attachedImages.count; i++) {
                //check if has dic[fid] the we don't need to post the image again since it's on the server
                NSDictionary *dicImg=attachedImages[i];
                if (dicImg[@"fid"]) {
                    if (i==attachedImages.count-1) {
                          [Utility hideLoading];
                        [Utility ShowAlertWithTitle:@"" andMsg:@" تم التعديل بنجاح" andType:SSucess];
                    }
                    continue;
                }
                
                
                 NSMutableDictionary *dic=[NSMutableDictionary new];
                NSData *imageData1 = UIImagePNGRepresentation(attachedImages[i][@"img"]);
                NSString *base64Image1 =[[DIOSSession sharedSession] getbase64FromData:imageData1];
                
                
                //  [ArrImgs addObject:@{@"data":str,@"filename":imgname}];
                
               // NSString *key1=[NSString stringWithFormat:@"images[%d][data]" ,0];
               // dic[key1]=base64Image1;
                dic[@"nid"]=result[@"nid"];
                dic[@"images[0][filename]"]=[NSString stringWithFormat:@"img%@.png",result[@"nid"]];
                dic[@"images[0][data]"]=base64Image1;//attachedImages[i][@"img"];
                
                
                
                //http://aqareasy.com:8080/api/nodeImage
                
                [[[APIControlManager alloc] init] uploadImg:nil withImgKeyName:@"images[0][data]" andParms:dic andUrl:@"http://aqareasy.com:8080/api/nodeImage" withCompletionBlock:^(id ret) {
                    NSLog(@"===================%@",ret);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (i==attachedImages.count-1) {
                            [Utility hideLoading];
                            [Utility ShowAlertWithTitle:@"" andMsg:@" تمت التعديل بنجاح" andType:SSucess];
                        }
                        
                    });

                }];
                
                //files[field_image_und_0][]
                
                /*
                 NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
                 
                 [file setObject:base64Image forKey:@"file"];
                 //  NSString *timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
                 NSString *imageTitle = [Utility randomStringWithLength:8];
                 NSString *filePath = [NSString stringWithFormat:@"%@%@.png",@"public://", imageTitle];
                 NSString *filename = [NSString stringWithFormat:@"%@.png", imageTitle];
                 [file setObject:filePath forKey:@"filepath"];
                 [file setObject:filename forKey:@"filename"];
                 
                 [DIOSFile fileSave:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 */
                /*
                [[[APIControlManager alloc] init] nativePostWithUrl:@"http://aqareasy.com/api/nodeImage" withParms:dic andImg:attachedImages[i][@"img"] withImgKeyName:@"images[0][data]" withCompletionBlock:^(id ret) {
                    NSLog(@"===================%@",ret);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (i==attachedImages.count-1) {
                            [Utility hideLoading];
                            [Utility ShowAlertWithTitle:@"" andMsg:@"لقد تمت الاضافه بنجاح" andType:SSucess];
                        }
                        
                    });
                }];*/
                
                
                
               /*[[[APIControlManager alloc] init] nativePostWithUrl2:@"http://aqareasy.com/api/nodeImage" withParms:dic withCompletionBlock:^(id ret) {
                    NSLog(@"===============%@",  ret);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (i==attachedImages.count-1) {
                            [Utility hideLoading];
                             [Utility ShowAlertWithTitle:@"" andMsg:@"لقد تمت الاضافه بنجاح" andType:SSucess];
                        }
                        
                    });
                    
                }];*/
                
            }
            
            //delete the images which i hide it from users
            dispatch_async(dispatch_get_main_queue(), ^{
                [self DeleteImages];
            });
            
            if (attachedImages.count <1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility hideLoading];
                        [Utility ShowAlertWithTitle:@"" andMsg:@" تمت الاضافة بنجاح" andType:SSucess];
                    
                    
                });

                
            }
            
        } else {
             [Utility hideLoading];
            NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (data.length>0) {
                
                NSMutableString * strErr= [NSMutableString new];
                id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
                    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                        for (NSString *key in jsonObj[@"form_errors"]) {
                            
                            [strErr appendString:[Utility stringByStrippingHTML: jsonObj[@"form_errors"][key]]];
                            [strErr appendString:@"\n"];
                            
                        }
                    }
                    
                }
                [Utility showAlert:@"عفواً" message:strErr];
                
            }else{
                
                [Utility showAlert:@"عفواً" message:error.localizedDescription];
            }
            
        }
        
    }];
    
    
}





#pragma mark - Assets View Controller delegate methods

-(NSData*)scaleImg:(UIImage*)img{
  //  NSData *imgData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation(img, 1)];
  // NSLog(@"before===================%ld",(imgData1.length/1024));

    UIImage *imgTemp= [Utility scaleImage:img toSize:img.size];
    
    
    NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(imgTemp, 1)];
    //NSLog(@"shrink===================%ld",(imgData.length/1024));

    
    if (imgData.length/1024 <= 1024) {
        
        return imgData;

    }else{
        
      return [self scaleImg: imgTemp];
    }
    
    return nil;
    
}

-(void)assetsViewController:(AssetsViewController*)controller didSelectImages:(NSMutableArray*)selectedImages{
    
    
  //  if (selectedImages.count>7) {
    //    [selectedImages removeObjectsInRange:NSMakeRange(6, selectedImages.count-6)];
    //}
    
    for (ALAsset *ast in selectedImages) {
        UIImage *image=[UIImage imageWithCGImage:[[ast defaultRepresentation] fullResolutionImage]];
        
        NSData *imgData = [self scaleImg:image];//[[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.25)];
        NSInteger imageSize   = imgData.length;
       // NSLog(@"size of image in KB: %f ", imageSize/1024.0);
        
        if ( (imageSize/1024.0) < 2048) {
            
            UIImage *img=[UIImage imageWithData:imgData];
            UIImage* temp=[Utility imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
            
            [attachedImages addObject:@{@"img":temp}];
        
        }else{
            [Utility ShowAlertWithTitle:@"" andMsg:@" الحد الاقصى للصورة هو ٢ ميجا" andType:SWarning];
        }
        
    }
    
    if(attachedImages.count >= 3)
    {
        LBL_errorImageNum.hidden = YES;
    }
    else {
        LBL_errorImageNum.hidden = NO;
    }
    
     [ThumbCollection reloadData];
    LBL_imagesNum.text=[NSString stringWithFormat:@" لديك %d صورة مضافة",(int)attachedImages.count];
}

-(void)initializeLocationServices
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self startUpdatingLocation];
}

-(void)startUpdatingLocation{
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied)
    {
         [Utility showAlert:@"عفواً" message:@"من فضلك قم بتمكين خدمات تحديدالموقع على الجهاز"];
    }
    else{
        [Utility showAlert:@"عفواً" message:@"هناك خطأ في تحديد موقعك"];
    }
    NSLog(@"error location %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%f===============%f", manager.location.coordinate.longitude, manager.location.coordinate.latitude);
    
    propertyLocation = [[locations lastObject]coordinate];
    NSLog(@"%f===============%f", propertyLocation.longitude, propertyLocation.latitude);
    
    if (locations.lastObject != nil)
    {
        propertyLocation = [[locations lastObject]coordinate];
       // NSString*latitude = [NSString stringWithFormat:@"%f",propertyLocation.latitude];
        //NSString*longitude = [NSString stringWithFormat:@"%f",propertyLocation.longitude];
        
//        NSLog(@"latitude: %@ ,longitude: %@",latitude,longitude);
        
        [locationManager stopUpdatingLocation];
    }
}


- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (annotation) {
        [UIView beginAnimations:[NSString stringWithFormat:@"slideannotation%@", annotation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.2];
        
        annotation.coordinate = coordinate;
        
        [UIView commitAnimations];
    } else {
        annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = propertyLocation;
        [mapview.mapView addAnnotation:annotation];
    }
//     NSLog(@"coordinate  %f,%f", coordinate.latitude, coordinate.longitude);
    
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)anno
{
    MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:@"DraggableAnnotationView"];
    
    if (!annotationView) {
        annotationView = [[AZDraggableAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:@"DraggableAnnotationView"];
    }
    
    ((AZDraggableAnnotationView *)annotationView).delegate = self;
    ((AZDraggableAnnotationView *)annotationView).mapView = mapview.mapView;
    
    return annotationView;
}

#pragma mark UIGestureRecognizerDelegate methods

/**
 Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // Returning YES ensures that double-tap gestures propogate to the MKMapView
    return YES;
}

#pragma mark UIGestureRecognizer handlers

- (void)handleSingleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
    {
        //return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:mapview.mapView];
    [self moveAnnotationToCoordinate:[mapview.mapView convertPoint:touchPoint toCoordinateFromView:mapview.mapView]];
}

#pragma mark AZDraggableAnnotationView delegate

- (void)movedAnnotation:(MKPointAnnotation *)anno
{
   selectedLocation =  anno.coordinate;
    NSLog(@"Dragged annotation to %f,%f", anno.coordinate.latitude, anno.coordinate.longitude);
}


-(void)showToolBar
{
    CGRect frame, remain;
    CGRectDivide(mapview.bounds, &frame, &remain, TOOLBARHEIGHT, CGRectMaxYEdge);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"اضف" style:UIBarButtonItemStyleDone target:self action:@selector(addLocation)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"الغاء" style:UIBarButtonItemStyleDone target:self action:@selector(hideMap)];
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,spacer,button2,nil]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [mapview addSubview:toolbar];
}

-(void)hideMap{
    [mapview removeFromSuperview];
}
-(void)addLocation{
    propertyLocation = selectedLocation;
    [mapview removeFromSuperview];
//    NSLog(@"propertyLocation: %f",propertyLocation.latitude);
}


#pragma -mark
#pragma - mark thumb collection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return attachedImages.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   UICollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imgv=[[UIImageView alloc] initWithFrame:cell.bounds];
     NSDictionary *dic= attachedImages[indexPath.item];
    if (dic[@"url"]) {
        [imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:[UIImage imageNamed:@"logo_small"]];
    } else {
        imgv.image=dic[@"img"];
    }
    
    [cell addSubview:imgv];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:indexPath.item];
    [btn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideImage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(12, 12, 25, 25)];
    [cell addSubview:btn];
    return cell;
}


-(void)DeleteImages{
    for (NSString *fid in ArrImageIdsToBeDeleted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SDK_API_Controller sharedInstance] sendrequestWithPath:[NSString stringWithFormat:@"deleteFile/%@",fid] andHttpMethod:@"POST" andParms:nil withCompletion:^(id result, NSError *error) {
                
                NSLog(@"===============%@",  result);
            }];
        });
    }
}

-(void)hideImage:(UIButton*)sender{
    
    
    NSDictionary *dic=attachedImages[sender.tag];
    if (dic[@"fid"]) {
        [ArrImageIdsToBeDeleted addObject:dic[@"fid"]];
        //DELETE
        //http://aqareasy.com/api/file/
       /* */
    }
    [attachedImages removeObjectAtIndex:sender.tag];
    
    
    [ThumbCollection reloadData];
      LBL_imagesNum.text=[NSString stringWithFormat:@" لديك %ld صورة مضافة",(unsigned long)attachedImages.count];
    if(attachedImages.count >= 3)
    {
        LBL_errorImageNum.hidden = YES;
    }
    else {
        LBL_errorImageNum.hidden = NO;
    }
}


- (IBAction)chooseContractType:(UISegmentedControl*)sender {
    switch(sender.selectedSegmentIndex){
            case 0:
            contractTypeId=658;
            break;
            
            case 1:
             contractTypeId=659;
            break;
    }
    
}



-(IBAction)ChooseTaxsonomyLocation:(id)sender
{
     SelectViewController  *selct=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectViewController class])];
    selct.delgate=self;
    switch ([sender tag]) {
        case 1:
             selct.arrData=ArrRegions;
            CurrentTxasonmy=TAXSOMY_REGION;
            break;
        case 2:
            selct.arrData=ArrayCountries;
            CurrentTxasonmy=TAXSOMY_COUNTRY;

            break;
        case 3:
            selct.arrData=ArrayCities;
            CurrentTxasonmy=TAXSOMY_CITY;

            break;
        case 4:
            selct.arrData=ArrayStreets;
            CurrentTxasonmy=TAXSOMY_STREET;

            break;
        default:
            break;
    }
   
    [self presentViewController:selct animated:YES completion:nil];
    
}
#pragma  -mark
#pragma  -mark add aqar view model

-(void)resultFromTaxsonomy:(NSArray*)arr andDiffer:(NSString*)differ{
    
    if ([differ isEqualToString:TAXSOMY_CITY]) {
        ArrayCities=[NSMutableArray arrayWithArray:arr];;
        
    } else if([differ isEqualToString:TAXSOMY_STREET]) {
        ArrayStreets=[NSMutableArray arrayWithArray:arr];;
        
    }else if([differ isEqualToString:TAXSOMY_COUNTRY]){
        ArrayCountries=[NSMutableArray arrayWithArray:arr];;
    }
    
    
}

-(void)regionFromServer:(NSArray*)arr{
    ArrRegions=[NSMutableArray arrayWithArray:arr];;
  
}

-(void)getAqarTypeFromServer:(NSArray*)arr{
    ArrAqarType=[NSMutableArray arrayWithArray:arr];;
    
}

#pragma -mark
#pragma -mark slection method

-(void)tableSelctedWithResult:(NSDictionary*)dic{
    
        if ([CurrentTxasonmy isEqualToString:TAXSOMY_REGION]) {
            tid=dic[@"tid"];
            LBL_region.text=dic[@"name"];
            [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_COUNTRY];
            
            
        } else if([CurrentTxasonmy isEqualToString:TAXSOMY_COUNTRY]){
            tid=dic[@"tid"];
            countryId=dic[@"tid"];
            LBL_countries.text=dic[@"name"];
            
            [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_CITY];
            
        } else if([CurrentTxasonmy isEqualToString:TAXSOMY_CITY]){
            tid=dic[@"tid"];
            cityId=dic[@"tid"];
            LBL_city.text=dic[@"name"];
            [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_STREET];
            
        }else if ([CurrentTxasonmy isEqualToString:TAXSOMY_STREET]){
            tid=dic[@"tid"];
            LBL_street.text=dic[@"name"];
            
        }else if([CurrentTxasonmy isEqualToString:TAXSOMY_AqarType]) {
        
            LBL_aqarType.text=dic[@"name"];
            AqarTypeId=dic[@"tid"];
            
        }else if ([CurrentTxasonmy isEqualToString:TAXSOMY_Coin]){
            [BTN_coin setTitle:dic[@"name"] forState:UIControlStateNormal];
            cointypeId=dic[@"tid"];
        }
  
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)userCancelSelect{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma -mark
#pragma -mark 
- (IBAction)increaseDecreaseBedRoomCount:(id)sender {
   //1 increase
      int cnt=[LBL_bedRoomCount.text intValue];
    if ([sender tag]==1) {
        
        cnt= (cnt >= 6) ? 6 : cnt+1;
        LBL_bedRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
        
    } else {
        cnt= (cnt <= 1)?1:cnt-1;
        LBL_bedRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
    }
}
- (IBAction)increaseDecreaseBathRoomCount:(id)sender {
    //1 increase
    
    int cnt=[LBL_bathRoomCount.text intValue];
    if ([sender tag]==1) {
        
        cnt= (cnt >=6)?6:cnt+1;
        LBL_bathRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
        
    } else {
        cnt= (cnt <= 1)?1:cnt-1;
        LBL_bathRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
    }
    
}
- (IBAction)changeCarStation:(UISegmentedControl*)sender {
    
    carSationValue=(sender.selectedSegmentIndex==0)?@"no":@"yes";
    
}

#pragma  -mark
#pragma  -mark validateForm 

-(BOOL)validateForm{
    
    if (!tid) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر الإقليم والدولة" andType:SWarning];
        return NO;
    }
    
    if (countryId.length < 1&&!_nodeId) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر الدولة" andType:SWarning];
        return NO;
    }
    
    if (cityId.length < 1 &&!_nodeId) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر المدينة" andType:SWarning];
        return NO;
    }
    
    
    
    if (!AqarTypeId ) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر نوع العقار" andType:SWarning];
        return NO;

    }
    
    if (TXT_address.text.length <3 ) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اكتب العنوان" andType:SWarning];
        return NO;
    }
    
    if (TXT_price.text.length <1) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اكتب السعر " andType:SWarning];
        return NO;
    }
    if (cointypeId.length <1) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر العملة  " andType:SWarning];
        return NO;
    }
    
    
        
    return YES;
}



@end
