//
//  PropertyInfoViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "PropertyInfoViewController.h"
#import "LocationViewController.h"
#import "APIControlManager.h"
#import "Utility.h"
#import "AqarEasyUser.h"
#import "UIViewController+ENPopUp.h"
#import "AdvertiserInfoController.h"
#import "SDK_API_Controller.h"
#import "InfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <FSImageViewer/FSBasicImageSource.h>
#import <FSImageViewer/FSBasicImage.h>

#import <STPopup/STPopup.h>

@interface PropertyInfoViewController ()<UITableViewDataSource,MKMapViewDelegate,locationDeleagte>
{
    
    __weak IBOutlet UIBarButtonItem *BTN_addToFav;
    PropertyModel *AqarInfoAdvertiserModel;
    NSMutableArray *ArrAqarInfo;
    STPopupController *popupController;

    __weak IBOutlet UIButton *LBL_nearByServices;
}
@end

@implementation PropertyInfoViewController
@synthesize propertyModel,locationViewController;



- (void)viewDidLoad {
    [super viewDidLoad];
   
    LBL_nearByServices.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:86/255.0 alpha:1].CGColor;
    LBL_nearByServices.layer.borderWidth=1;
     //check if is favourite
    if (propertyModel.isFavorite) {
        UIImage *image = [[UIImage imageNamed:@"add_favorites_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [BTN_addToFav setImage:image];
    
    }
    [self makeViewRounder:View_highway];
    [self makeViewRounder:View_midtown];
    [self makeViewRounder:View_airport];
    [self makeViewRounder:View_highwayVal];
    [self makeViewRounder:View_midtownVal];
    [self makeViewRounder:View_airportVal];
    
    
    self.title = propertyModel.nodeTitle;
//    if (propertyModel.images.count>0) {
//        [IMGV_imgAqar sd_setImageWithURL:[NSURL URLWithString:propertyModel.images[0]] placeholderImage:nil];
//    }
//    
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(Share:)];
  
      UIBarButtonItem *addToFavItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"favorit.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(AddToFav:)];
    
    self.navigationItem.rightBarButtonItems=@[shareItem,addToFavItem];
    
    self.toolbar.alpha=0;
    
    [MAP_aqarLoc setShowsUserLocation:NO];

    [NSThread detachNewThreadSelector:@selector(getAqarInfoWithBloack:) toTarget:self withObject:nil];
    
// add image touch
    
    //for image prowser
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    
    [IMGV_imgAqar addGestureRecognizer:singleTap];
    IMGV_imgAqar.userInteractionEnabled = YES;
    
    //add nearby services
    
    // add view of LocationViewController as subview
    locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationView"];
    locationViewController.nid=propertyModel.nid;
    locationViewController.delg=self;
    View_NearByServices = locationViewController.view;
    View_NearByServices.frame = View_NearByServicesHolder.bounds;
    [View_NearByServicesHolder addSubview:View_NearByServices];
    [locationViewController setDistances:propertyModel.distanceLocationModel];
    
}

-(void)makeViewRounder:(UIView*)view{
    
    view.layer.cornerRadius=view.frame.size.height/2;
    [view.layer setMasksToBounds:YES];
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColor whiteColor].CGColor;
    view.backgroundColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1];
    
    
}

-(void)getAqarInfoWithBloack:(void (^)(id res))sucess{
   dispatch_async(dispatch_get_main_queue(), ^{
       [Utility showLoading];
       
   });
    //node 776
    [[APIControlManager sharedInstance] getAqarInformationwithnNodeID:propertyModel.nid withCompletionBlock:^(NSMutableArray *propertyArray, NSString *errorMessage) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (propertyArray.count>0) {
                AqarInfoAdvertiserModel=propertyArray[0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setAqarInfo:AqarInfoAdvertiserModel];

                });
                
                //[mapView gotoLocation:AqarInfoAdvertiserModel.latitude longitude:AqarInfoAdvertiserModel.longitude];
                
                [self getuserImage];
            }
            
            if(sucess){
                sucess(AqarInfoAdvertiserModel);
            }
        });
       
        [Utility hideLoading];
    }];

}

