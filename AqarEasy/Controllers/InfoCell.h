//
//  InfoCell.h
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/10/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LBL_key;
@property (weak, nonatomic) IBOutlet UILabel *LBL_bg;
@property (weak, nonatomic) IBOutlet UILabel *LBL_val;

@property (weak, nonatomic) IBOutlet UIView *VIEW_sepBottom;

@end
