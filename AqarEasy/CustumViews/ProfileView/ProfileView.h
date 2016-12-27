//
//  ProfileView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/1/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *userPasswardView;
@property (weak, nonatomic) IBOutlet UIButton *BTN_changePass;
@property (weak, nonatomic) IBOutlet UIButton *BTN_userImg;
@property (weak, nonatomic) IBOutlet UIButton *BTN_edituserImg;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtUserTelephone;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryCode;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;


@end
