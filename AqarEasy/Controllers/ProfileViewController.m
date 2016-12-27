//
//  ProfileViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/17/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "ProfileView.h"
#import "UIViewController+ENPopUp.h"
#import "Constant.h"
#import "Utility.h"
#import "APIControlManager.h"
#import "SDK_API_Controller.h"
#import "UIcolor+PlaceHolder.h"
#import "AqarEasyUser.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIKeyboardViewController.h"
#import "Utility.h"
#import "ImagePicker+orientation.h"
#import <DIOSFile.h>
#import <DIOSSession.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface ProfileViewController ()<UIKeyboardViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIKeyboardViewController *keyBoardController;

    NSArray *ArrCountriesKeys;
    
    NSArray *ArrCountriesValues;
    UIPickerView *countryPickerView;
    NSString *countryKey;

    __weak IBOutlet ProfileView *_profileView;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGR];
    
    
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [keyBoardController addToolbarToKeyboard];
    
    CGFloat navigationHeight =  self.navigationController.navigationBar.frame.size.height;
    keyBoardController.viewFrameY = navigationHeight+ _profileView.frame.origin.y+10;
    
    
    [_profileView.BTN_changePass addTarget:self action:@selector(showCahngePassPopUp:) forControlEvents:UIControlEventTouchUpInside];
   
    [_profileView.BTN_userImg addTarget:self action:@selector(ChangeUserImg:) forControlEvents:UIControlEventTouchUpInside];
    [_profileView.BTN_edituserImg addTarget:self action:@selector(ChangeUserImg:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getCountries];
    [self getUserImg];
}

-(void)getUserImg{
  NSString *url= [[AqarEasyUser sharedInstance] getUserImgUrl];
    
   
    if (url) {
        [[SDImageCache sharedImageCache] removeImageForKey:url];
        [_profileView.BTN_userImg sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Profile_picture.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage *img= [Utility makeRoundedImage:image];
            [_profileView.BTN_userImg setImage:img forState:UIControlStateNormal];
        }];
    }
}


-(void)getCountries{
    [Utility showLoading];
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"getCountries" andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        if (!error) {
            ArrCountriesValues=[result allValues];
            ArrCountriesKeys=[result allKeys];
            
            countryPickerView = [[UIPickerView alloc]init];
            countryPickerView.dataSource = self;
            countryPickerView.delegate = self;
            countryPickerView.showsSelectionIndicator = YES;
            _profileView.txtCountryCode.inputView = countryPickerView;
        }
        
        [Utility hideLoading];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _profileView.txtCountryCode.delegate=self;
    _profileView.txtEmail.delegate=self;
    _profileView.txtUserAddress.delegate=self;
    _profileView.txtUserName.delegate=self;
    _profileView.txtUserTelephone.delegate=self;
    
    
    [_profileView.txtEmail ChangePlaceHolederWithColor:[UIColor whiteColor]];
    [_profileView.txtCountryCode ChangePlaceHolederWithColor:[UIColor whiteColor]];
    [_profileView.txtUserAddress ChangePlaceHolederWithColor:[UIColor whiteColor]];
    [_profileView.txtUserName ChangePlaceHolederWithColor:[UIColor whiteColor]];
    [_profileView.txtUserTelephone ChangePlaceHolederWithColor:[UIColor whiteColor]];
    
    
    _profileView.txtEmail.text=[AqarEasyUser sharedInstance].getUserMail;
    _profileView.txtCountryCode.text=[AqarEasyUser sharedInstance].getUserCountryCode;
    countryKey=[AqarEasyUser sharedInstance].getUserCountryCode;
    _profileView.txtUserAddress.text=[AqarEasyUser sharedInstance].getUserAddress;
    _profileView.txtUserName.text=[AqarEasyUser sharedInstance].getUserName;
    _profileView.txtUserTelephone.text=[AqarEasyUser sharedInstance].getUserTelephone;
    //[_profileView.BTN_userImg sd_setImageWithURL:[NSURL URLWithString:[AqarEasyUser sharedInstance].getUserImgUrl] forState:UIControlStateNormal];
    
       
    
}

-(void)showCahngePassPopUp:(UIButton*)sender{
   
    UIViewController *forget=[self.storyboard instantiateViewControllerWithIdentifier:@"forgetPasswordViewController"];
    forget.view.frame=CGRectMake(0, 0, 280, 200);
    [self presentPopUpViewController:forget];
    


}

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}


