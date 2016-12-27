//
//  AqarInfoView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/23/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsView.h"

@interface AqarInfoView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *contractTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearBuiltLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AssetsView *assetsView;
//@property (strong, nonatomic)AssetsView *assetsViewIpad;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *numberofImagesLabel;

@end
