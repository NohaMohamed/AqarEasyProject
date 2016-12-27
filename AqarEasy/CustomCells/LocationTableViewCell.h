//
//  LocationTableViewCell.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/22/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"

@interface LocationTableViewCell : SKSTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end
