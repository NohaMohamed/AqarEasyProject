//
//  AssetsView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/20/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *bedroomCoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *bathroomCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parkingImgV;



@end
