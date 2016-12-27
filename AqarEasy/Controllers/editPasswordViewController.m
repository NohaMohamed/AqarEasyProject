//
//  editPasswordViewController.m
//  AqarEasy
//
//  Created by Atef on 4/28/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "editPasswordViewController.h"
#import "UIViewController+ENPopUp.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "Constant.h"

@interface editPasswordViewController ()
{
    __weak IBOutlet UITextField *TXT_OldPass;
    
    __weak IBOutlet UITextField *TXT_confirm;
    __weak IBOutlet UIButton *BTN_ok;
    __weak IBOutlet UIButton *BTN_cancel;
    __weak IBOutlet UITextField *TXT_pass;
    CGRect frStart;
}
@end

@implementation editPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BTN_ok.layer.borderWidth = 1.0;
    BTN_ok.layer.borderColor = [UIColor brownColor].CGColor;
    BTN_cancel.layer.borderWidth = 1.0;
    BTN_cancel.layer.borderColor = [UIColor brownColor].CGColor;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    frStart=self.view.frame;
}
- (IBAction)OK_clicked:(UIButton *)sender {
    
//    if (TXT_pass.text.length<1||TXT_OldPass.text.length<1) {
//        [Utility showAlert:@"خطأ!" message:@"من فضلك ادخل كلمه المرور واسم المستخدم  بصوره صحيحه"];
//        return;
//    }
    
    [self dismissPopUpViewController];
    
    //[Utility showLoading];
    /*
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://aqareasy.com/services/session/token"]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSString *token=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
            [[APIControlManager sharedInstance] postDataWithUrl:URL_LOGIN withParms:@{@"username":TXT_username.text,@"password":TXT_pass.text,@"X-CSRF-Token":token} withCompletionBlock:^(id ret) {
                if (ret[@"sessid"]) {
                    //[[AqarEasyUser sharedInstance] initDataWithDic:ret];
                }
                
                [Utility hideLoading];
                
            }];
            
        }else{
            [Utility hideLoading];
            [Utility showAlert:@"خطأ" message:@"من فضلك حاول مره اخري"];
        }
        
        
        
    }];*/
    
    
    
}
- (IBAction)Cancel_clicked:(UIButton *)sender {
    
    [self dismissPopUpViewController];
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField==TXT_OldPass) {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect fr =frStart;
            
            fr.origin.y -= 30;
            self.view.frame=fr;
        } completion:^(BOOL finished) {
            
        }];
        
        
    } else if(textField==TXT_pass) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect fr =frStart;
            fr.origin.y -= 50;
            self.view.frame=fr;
        } completion:^(BOOL finished) {
            
        }];
        
    }else if(textField==TXT_confirm) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect fr =frStart;
            fr.origin.y -= 80;
            self.view.frame=fr;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField==TXT_OldPass) {
        [TXT_pass becomeFirstResponder];
        
    }if (textField==TXT_pass) {
        [TXT_confirm becomeFirstResponder];
        
    }else if(textField==TXT_confirm) {
        [self OK_clicked:nil];
    }
    
    return YES;
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
