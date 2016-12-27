//
//  forgetPasswordViewController.m
//  AqarEasy
//
//  Created by Atef on 3/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "forgetPasswordViewController.h"
#import "APIControlManager.h"
#import "UIViewController+ENPopUp.h"
#import "Utility.h"
#import "Constant.h"
#import <DIOSUser.h>
#import "SDK_API_Controller.h"
#import "AqarEasyUser.h"
@implementation forgetPasswordViewController
{


__weak IBOutlet UITextField *TXT_email;
    CGRect frStart;

    
    __weak IBOutlet UIView *VIEW_textHolder;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    frStart=self.view.frame;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //[self makeViewWithCorner:TXT_email];
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        TXT_email.text=[[AqarEasyUser sharedInstance] getUserMail];
    }
   
    VIEW_textHolder.layer.cornerRadius=7;
    [VIEW_textHolder.layer setMasksToBounds:YES];
    VIEW_textHolder.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
    VIEW_textHolder.layer.borderWidth=1;
    
}

- (void)makeViewWithCorner:(UITextField*)sender{
    
    sender.layer.borderWidth=1;;
    
    //sender.layer.cornerRadius=5;
    sender.layer.borderColor=[UIColor brownColor].CGColor;
    
}
- (IBAction)OK_clicked:(UIBarButtonItem *)sender {
    
    if([Utility IsValidEmail:TXT_email.text])
    {
        [Utility showLoading];
 
        [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"resetPassword" andHttpMethod:@"GET" andParms:@{@"email":TXT_email.text} withCompletion:^(id result, NSError *error) {
            NSLog(@"===============%@",  result);
            if (error) {
                NSLog(@"===============%@",  error);
            }else{
                [Utility showAlert:@"شكراً" message:@" تم الارسال الى بريدك الالكتروني"];
            }
            [Utility hideLoading];
        }];
        
    }else{
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل بريدالكتروني صحيح"];
    }
    
    [self Cancel_clicked:nil];
    
}
- (IBAction)Cancel_clicked:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
   /* [UIView animateWithDuration:0.2 animations:^{
        
        CGRect fr =frStart;
        
        fr.origin.y -= 60;
        self.view.frame=fr;
    } completion:^(BOOL finished) {
        
    }];
    */

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //[self OK_clicked:nil];
    return YES;
}
@end
