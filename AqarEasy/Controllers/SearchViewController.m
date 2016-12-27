//
//  SearchViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "SearchViewController.h"
#import "SelectViewController.h"
#import "addAqarViewModel.h"
#import "SWRevealViewController.h"
#import "AqarClassificationViewController.h"
@interface SearchViewController ()<selectViewControllerDelegate,AddAqarViewModelDelg>
{
    addAqarViewModel *addAqarVM;
    NSMutableArray *ArrRegions;
    NSMutableArray *ArrAqarType;
    
    NSMutableArray *ArrayCities;
    NSMutableArray *ArrayStreets;
    NSMutableArray *ArrayCountries;
    NSArray *ArrayCoin;
    
    NSString *CurrentTxasonmy;
    //NSString* AqarTypeId;
    NSString *carSationValue;
    NSString *countryId;
    NSString *cityId;
    __weak IBOutlet UISegmentedControl *SegmentContractType;

    IBOutletCollection(UIView) NSArray *VIEWS_Services;
    

    
}
@end

#define TAXSOMY_REGION @"Region"
#define TAXSOMY_COUNTRY @"Country"
#define TAXSOMY_CITY @"City"
#define TAXSOMY_STREET @"Street"
#define TAXSOMY_AqarType @"aqarType"

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self chooseContractType:SegmentContractType];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGR];
    
    // initialize keyboard with next,prev toolbar
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [keyBoardController addToolbarToKeyboard];
    

   CGFloat navigationHeight =  self.navigationController.navigationBar.frame.size.height;
    keyBoardController.viewFrameY = navigationHeight + self.view.frame.origin.y;
    
    [self makeRoundCornerForViews];
    
    carSationValue=@"no";
    countryId=@"";
    cityId=@"";
    _SRprice_from=@"10000";
    _SRprice_to=@"10000000";
    addAqarVM=[[addAqarViewModel alloc] init];
    addAqarVM.delg=self;
    
    [addAqarVM getDatafromServerWithTaxsonomy:location andParent:@"0"];
    //_SRcontract_type=@"658";//default rent

    [self initializeSliders];
    
    
    [SegmentContractType.layer setCornerRadius:5];
    [SegmentContractType.layer setMasksToBounds:YES];
    
    for (UIView *view in VIEWS_Services) {
        
        view.layer.cornerRadius=7;
        [view.layer setMasksToBounds:YES];
        view.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
        view.layer.borderWidth=1;
        
    }
    _LBL_bathRoomCount.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
    _LBL_bathRoomCount.layer.borderWidth=1;
    
    _LBL_bedRoomCount.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
    _LBL_bedRoomCount.layer.borderWidth=1;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNearByPopupView:) name:@"NearByButtonPressed" object:nil];
    
}

-(void)initializeSliders{
    [priceRangeSliderView layoutIfNeeded];
    //initialize price slider
    _priceSlider = [[RangeSlider alloc] initWithFrame:priceRangeSliderView.bounds];
    _priceSlider.minimumValue = 1;
    _priceSlider.selectedMinimumValue = 1;
    _priceSlider.maximumValue = 10;
    _priceSlider.selectedMaximumValue = 10;
    _priceSlider.minimumRange = 2;
    [_priceSlider addTarget:self action:@selector(updatePriceRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [priceRangeSliderView addSubview:_priceSlider];
}
-(void)updatePriceRangeLabel:(RangeSlider *)slider{
    
    //Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *max = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMaximumValue*1000000]];
    
    NSString *min = [formatter stringFromNumber:[NSNumber numberWithFloat:slider.selectedMinimumValue*10000]];
    //min= [min stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //max= [max stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *price=[NSString stringWithFormat:@"السعر من  %@ الى %@ دولار", min, max];
    LBL_price.text=price;
    
    _SRprice_from=min;
    _SRprice_to=max;
    
}


- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)showNearByPopupView:(NSNotification *)notification {
    NSLog(@"NearByButtonPressed");
    
    CGFloat statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect popUpFrame = self.navigationController.view.bounds;
    popUpFrame.origin.y = statusBarHeight;
    popUpFrame.size.height = popUpFrame.size.height - statusBarHeight ;
    
    self.nearByViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NearByView"];
    
    self.nearByViewController.view.frame = popUpFrame;
    
    [self.nearByViewController showInView:self.navigationController.view  animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search:(id)sender {
    
    [self performSegueWithIdentifier:@"showSearchResult" sender:self];
    
    bool validate = [self validation];
    NSLog(@"validate:%@",validate?@"YES":@"NO");
    if(validate)
        [self.delegate searchViewControllerDidSearch:self];
}

- (IBAction)cancel:(id)sender {
    [self performSegueWithIdentifier:@"goToMainView" sender:self];
    
    [self.delegate searchViewControllerDidCancel:self];
}

- (void)dealloc {
  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)makeRoundCornerForViews{
    
    for (UIView *view in VIEWS) {
        
        view.layer.cornerRadius=7;
        [view.layer setMasksToBounds:YES];
        view.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
        view.layer.borderWidth=1;
        
    }
}

- (IBAction)chooseAqarType:(id)sender {
    
    SelectViewController  *selct=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectViewController class])];
    selct.delgate=self;
    selct.arrData=ArrAqarType;
    CurrentTxasonmy=TAXSOMY_AqarType;
    [self presentViewController:selct animated:YES completion:nil];
}

