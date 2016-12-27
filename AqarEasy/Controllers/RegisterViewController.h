//
//  RegisterViewController.h
//  AqarEasy
//
//  Created by Atef on 3/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    float originY;
    
    __weak IBOutlet UITextField *TXT_mobile;
    __weak IBOutlet UITextField *TXT_address;
    __weak IBOutlet UITextField *TXT_confirm;
    __weak IBOutlet UITextField *TXT_pass;
    __weak IBOutlet UITextField *TXT_email;
    __weak IBOutlet UITextField *TXT_username;
}
@end
