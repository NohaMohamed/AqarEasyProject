//
//  TasmeenAqaryViewController.m
//  AqarEasy
//
//  Created by Atef on 5/11/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "TasmeenAqaryViewController.h"
#import "SWRevealViewController.h"
#import <DIOSSession.h>
#import "Constant.h"
#import "Utility.h"
#import "UIKeyboardViewController.h"

@interface TasmeenAqaryViewController ()<UIKeyboardViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    
    __weak IBOutlet UITextField *TXT_mobileNum;
    __weak IBOutlet UITextField *TXT_userName;
    __weak IBOutlet UITextField *TXT_address;
    __weak IBOutlet UITextField *TXT_city;
    __weak IBOutlet UITextField *TXT_country;
    __weak IBOutlet UITextField *TXT_AqarType;
    __weak IBOutlet UIBarButtonItem *AddTasmeen;
    __weak IBOutlet UIView *VIEW_holder;
    __weak IBOutlet UITextField *TXT_email;
    
    NSArray *aqarTypeArray;
    UIPickerView *aqarTypePickerView;
    NSString *_aqarTypeId;
    UIKeyboardViewController *keyBoardController;


}
@end

@implementation TasmeenAqaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    aqarTypeArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AqarType" ofType:@"plist"]];
    
    aqarTypePickerView = [[UIPickerView alloc]init];
    aqarTypePickerView.dataSource = self;
    aqarTypePickerView.delegate = self;
    aqarTypePickerView.showsSelectionIndicator = YES;
    TXT_AqarType.inputView = aqarTypePickerView;
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    //    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
    
    // inirialize keyboard with next,prev toolbar
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [keyBoardController addToolbarToKeyboard];
    
    CGFloat navigationHeight =  self.navigationController.navigationBar.frame.size.height;
    keyBoardController.viewFrameY = navigationHeight +self.view.frame.origin.y+25;
    
    
}
- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    //    [self.myTextFiled resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==TXT_email) {
        CGRect fr= VIEW_holder.frame;
        fr.origin.y -=100;
        
        VIEW_holder.frame=fr;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitData:(UIBarButtonItem *)sender {
    NSString *country=(TXT_country.text.length>1)?TXT_country.text:@" ";
    NSString *city=(TXT_city.text.length>1)?TXT_city.text:@" ";
    NSString *address=(TXT_address.text.length>1)?TXT_address.text:@" ";
    
    if (TXT_userName.text.length < 2) {
        [Utility showAlert:@"تنبيه" message:@"من افضلك ادخل اسم المستخدم"];
        return;
    }
    if (TXT_mobileNum.text.length <3) {
        
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل رقم هاتف صحيح"];
        
        return;
    }
    if (![Utility IsValidEmail:TXT_email.text]) {
     
        [Utility showAlert:@"تنبيه" message:@"من فضلك ادخل بريد الكتروني صحيح"];
        
        return;
    }
    
    NSDictionary *dic= @{@"country":country,@"city":city,@"address":address,
    @"fullname":TXT_userName.text,@"phone":TXT_mobileNum.text,@"email":TXT_email.text,@"type":@"15"};
  
    //name,phone,email
   
    [[DIOSSession sharedSession] sendRequestWithPath:@"addTathmeen" method:@"POST" params:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]&&[responseObject count]>0&&[responseObject[0] isEqualToString:@"submission_success"]) {
            [Utility showAlert:@"نجاح" message:@"لقد تم اضافه طلبك بنجاح"];
        }else{
             [Utility showAlert:@"خطآ" message:@"لقد حدث شئ ما ، من فضلك حاول مره اخري "];
        }
        NSLog(@"===============%@",  responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [Utility showAlert:@"خطآ" message:@"لقد حدث شئ ما ، من فضلك حاول مره اخري "];
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }
    }];
    
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
  return [aqarTypeArray count];
}

#pragma mark- Picker View Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    TXT_AqarType.text=aqarTypeArray[row][@"name"];
    _aqarTypeId=aqarTypeArray[row][@"tid"];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
    return [aqarTypeArray objectAtIndex:row][@"name"];
    
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
