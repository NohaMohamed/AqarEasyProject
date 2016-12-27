//
//  RegisterViewController.m
//  AqarEasy
//
//  Created by Atef on 3/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "RegisterViewController.h"
#import "Utility.h"
#import "Constant.h"
#import <DIOSUser.h>
#import "APIControlManager.h"
#import "SDK_API_Controller.h"
#import "SelectViewController.h"
@interface RegisterViewController()<selectViewControllerDelegate>{
    
    NSMutableArray *ArrCountries;

    NSString *countryKey;
    
    
    IBOutletCollection(UIView) NSArray *VIEWS;

    __weak IBOutlet UIButton *BTN_countryCode;
}
@end

@implementation RegisterViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    originY=self.view.frame.origin.y;
}

-(void)viewDidLoad{
    [super viewDidLoad];
   // [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getCountries];
    countryKey=nil;
    
    ArrCountries=[NSMutableArray new];
    [self makeRoundCornerForViews];
}

-(void)makeRoundCornerForViews{
    
    for (UIView *view in VIEWS) {
        
        view.layer.cornerRadius=7;
        [view.layer setMasksToBounds:YES];
        view.layer.borderColor=[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1].CGColor;
        view.layer.borderWidth=1;
        
    }
}

-(void)getCountries{
    [Utility showLoading];
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"getCountries" andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        if (!error) {
            NSArray *keys=[result allKeys];
            NSArray *vals=[result allValues];
            
            for (int i=0;i<vals.count;i++) {
                [ArrCountries addObject:@{@"name":vals[i],@"code":keys[i]}];
            }
            
           
           // TXT_key.inputView = countryPickerView;
        }
        
        [Utility hideLoading];
    }];
}
- (IBAction)Cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Register:(UIBarButtonItem *)sender {
    [self touchesBegan:nil withEvent:nil];
    if (TXT_username.text.length<1) {
        [self showInputAlert];
        return;
    }
    if (TXT_email.text.length<1||![Utility IsValidEmail:TXT_email.text]) {
        [Utility showAlert:@"عفواً" message:@"البريد الإلكتروني غير صحيح"];
        return;
    }
    if (TXT_pass.text.length<1) {
        [self showInputAlert];
        return;
    }
    if (![TXT_confirm.text isEqualToString:TXT_pass.text]) {
        [Utility showAlert:@"عفواً" message:@"كلمة المرور غير متطابقة"];
        return;
    }
    if (TXT_address.text.length<1) {
        [self showInputAlert];
        return;
    }
    if (TXT_mobile.text.length<1) {
        [self showInputAlert];
        return;
    }
    if (countryKey.length<1) {
        [self showInputAlert];
        return;
    }
    
    __weak typeof(self) weakself=self;

    [Utility showLoading];
    
    NSDictionary *user = @{@"name":TXT_username.text,@"mail":TXT_email.text,@"pass":TXT_pass.text,@"field_address":@{@"und":@[@{@"value":TXT_address.text}]},@"field_telephone":@{@"und":@[@{@"number":TXT_mobile.text,@"country_codes":countryKey}]},@"field_check_test":@{@"und":@[@{@"value":@"1"}]}};
    
    
    [DIOSUser userRegister:user success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Utility hideLoading];
        if (responseObject[@"uid"]) {
            [Utility ShowAlertWithTitle:@"" andMsg:@"شكراً تم تسجيلك بنجاح" andType:SSucess];
            [weakself Cancel:nil];
        }else{
         [Utility showAlert:@"خطأ" message:@" من فضلك حاول في وقت لاحق"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utility hideLoading];
        
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            if ([newStr rangeOfString:@"Access denied for user"].location != NSNotFound) {
                
                [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [weakself Register:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
                    if (data.length>0) {
                        NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                        NSLog(@"===============%@",  newStr);
                    }
                    
                    
                }];
                
            } else {
               // newStr=[Utility stringByStrippingHTML:newStr];
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
                [Utility showAlert:@"خطأ" message:strErr];

            }
           
         }else{
            [Utility showAlert:@"خطأ" message:@" من فضلك حاول في وقت لاحق"];
            
        }

    }];

}

-(void)showInputAlert{
    [Utility showAlert:@"عفواً" message:@"من فضلك قم بتعبئة جميع البيانات"];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect fr=self.view.bounds;
        fr.origin.y=originY;
        fr.origin.y -=textField.tag;
        self.view.frame=fr;
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField==TXT_username) {
        [TXT_email becomeFirstResponder];
    } else if(textField==TXT_email){
        [TXT_pass becomeFirstResponder];
    } else if(textField==TXT_pass){
        [TXT_confirm becomeFirstResponder];
    } else if(textField==TXT_confirm){
        [TXT_address becomeFirstResponder];
    } else if(textField==TXT_address){
        [TXT_mobile becomeFirstResponder];
    } else if(textField==TXT_mobile){
       [self touchesBegan:nil withEvent:nil];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [UIView animateWithDuration:0.3 animations:^{
        CGRect fr=self.view.bounds;
        fr.origin.y=originY;
        self.view.frame=fr;
    } completion:^(BOOL finished) {
        
    }];
    [self.view endEditing:YES];
}


- (IBAction)chooseCountryCode:(id)sender {
    
    SelectViewController  *selct=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectViewController class])];
    selct.delgate=self;
    selct.arrData=ArrCountries;
    [self presentViewController:selct animated:YES completion:nil];
}


-(void)tableSelctedWithResult:(NSDictionary *)dic{
    
    [BTN_countryCode setTitle:dic[@"name"] forState:UIControlStateNormal];
    countryKey=dic[@"code"];
    [self dismissViewControllerAnimated:YES completion:nil];
  
}

-(void)userCancelSelect{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