- (IBAction)chooseContractType:(UISegmentedControl*)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            _SRcontract_type=@"658";
            break;
            
        case 1:
            _SRcontract_type=@"659";
            break;
    }
    
    
   /* for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:123.0/255.0 green:112.0/255.0 blue:87.0/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setBackgroundColor:[UIColor whiteColor]];
        }
    }
*/
    
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

#pragma -mark
#pragma -mark slection method

-(void)tableSelctedWithResult:(NSDictionary*)dic{
    
    if ([CurrentTxasonmy isEqualToString:TAXSOMY_REGION]) {
        _tid=dic[@"tid"];
        LBL_region.text=dic[@"name"];
        [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_COUNTRY];
        
    } else if([CurrentTxasonmy isEqualToString:TAXSOMY_COUNTRY]){
        _tid=dic[@"tid"];
        countryId=dic[@"tid"];
        LBL_countries.text=dic[@"name"];
        
        [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_CITY];
        
    } else if([CurrentTxasonmy isEqualToString:TAXSOMY_CITY]){
        _tid=dic[@"tid"];
        cityId=dic[@"tid"];
        LBL_city.text=dic[@"name"];
        [addAqarVM getDatafromServerWithtype:location andParent:dic[@"tid"] andDifeerType:TAXSOMY_STREET];
        
    }else if ([CurrentTxasonmy isEqualToString:TAXSOMY_STREET]){
        _tid=dic[@"tid"];
        LBL_street.text=dic[@"name"];
        
    }else if([CurrentTxasonmy isEqualToString:TAXSOMY_AqarType]) {
        
        LBL_aqarType.text=dic[@"name"];
        _SRtype=dic[@"tid"];
        
    }
    
    NSLog(@"_tid===================%@",_tid);

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)userCancelSelect{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma  -mark
#pragma  -mark add aqar view model

-(void)resultFromTaxsonomy:(NSArray*)arr andDiffer:(NSString*)differ{
    
    if ([differ isEqualToString:TAXSOMY_CITY]) {
        ArrayCities=[NSMutableArray arrayWithArray:arr];;
        
    } else if([differ isEqualToString:TAXSOMY_COUNTRY]){
        ArrayCountries=[NSMutableArray arrayWithArray:arr];
    }else if([differ isEqualToString:TAXSOMY_STREET]) {
        ArrayStreets=[NSMutableArray arrayWithArray:arr];;
        
    }
    
    
}

-(void)regionFromServer:(NSArray*)arr{
    ArrRegions=[NSMutableArray arrayWithArray:arr];
    
}

-(void)getAqarTypeFromServer:(NSArray*)arr{
    ArrAqarType=[NSMutableArray arrayWithArray:arr];
    
}

#pragma -mark
#pragma -mark
- (IBAction)increaseDecreaseBedRoomCount:(id)sender {
    //1 increase
    int cnt=[_LBL_bedRoomCount.text intValue];
    if ([sender tag]==1) {
        
        cnt= (cnt >= 6) ? 6 : cnt+1;
        _LBL_bedRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
        
    } else {
        cnt= (cnt <= 1)?1:cnt-1;
        _LBL_bedRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
    }
}
- (IBAction)increaseDecreaseBathRoomCount:(id)sender {
    //1 increase
    
    int cnt=[_LBL_bathRoomCount.text intValue];
    if ([sender tag]==1) {
        
        cnt= (cnt >=6)?6:cnt+1;
        _LBL_bathRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
        
    } else {
        cnt= (cnt <= 1)?1:cnt-1;
        _LBL_bathRoomCount.text=[NSString stringWithFormat:@"%d",cnt];
    }
    
}
- (IBAction)changeCarStation:(UISegmentedControl*)sender {
    
    carSationValue=(sender.selectedSegmentIndex==0)?@"no":@"yes";
    
}

-(BOOL)validation{
    return YES;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    if ([segue.identifier isEqualToString:@"showSearchResult"]) {
        
       AqarClassificationViewController *ctrl =segue.destinationViewController;
        ctrl.aqarClassification=searchResult;
        [ctrl searchViewControllerDidSearch:self];
    }
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setNavigationBarHidden:NO];
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
        };
        
    }
    
}
@end
