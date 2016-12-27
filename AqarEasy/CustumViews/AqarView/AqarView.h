//
//  AqarView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/24/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyModel.h"
#import "AqarInfoView.h"
#import "AdvertiserView.h"

@interface AqarView : UIView
{
    PropertyModel *model;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet AqarInfoView *aqarInfoView;
@property (weak, nonatomic) IBOutlet AdvertiserView *_AdvertiserView;

@property (weak, nonatomic) IBOutlet UIButton *BTN_mail;
@property (weak, nonatomic) IBOutlet UIButton *BTN_showInfo;

-(void)setAqarInfo:(PropertyModel*)propertyModel;

-(void)loadUserImageWithUrl:(NSString*)url;
@end