-(void)setAqarInfo:(PropertyModel*)model{
    
    if (model.images.count) {
        int X=0;
        for (NSString*imageUrlString in model.images) {
            UIImageView*adddImage = [[UIImageView alloc]initWithFrame:CGRectMake(X, 0, imageContainerScrollView.frame.size.width, imageContainerScrollView.frame.size.height)];
            [adddImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            [adddImage setContentMode:UIViewContentModeScaleAspectFill];
            [imageContainerScrollView addSubview:adddImage];
            X+=imageContainerScrollView.frame.size.width;
            
        }
        [imageContainerScrollView setContentSize:CGSizeMake(model.images.count*imageContainerScrollView.frame.size.width, imageContainerScrollView.frame.size.height)];
        
        
    }
    LBL_imagesNum.text=[NSString stringWithFormat:@"%lu صورة",(unsigned long)model.images.count];
    LBL_aqarLocation.text=model.nodeTitle;
    
    ArrAqarInfo=[NSMutableArray new];
    
    [ArrAqarInfo addObject:@{@"key":@"السعر",@"val":[NSString stringWithFormat:@"%@ %@",model.currencyId,model.price]}];
   // [ArrAqarInfo addObject:@{@"key":@"الاقليم",@"val":model.location_parent}];
    //[ArrAqarInfo addObject:@{@"key":@" الدولة",@"val":model.location}];

    NSString *address=[NSString stringWithFormat:@"%@,%@,%@",model.location_parent2,model.location_parent,model.location];
    [ArrAqarInfo addObject:@{@"key":@"مكان العقار",@"val":address}];
    
    [ArrAqarInfo addObject:@{@"key":@"نوع العقد",@"val":model.contractType}];
    [ArrAqarInfo addObject:@{@"key":@"نوع العقار",@"val":model.aqarType}];
    [ArrAqarInfo addObject:@{@"key":@"المساحة",@"val":[NSString stringWithFormat:@"%@ م٢", model.area]}];
    [ArrAqarInfo addObject:@{@"key":@"غرف النوم",@"val":model.bedroomCount}];
    [ArrAqarInfo addObject:@{@"key":@"دورات المياه",@"val":model.bathroomCount}];
    //[ArrAqarInfo addObject:@{@"key":@"الشوارع",@"val":model.streets}];
    [ArrAqarInfo addObject:@{@"key":@"سنة البناء",@"val":model.yearBuilt}];
    [ArrAqarInfo addObject:@{@"key":@"تاريخ الاعلان",@"val":model.createdDate}];
    [ArrAqarInfo addObject:@{@"key":@"اخر تحديث",@"val":model.updateddate}];
    [TBL_aqarInfo reloadData];
    
    LBL_aqarDisc.text=model.nodeDescription;
    LBL_highwayVal.text=normalize(model.distanceLocationModel.distanceToHighWay);
    LBL_airportVal.text=normalize(model.distanceLocationModel.distanceToAirport);
    LBL_midtownVal.text=normalize(model.distanceLocationModel.distanceToDownTown);
    
    
    CustomAnnotation*   customAnnotation = [[CustomAnnotation alloc]initWithLocation: CLLocationCoordinate2DMake(model.latitude,model.longitude)];
    customAnnotation.type=3;
    [MAP_aqarLoc addAnnotation:customAnnotation];
    
    
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = model.latitude;
    mapRegion.center.longitude = model.longitude;
    mapRegion.span.latitudeDelta = 0.015;
    mapRegion.span.longitudeDelta = 0.015;
    [MAP_aqarLoc setRegion:mapRegion animated:YES];
    [MAP_aqarLoc regionThatFits:mapRegion];
    
  
    __AdvertiserView.LBL_advertiserName.text=model.AdvertiserName;
   
    
    
}
NSString *normalize(NSString *number) {
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    
    return [[number componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}
-(void)getuserImage{
    
    NSString *path=[NSString stringWithFormat:@"user/%@",AqarInfoAdvertiserModel.userId];
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:path andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        
        if (result[@"picture"]&&[result[@"picture"] isKindOfClass:[NSDictionary class]]) {
            
            if (result[@"picture"][@"url"]) {
                 NSLog(@"===============%@",  result[@"picture"][@"url"]);
                
                [__AdvertiserView.IMGV_user sd_setImageWithURL:[NSURL URLWithString:result[@"picture"][@"url"]] placeholderImage:[UIImage imageNamed:@"ad_profile.png"]];
            //    [aqarView loadUserImageWithUrl:result[@"picture"][@"url"]];
                
            }
        }
       
        
    }];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)initializePropertyView:(NSInteger)segmentIndex{
    switch (segmentIndex) {
        case aqarSelected:
            [self.propertyView bringSubviewToFront:aqarView];
            break;
        case locationSelected:
            [self.propertyView bringSubviewToFront:locationView];
            break;
        case mapSelected:
            [self.propertyView bringSubviewToFront:mapView];
            break;
            
        default:
            break;
    }
}
*/
- (IBAction)showMore:(UIButton*)sender {
        float h=   [Utility getHeightForTxt:AqarInfoAdvertiserModel.nodeDescription forWidth:LBL_aqarDisc.frame.size.width withFont:LBL_aqarDisc.font];
    if (h < 96) {
        h=96;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
 
        Constr_showMore.constant=h;
        Constr_viewParentHeight.constant +=h;
//        CGRect fr=self.view.frame;
//        fr.size.height +=h;
//        self.view.frame=fr;
        
        LBL_aqarDisc.numberOfLines=0;
        
        [UIView animateWithDuration:0.5 animations:^{
              [LBL_aqarDisc layoutIfNeeded];
            [self.view layoutIfNeeded];
        }];
      
    }else{
        
         h -=96;
        
//        CGRect fr=self.view.frame;
//        fr.size.height -=h;
//        self.view.frame=fr;

        Constr_showMore.constant=96;
        Constr_viewParentHeight.constant -=h;
        [UIView animateWithDuration:0.5 animations:^{
            [LBL_aqarDisc layoutIfNeeded];
            [self.view layoutIfNeeded];

        }];
    }
    
}

- (IBAction)openInGoogleNavigator:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        //comgooglemaps://?saddr=Google+Inc,+8th+Avenue,+New+York,+NY&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit
       NSString *url= [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=driving",AqarInfoAdvertiserModel.latitude,AqarInfoAdvertiserModel.longitude];
        //[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic",AqarInfoAdvertiserModel.latitude,AqarInfoAdvertiserModel.longitude]
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك قم بثبيت تطبيق قوقل ماب للإستفادة من هذه الخدمة" andType:SWarning];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)AddToFav:(UIBarButtonItem *)sender {
    
    if (![[AqarEasyUser sharedInstance] isUserLogged]) {
        [Utility showAlert:@"عفواً" message:@"من فضلك قم بتسجيل الدخول "];
        return;
    }

    
    if (propertyModel.isFavorite) {
        propertyModel.isFavorite=NO;
        [Utility DeleteFromFav:propertyModel.nid];
        UIImage *image = [[UIImage imageNamed:@"add_favorites"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image];
         [Utility ShowAlertWithTitle:@"" andMsg:@" تم الحذف من المفضلة بنجاح" andType:SSucess];
    } else {
        propertyModel.isFavorite=YES;
        [Utility AddToFavourite:propertyModel.nid];
        UIImage *image = [[UIImage imageNamed:@"add_favorites_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image];
        [Utility ShowAlertWithTitle:@"" andMsg:@" تمت اضافتها الى المفضلة " andType:SSucess];
    }
    
}

- (IBAction)Share:(UIBarButtonItem *)sender {
    [Utility showLoading];
    
    [Utility shortenUrl:propertyModel.url.absoluteString WithComplectionBlock:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility hideLoading];
        });
        
        
        if (result&&result[@"id"]) {
            
            [self showSherMenuWithUrl:result[@"id"]];
            
        } else {
            [self showSherMenuWithUrl:propertyModel.url.absoluteString];
            
        }
        
    }];
    
    
}


