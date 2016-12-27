//
//  mapPopUpViewController.h
//  AqarEasy
//
//  Created by Atef on 6/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewiPhone.h"
#import "PropertyModel.h"

@protocol BTNDelg <NSObject>
@optional
-(void)ButtonClickedWithModel:(PropertyModel*)model;

@end

@interface mapPopUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet SummaryViewiPhone *View_summeryIphone;
@property(nonatomic,strong) PropertyModel *model;
@property (weak, nonatomic) IBOutlet UIButton *BtnGoToDetails;

@property(nonatomic,weak)id<BTNDelg>delg;
@end

