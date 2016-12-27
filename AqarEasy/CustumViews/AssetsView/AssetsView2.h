//
//  AssetsView2.h
//  AqarEasy
//
//  Created by Atef on 6/6/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsView2 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *bedroomCoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *bathroomCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingCountLabel;

-(id)initWithFrame:(CGRect)frame;
@end
