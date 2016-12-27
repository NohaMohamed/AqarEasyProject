//
//  AdvertiserInfoController.h
//  AqarEasy
//
//  Created by Atef on 6/1/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyModel.h"
#import "STPopupController.h"

@interface AdvertiserInfoController : UIViewController
@property(strong,nonatomic)PropertyModel *model;
@property(weak,nonatomic)UIImage*userImage;
@property (weak, nonatomic) IBOutlet UIImageView *IMG_userImageView;
@property (weak, nonatomic) IBOutlet UILabel *LBL_ownerName;
@property(weak,nonatomic)STPopupController *parentController;
@property (weak, nonatomic) IBOutlet UILabel *LBL_address;
@property (weak, nonatomic) IBOutlet UILabel *LBL_email;
@property (weak, nonatomic) IBOutlet UILabel *LBL_phone;
@property (weak, nonatomic) IBOutlet UILabel *LBL_createdDate;
@property (weak, nonatomic) IBOutlet UILabel *LBL_updatedDate;
@property (weak, nonatomic) IBOutlet UILabel *LBL_aqarCount;
- (IBAction)closeButtonAction:(UIButton *)sender;

@end
