//
//  InfoCell.m
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/10/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (void)awakeFromNib {
/*
    self.LBL_key.layer.borderColor=[UIColor colorWithRed:115/255.0 green:102/255.0 blue:74/255.0 alpha:1].CGColor;
    self.LBL_key.layer.borderWidth=0.5;
    self.LBL_bg.layer.borderColor=[UIColor colorWithRed:115/255.0 green:102/255.0 blue:74/255.0 alpha:1].CGColor;
    self.LBL_bg.layer.borderWidth=0.5;
    */
    _VIEW_sepBottom.alpha=0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
