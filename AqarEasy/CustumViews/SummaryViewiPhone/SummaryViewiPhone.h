//
//  SummaryViewiPhone.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsView.h"
#import "PropertyModel.h"

@interface SummaryViewiPhone : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
//@property (weak, nonatomic) IBOutlet AssetsView *assetsView;
@property (weak, nonatomic) IBOutlet UIButton *favouritebutton;
@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)PropertyModel *model;


@property (weak, nonatomic) IBOutlet UIImageView *IMGV_parking;
@property (weak, nonatomic) IBOutlet UILabel *LBL_parkingCount;

@property (weak, nonatomic) IBOutlet UILabel *LBL_bathroomsCount;

@property (weak, nonatomic) IBOutlet UILabel *LBL_bedroomsCount;

@property (weak, nonatomic) IBOutlet UILabel *LBL_area;
@property (weak, nonatomic) IBOutlet UILabel *LBL_price;
@property (weak, nonatomic) IBOutlet UILabel *LBL_name;

-(void)setDataFromModel:(PropertyModel*)model;

@end
