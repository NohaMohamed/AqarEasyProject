//
//  LoginPopUP.m
//  AqarEasy
//
//  Created by Atef on 3/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "LoginPopUP.h"
#import "UIViewController+ENPopUp.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "Constant.h"
#import "AqarEasyUser.h"
#import <DIOSUser.h>
#import "SDK_API_Controller.h"
#import <DIOSSession.h>
#import <DIOSFile.h>
#import "UIcolor+PlaceHolder.h"
@implementation LoginPopUP
{
    __weak IBOutlet UITextField *TXT_username;
    
    __weak IBOutlet UIButton *BTN_ok;
   // __weak IBOutlet UIButton *BTN_cancel;
    __weak IBOutlet UITextField *TXT_pass;
    CGRect frStart;
}


-(void)viewDidLoad{
    [super viewDidLoad];
   
    
    BTN_ok.layer.borderWidth = 1.0;
    BTN_ok.layer.borderColor = [UIColor brownColor].CGColor;
    [self makeViewWithCorner:TXT_pass];
    [self makeViewWithCorner:TXT_username];
  //  BTN_cancel.layer.borderWidth = 1.0;
    //BTN_cancel.layer.borderColor = [UIColor brownColor].CGColor;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TXT_pass ChangePlaceHolederWithColor:[UIColor blackColor]];
    [TXT_username ChangePlaceHolederWithColor:[UIColor blackColor]];
}

- (void)makeViewWithCorner:(UITextField*)sender{
    
    sender.layer.borderWidth=1;;
    
    //sender.layer.cornerRadius=5;
    sender.layer.borderColor=[UIColor brownColor].CGColor;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    frStart=self.view.frame;
}
- (IBAction)OK_clicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (TXT_pass.text.length<1||TXT_username.text.length<1) {
        [Utility showAlert:@"خطأ!" message:@"من فضلك ادخل كلمه المرور واسم المستخدم  بصوره صحيحه"];
        return;
    }
    
     [Utility showLoading];
   
   
    __weak typeof(self) weakself=self;
    
    [DIOSUser userLoginWithUsername:TXT_username.text andPassword:TXT_pass.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject[@"sessid"]) {
            [[AqarEasyUser sharedInstance] setLoginData:responseObject];
            [[AqarEasyUser sharedInstance] setUserLoginName:TXT_username.text];
            [[AqarEasyUser sharedInstance] setUserLoginPass:TXT_pass.text];
            [Utility hideLoading];
          //  [self getFile];
            //[self addImg];
            if (weakself.delg) {
                if ([weakself.delg respondsToSelector:@selector(UserDidLogin)]) {
                    [weakself.delg UserDidLogin];
                }
            }
            [self dismissPopUpViewController];
        }else{
            [Utility hideLoading];
            [Utility showAlert:@"خطأ" message:@"من فضلك حاول مره اخري"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            if ([newStr rangeOfString:@"Already logged in"].location !=NSNotFound) {
                
                [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [weakself OK_clicked:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
                    if (data.length>0) {
                        NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                        NSLog(@"===============%@",  newStr);
                    }
                    
                    
                }];
            }else{
                [Utility hideLoading];
                if ([newStr rangeOfString:@"Wrong username"].location !=NSNotFound) {
                    newStr=@"كلمه المرور او اسم المستخدم غير صحيحه";
                }else{
                    
                    newStr= [Utility stringByStrippingHTML:newStr];
                }

                
                [Utility showAlert:@"خطأ" message:newStr];
            }
        }else{
            
            [Utility hideLoading];
            NSString *err=[error localizedDescription];
            if ([err rangeOfString:@"Wrong username"].location !=NSNotFound) {
                err=@"كلمه المرور او اسم المستخدم غير صحيحه";
            }else{

               err= [Utility stringByStrippingHTML:err];
            }
            [Utility showAlert:@"خطأ" message:err];
        }

    }];
    
  
    
}




-(void)getFile{
    [DIOSFile fileGet:@{@"fid":@"1809"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===============%@",  responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"===============%@",  str);
        
    }];
}

-(void)addImg{
   /* NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"test.png"],1.0);
    
    NSString *base64Image =[[DIOSSession sharedSession] getbase64FromData:imageData];

    
    
    NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
    
    [file setObject:base64Image forKey:@"file"];
  //  NSString *timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    NSString *imageTitle = [@"atef" stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",@"public://", imageTitle];
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", imageTitle];
    [file setObject:filePath forKey:@"filepath"];
    [file setObject:filename forKey:@"filename"];
  
    [DIOSFile fileSave:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"file>>>===============%@",  responseObject);
        [file setObject:[responseObject objectForKey:@"fid"] forKey:@"fid"];
        [file removeObjectForKey:@"file"];
        
//        [self setFileData:file];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
       
        
    }];*/
    /*
    NSMutableDictionary *fileData = [NSMutableDictionary new];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"test.png"]);
    [fileData setObject:@"temp" forKey:@"name"];
    [fileData setObject:@"temp.jpg" forKey:@"fileName"];
    NSString *base64Image =[[DIOSSession sharedSession] getbase64FromData:imageData];
    [fileData setObject:base64Image forKey:@"files[anything]"];
    
    
    [fileData setObject:@"image/png" forKey:@"mimetype"];
    [fileData setObject:@"field_image" forKey:@"field_name"];
    [fileData setObject:@"740" forKey:@"nid"];
    
    
    // [node nodeAttachFile:fileData];
    
    //@"%@node/%@/attach_file"
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"node/740/attach_file" andHttpMethod:@"POST" andParms:fileData withCompletion:^(id result, NSError *error) {
        NSLog(@"===============%@",  result);
        NSLog(@"===============%@",  error);
    }];

*/
}
- (IBAction)Cancel_clicked:(UIButton *)sender {
    
    [self dismissPopUpViewController];
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField==TXT_username) {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect fr =frStart;
            
            fr.origin.y -= 30;
            self.view.frame=fr;
        } completion:^(BOOL finished) {
            
        }];
     
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect fr =frStart;
            fr.origin.y -= 50;
            self.view.frame=fr;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField==TXT_username) {
        [TXT_pass becomeFirstResponder];
        
    } else if(textField==TXT_pass) {
        [self OK_clicked:nil];
    }
    
    return YES;
}

#pragma - mark
#pragma - mark textfield deleagte
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}*/

@end
