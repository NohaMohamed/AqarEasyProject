//
//  SlidingMenuController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/13/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "SlidingMenuController.h"
#import "SWRevealViewController.h"
#import "ProfileViewController.h"
#import "AqarClassificationViewController.h"
#import "AqarEasyUser.h"
#import "LoginPopUP.h"
#import "UIViewController+ENPopUp.h"
#import "Utility.h"
#import <DIOSUser.h>
#import "LoginViewController.h"
@interface SlidingMenuController ()<LoginDelg>
{
    
    
    __weak IBOutlet UILabel *LBL_userName;
    __weak IBOutlet UIView *VIEW_loginSignUp;
    
    
    __weak IBOutlet UIView *VIEW_sepLogin;
    
    __weak IBOutlet UIView *VIEW_sepMain;
    IBOutletCollection(UITableViewCell) NSArray *CollectCells;
    
   
}
@end

@implementation SlidingMenuController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUserLoginData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     // ArrCells= @[@[headerCell],@[sec1cell0,sec1cell1,sec1cell2],@[sec2cell1,AddAqarCell,sec2cell3],@[sec3cell2,sec3cell3,sec3cell4,sec3cell5]];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [self resizeTableView:self.view.frame.size.width * 0.8f];
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self resizeView];
        }
        [self resizeTableView:self.view.frame.size.width * 0.25f];
    }
    
    self.revealViewController.rearViewRevealWidth = self.tableView.frame.size.width;
    self.revealViewController.rearViewRevealOverdraw = 0;

    // set text of AddAdCell label with two different size
    UIFont *font1 = [UIFont fontWithName:@"GESSTwoLight-Light" size:16];
    NSDictionary *firstDic = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:@"هل لديك عقار تود عرضه؟ \r\r  إعلن عن عقارك الان" attributes: firstDic];

    UIFont *font2 = [UIFont fontWithName:@"GESSTwoLight-Light" size:20];
    NSDictionary *secondDec = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:@" مجانا" attributes: secondDec];
    
    [aAttrString1 appendAttributedString:aAttrString2];
    self.footerLabel.attributedText = aAttrString1;
    
    
    for (UITableViewCell *cell in CollectCells) {
        
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
}

-(void)setUserLoginData{
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        [VIEW_loginSignUp setHidden:YES];
        [LBL_userName setHidden:NO];
        VIEW_sepLogin.alpha=1;
        LBL_userName.text=[NSString stringWithFormat:@"مرحباً : %@",[[AqarEasyUser sharedInstance] getUserName]];
    } else {
        VIEW_sepLogin.alpha=0;
        [VIEW_loginSignUp setHidden:NO];
        [LBL_userName setHidden:YES];
        
    }
    [self.tableView reloadData];
}

-(void)resizeView{
    //Change the width of a table view
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width = self.view.frame.size.height;
    viewFrame.size.height = self.view.frame.size.width;
    self.view.frame = viewFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)resizeTableView:(CGFloat)newWidth {
    //Change the width of a table view
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = newWidth;
    self.tableView.frame = tableViewFrame;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat statusBarHeight;

    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) &&([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad))
    {
        statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.width;    }
    else{
        statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    //(indexPath.row == 3) this is MapSearchCell
    //(indexPath.row == 4) this is AddAdCell
    if((indexPath.section == 3) && ((indexPath.row == 5) || (indexPath.row == 4)))
       {
           CGFloat hieght=((self.tableView.frame.size.height-statusBarHeight)/14)*2.5;
           return hieght;
       }
    else if (indexPath.section==0){
        return 64;
    }else if(indexPath.section==2&&indexPath.row==4){
        return 100;
    }else
       {
           CGFloat hieght=(self.tableView.frame.size.height-statusBarHeight)/14;
           return hieght;
       }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
      
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 6;
                break;
            case 2:
                return 6;
                break;
            default:
                return 0;
                break;
        }

        
    } else {
        
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 6;//incase he didin't login make it 2
                break;
            default:
                return 0;
                break;
        }

        
    }
    
    
}

/*
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;//=ArrCells[indexPath.section][indexPath.row];
    //cell.backgroundColor=[UIColor clearColor];
    //cell.contentView.backgroundColor=[UIColor clearColor];
    if (indexPath.row==1&&indexPath.section==1) {
        if ([[AqarEasyUser sharedInstance] isUserLogged]) {
            [VIEW_loginSignUp setHidden:YES];
            [LBL_userName setHidden:NO];
            
            LBL_userName.text=[NSString stringWithFormat:@"مرحبا : %@",[[AqarEasyUser sharedInstance] getUserName]];
        } else {
            [VIEW_loginSignUp setHidden:NO];
            [LBL_userName setHidden:YES];
            
            
        }
        
        
    }
    
    if (!cell) {
        cell=[UITableViewCell new];
    }
    return cell;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (indexPath.section==1&&indexPath.row==5) {
        
        [self Logout:nil];

    }else if (indexPath.row==1&&indexPath.section==2) {

        if ([[AqarEasyUser sharedInstance] isUserLogged]) {

            [self performSegueWithIdentifier:@"addAqarNewDesign" sender:self];
        }else{
            [Utility showAlert:@"عفواً" message:@"من فضلك قم بتسجيل الدخول "];
        }
        
    }else if ([[AqarEasyUser sharedInstance] isUserLogged]&&indexPath.row==2&&indexPath.section==1){
        [self performSegueWithIdentifier:@"showMyAqars" sender:self];
    }else if (indexPath.section==2&&indexPath.row==4){
        //[self performSegueWithIdentifier:@"" sender:self];
    }
    
}

- (IBAction)Logout:(id)sender {
    
    [Utility showLoading];
    [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===============%@",  responseObject);
        [[AqarEasyUser sharedInstance] Logout];
        
        
        [self UserDidLogin];
        [Utility hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@",  newStr);
        }
        
        [Utility hideLoading];
    }];

    
}


- (IBAction)ShowLoginPoUp:(id)sender {
    
   /*UIViewController *loginCtrl= [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
    [self.revealViewController setFrontViewController:loginCtrl animated:YES];
    */
    [self performSegueWithIdentifier:@"showLoginController" sender:self];
    //[self.navigationController pushViewController:loginCtrl animated:YES];
//    
//    LoginPopUP *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginPopUP"];
//    login.view.frame=CGRectMake(0, 0, 280, 200);
//    login.delg=self;
//    [self presentPopUpViewController:login];
//    
}

-(void)UserDidLogin{
    [self setUserLoginData];
}


- (IBAction)ShowSignUp:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"regNavigation"] animated:YES completion:nil];
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString:@"Favourite_Segue"]) {
        AqarClassificationViewController *aqarClassificationController = (AqarClassificationViewController*)segue.destinationViewController;
 
        aqarClassificationController.aqarClassification = favourite;
    }
    else if ([segue.identifier isEqualToString:@"Sale_Segue"]) {
        AqarClassificationViewController *aqarClassificationController = (AqarClassificationViewController*)segue.destinationViewController;
        
        aqarClassificationController.aqarClassification = sale;
    }
    else if ([segue.identifier isEqualToString:@"Rent_Segue"]) {
        
        AqarClassificationViewController *aqarClassificationController = (AqarClassificationViewController*)segue.destinationViewController;
        
        aqarClassificationController.aqarClassification = rent;
        
    }else if ([segue.identifier isEqualToString:@"showMyAqars"]){
        AqarClassificationViewController *aqarClassificationController = (AqarClassificationViewController*)segue.destinationViewController;
        
        aqarClassificationController.aqarClassification = myaqars;
        
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}
@end