-(void)ChangeUserImg:(UIButton*)sender{
   
    [[NSUserDefaults standardUserDefaults] setObject:@"allowOrientation" forKey:@"orn"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (IS_OS_8_OR_LATER) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"من فضلك اختر"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* photolib = [UIAlertAction
                                       actionWithTitle:@"مكتبه الصور"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           [self showPhotlibrary];
                                       }];
            
            UIAlertAction* camera = [UIAlertAction
                                     actionWithTitle:@"الكاميرا"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [self showCamera];
                                     }];
            [alert addAction:photolib];
            [alert addAction:camera];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"" message:@"من فضلك اختر" delegate:self cancelButtonTitle:@"مكتبه الصور" otherButtonTitles:@"الكاميرا", nil] show];
        }
        
    }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 1) {
            [self showCamera];
        }else{
            [self showPhotlibrary];
        }
}
    
    
-(void)showCamera{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
}
-(void)showPhotlibrary{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
    
        //[imagePickerController preferredInterfaceOrientationForPresentation
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
       UIImage *img= [Utility makeRoundedImage:image];
        [_profileView.BTN_userImg setImage:img forState:UIControlStateNormal];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [[NSUserDefaults standardUserDefaults] setObject:@"disableOrientation" forKey:@"orn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            
        }];
}
    

- (IBAction)updateUserData:(UIBarButtonItem *)sender {
    
  
    
    if (![Utility IsValidEmail:_profileView.txtEmail.text]) {
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل بريد الكتروني صحيح"];
        return;
    }
    
    if (_profileView.txtUserAddress.text.length<2) {
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل عنوان صحيح"];
        return;
    }
    
    if (_profileView.txtUserTelephone.text.length<2) {
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل رقم هاتف صحيح"];
        return;
    }
    
    if (_profileView.txtCountryCode.text.length<1) {
        [Utility showAlert:@"تنبيه" message:@"من فضلك اختر الدوله"];
        return;
    }
    
    
    
     [Utility showLoading];
    
    NSMutableDictionary *parms=[NSMutableDictionary new];
    
    [parms setObject:_profileView.txtEmail.text forKey:@"mail"];
    [parms setObject:_profileView.txtUserAddress.text forKey:@"address"];
    [parms setObject:_profileView.txtUserTelephone.text forKey:@"telephone"];
    [parms setObject:countryKey forKey:@"telephone_country_code"];
    [parms setObject:@"1" forKey:@"accept_rules"];
   
    
    UIImage *img=[_profileView.BTN_userImg imageForState:UIControlStateNormal];
    UIImage* temp=[Utility imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
  
    
    NSData *imageData = UIImagePNGRepresentation(temp);
    
    NSString *base64Image =[[DIOSSession sharedSession] getbase64FromData:imageData];
    
    
    
    NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
    
    [file setObject:base64Image forKey:@"file"];
    //  NSString *timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    NSString *imageTitle = [Utility randomStringWithLength:8];
    NSString *filePath = [NSString stringWithFormat:@"%@%@.png",@"public://", imageTitle];
    NSString *filename = [NSString stringWithFormat:@"%@.png", imageTitle];
    [file setObject:filePath forKey:@"filepath"];
    [file setObject:filename forKey:@"filename"];
    
    [DIOSFile fileSave:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"file>>>===============%@",  responseObject);
        //[file setObject:[responseObject objectForKey:@"fid"] forKey:@"fid"];
       // [file removeObjectForKey:@"file"];
        
        if ([responseObject objectForKey:@"fid"]) {
            
            [parms setObject:[responseObject objectForKey:@"fid"] forKey:@"picture"];
        }
        
        [[APIControlManager sharedInstance] nativePostWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,@"updateMyProfile"] withParms:parms andImg:nil withImgKeyName:@"" withCompletionBlock:^(id ret) {
            
            [Utility hideLoading];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utility showAlert:@"نجاح" message:@"لقد تم تعديل بياناتك بنجاح"];
                
                if ([ret isKindOfClass:[NSDictionary class]]) {
                    if ([ret[@"status"] isEqualToString:@"success"]) {
                        [[AqarEasyUser sharedInstance] setUserUpdateData:ret[@"data"]];
                    }
                }
                
            });
            
        }];
        
        
        //        [self setFileData:file];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
        
        [Utility hideLoading];
    }];
    
    
    
   
    
   
 
    //@"old_pass":@"1234567",@"new_pass":@"1234567"
    
   // UIImage *img=[_profileView.BTN_userImg imageForState:UIControlStateNormal];
    
    
    
 
    
    
    
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField==_profileView.txtUserAddress) {
        [_profileView.txtEmail becomeFirstResponder];
    } else if(textField==_profileView.txtEmail){
        [_profileView.txtUserTelephone becomeFirstResponder];
    } else if(textField==_profileView.txtUserTelephone){
        [_profileView.txtCountryCode becomeFirstResponder];
    } 
    
    return YES;
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ArrCountriesValues.count;
}

#pragma mark- Picker View Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _profileView.txtCountryCode.text=ArrCountriesValues[row];
    countryKey=ArrCountriesKeys[row];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return ArrCountriesValues[row];
}





@end