-(void)showSherMenuWithUrl:(NSString*)url{
    
    NSString *string = @"AqarEasy:";
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string,url]
                                      applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];

}


-(IBAction)ShowInfo:(id)sender{

    AdvertiserInfoController *ctrl=[self.storyboard instantiateViewControllerWithIdentifier:@"AdvertiserInfoController"];
    if(AqarInfoAdvertiserModel){ctrl.model=AqarInfoAdvertiserModel;}
    else{
        [self getAqarInfoWithBloack:^(id res) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ctrl.model=AqarInfoAdvertiserModel;
                [ctrl viewDidLoad];
            });
            
        }];
    }
    
   // ctrl.view.frame=CGRectMake(0, 0, 300, 250);
    //[self presentPopUpViewController:ctrl];
    
    
    ctrl.view.frame = CGRectMake(0, 0, 300.0f, 440.0f);
    ctrl.contentSizeInPopup=ctrl.view.frame.size;
    popupController = [[STPopupController alloc] initWithRootViewController:ctrl];
    popupController.navigationBarHidden = YES;
    popupController.cornerRadius = 25;
    ctrl.parentController=popupController;
    ctrl.IMG_userImageView.image =__AdvertiserView.IMGV_user.image;

    [popupController presentInViewController:self];
}

-(IBAction)sendEmail:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"AqarEasy"];
        [mailCont setToRecipients:[NSArray arrayWithObject:propertyModel.mail]];
        [mailCont setMessageBody:@"Email message" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
/*
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}*/
- (BOOL)canAutoRotate
{
    return YES;
}


#pragma - mark
#pragma  -mark table methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ArrAqarInfo.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InfoCell class])];

    cell.LBL_key.text=ArrAqarInfo[indexPath.row][@"key"];
    cell.LBL_val.text=[NSString stringWithFormat:@"%@",ArrAqarInfo[indexPath.row][@"val"]];
    
    if (indexPath.row==4) {
        cell.LBL_val.font=[UIFont fontWithName:@"DroidArabicNaskh" size:15];
    }
    
    if (indexPath.row==ArrAqarInfo.count-1) {
        cell.VIEW_sepBottom.alpha=1;
    } else {
        cell.VIEW_sepBottom.alpha=0;

    }
    
    return cell;
}

