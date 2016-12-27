//
//  AdvertiserInfoController.m
//  AqarEasy
//
//  Created by Atef on 6/1/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "AdvertiserInfoController.h"

@implementation AdvertiserInfoController

-(void)viewDidLoad{
    [super viewDidLoad];
    if (_model) {
       _LBL_address.text=([_model.address isKindOfClass:[NSString class]])?_model.address:@"";;
       _LBL_createdDate.text=_model.createdDate;
       _LBL_email.text=([_model.mail isKindOfClass:[NSString class]])?_model.mail:@"";;
       _LBL_ownerName.text=([_model.AdvertiserName isKindOfClass:[NSString class]])?_model.AdvertiserName:@"";
       _LBL_phone.text=([_model.Mobile isKindOfClass:[NSString class]])?_model.Mobile:@"";
       _LBL_updatedDate.text=_model.updateddate;
        if (_LBL_phone.text.length>=1) {
            NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            _LBL_phone.attributedText = [[NSAttributedString alloc] initWithString:_LBL_phone.text attributes:underlineAttribute];
            
            
        }
        _IMG_userImageView.layer.cornerRadius = _IMG_userImageView.frame.size.width/2;
        _IMG_userImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
        _IMG_userImageView.layer.borderWidth = 3;
        [_IMG_userImageView setClipsToBounds:YES];
        
    }
    
    
}
- (IBAction)CallAdvertiser:(UIButton *)sender {
    if ([_model.Mobile isKindOfClass:[NSString class]]&&_model.Mobile.length>2) {
        
        NSString *phNo = _model.Mobile;
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            [[[UIAlertView alloc]initWithTitle:@"تنبيه" message:@"الاتصال غير متاح" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
            
        }
        
    }
}

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self.parentController dismiss];
}
@end
