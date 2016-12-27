//
//  SummaryViewiPad.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/20/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsView.h"

@interface SummaryViewiPad : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet AssetsView *assetsView;
@property (weak, nonatomic) IBOutlet UIButton *favouritebutton;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
