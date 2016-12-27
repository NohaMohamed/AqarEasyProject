//
//  LoginViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/11/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "LoginViewController.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "UIViewController+ENPopUp.h"
#import "LoginPopUP.h"
#import "AqarEasyUser.h"
#import <DIOSUser.h>
#import "SWRevealViewController.h"
#import "MainViewController.h"


@interface LoginViewController ()<LoginDelg>
{
    
    
    __weak IBOutlet UITextField *TXT_userName;
    __weak IBOutlet UIButton *BTN_remember;
    __weak IBOutlet UITextField *TXT_pass;
    
    __weak IBOutlet UIView *VIEW_login;
    
    __weak IBOutlet UIButton *BTN_login;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
  
    [self makeViewWithCorner:VIEW_login];
    [self makeViewWithCorner:BTN_login];
    
    if ([[AqarEasyUser sharedInstance] getUserLoginName]) {
        TXT_userName.text=[[AqarEasyUser sharedInstance] getUserLoginName];
        TXT_pass.text=[[AqarEasyUser sharedInstance] getUserLoginPass];
        BTN_remember.selected=YES;
        [BTN_remember setImage:[UIImage imageNamed:@"check_login"] forState:UIControlStateNormal];
    }

    
   
}


- (IBAction)RememberMe:(id)sender {
    BTN_remember.selected = !BTN_remember.selected;
    if (BTN_remember.selected) {
        [BTN_remember setImage:[UIImage imageNamed:@"check_login"] forState:UIControlStateNormal];

        [[AqarEasyUser sharedInstance] setUserLoginName:TXT_userName.text];
        [[AqarEasyUser sharedInstance] setUserLoginPass:TXT_pass.text];
        
    } else {
        [BTN_remember setImage:nil forState:UIControlStateNormal];
        [[AqarEasyUser sharedInstance] Logout];
    }
    
}

-(IBAction)doLogin:(id)sender{
    
    if (TXT_userName.text.length <2||TXT_pass.text.length<2) {
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك ادخل اسم المستخدم وكلمة المرور" andType:SFail];
        return;
    }
    
    __weak typeof(self) weakself=self;
     [Utility showLoading];
    [DIOSUser userLoginWithUsername:TXT_userName.text andPassword:TXT_pass.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         [Utility hideLoading];
        if (responseObject[@"sessid"]) {
            [[AqarEasyUser sharedInstance] setLoginData:responseObject];
           
            [Utility ShowAlertWithTitle:@"" andMsg:[NSString stringWithFormat:@"مرحبا : %@",[[AqarEasyUser sharedInstance] getUserName]] andType:SSucess];
            
            //[Utility showAlert:@"" message:[NSString stringWithFormat:@"مرحبا : %@",[[AqarEasyUser sharedInstance] getUserName]]];
            
             [weakself UserDidLogin];
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            if ([newStr rangeOfString:@"Already logged in"].location !=NSNotFound) {
                
                [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [weakself doLogin:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
                    if (data.length>0) {
                        NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                        NSLog(@"===============%@",  newStr);
                    }
                    
                    
                }];
            }else if ([newStr containsString:@"CSRF validation failed"]){
                [weakself doLogin:nil];
                
            }else{
                [Utility hideLoading];
                if ([newStr rangeOfString:@"Wrong username"].location !=NSNotFound) {
                    newStr=@"كلمة المرور او اسم المستخدم غير صحيحة";
                }else{
                    
                    newStr= [Utility stringByStrippingHTML:newStr];
                }
                
                
                [Utility showAlert:@"خطأ" message:newStr];
            }
        }
    }];


}

- (void)makeViewWithCorner:(UIView*)sender{
  
    sender.layer.cornerRadius=5;
    [sender.layer setMasksToBounds:YES];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)ShowNewPassword:(UIButton *)sender {
    
    
//    UIViewController *forget=[self.storyboard instantiateViewControllerWithIdentifier:@"forgetPasswordViewController"];
//    forget.view.frame=CGRectMake(0, 0, 280, 230);
//    [self presentPopUpViewController:forget];
   
}



- (IBAction)ShowLoginPopUp:(UIButton *)sender {
    
//    LoginPopUP *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginPopUP"];
//    login.view.frame=CGRectMake(0, 0, 280, 200);
//    login.delg=self;
//    [self presentPopUpViewController:login];
//    
    

}

-(void)UserDidLogin{
  /*UINavigationController *nav=  [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"]];
    nav.title=@"الرئيسية";
    nav.navigationItem.title=@"الرئيسية";

    [self.revealViewController setFrontViewController:nav animated:YES];
    */
    if (BTN_remember.isSelected) {
        
        [[AqarEasyUser sharedInstance] setUserLoginName:TXT_userName.text];
        [[AqarEasyUser sharedInstance] setUserLoginPass:TXT_pass.text];
    }
    [self performSegueWithIdentifier:@"showHome" sender:self];
    [Utility hideLoading];
    
}



#pragma - mark
#pragma  -mark textFiled methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField==TXT_userName) {
        [TXT_pass becomeFirstResponder];
    } else if(textField==TXT_pass) {
        [self doLogin:nil];
    }
    
    return YES;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
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

- (IBAction)dismissLogin:(id)sender {
    //[self performSegueWithIdentifier:@"showMainView" sender:self];/*
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setNavigationBarHidden:NO];
    UIViewController *ctrl=[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [navController setViewControllers: @[ctrl] animated: NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];

}


@end