#pragma -mark map view

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[CustomAnnotation class]]) //if this class is my custom pin class
    {
        //Try to get an unused annotation, similar to uitableviewcells
        CustomAnnotation *myLocation=(CustomAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    }
    else
        return nil;
    
}

#pragma -mark
-(void)imageTapped:(UIGestureRecognizer*)gest{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"landscacpe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *images=[[NSMutableArray alloc] init];
    for (NSString *url in AqarInfoAdvertiserModel.images) {
        FSBasicImage *img = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:@""];
        [images addObject:img];
    }
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:images];
    
    
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    //[imageViewController.view setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    UINavigationController *nav=(UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav presentViewController:navigationController animated:YES completion:nil];
}

#pragma  - mark
#pragma  - location services update layout

-(void)getNumberOfSection:(int)sections{
    
//        Constr_viewParentHeight.constant = sections *70;
//        Constr_nearByHeight.constant +=sections *70;
//        [View_NearByServices layoutIfNeeded];
//        [self.view layoutIfNeeded];

        //dispatch_async(dispatch_get_main_queue(), ^{
           // LBL_nearByServices.alpha=0;
            if (sections<1) {
                LBL_nearByServices.alpha=0;
                Constr_viewParentHeight.constant -= 100;
                Constr_nearByHeight.constant =50;
                [View_NearByServices layoutIfNeeded];
                
                View_NearByServices.alpha=0;
                [self.view layoutIfNeeded];
                
                
            }else{
                
                // Constr_viewParentHeight.constant -= (800-70*sections);
                //Constr_viewParentHeight.constant = sections*70;

                Constr_nearByHeight.constant =200+sections*70;
                [View_NearByServicesHolder layoutIfNeeded];

              Constr_bottom.constant=Constr_bottom.constant-(sections*70);
                [ViewHolder layoutIfNeeded];
                
                
               // [View_NearByServices layoutIfNeeded];
                //[self.view layoutIfNeeded];
                
            }
        //});
        
      
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
