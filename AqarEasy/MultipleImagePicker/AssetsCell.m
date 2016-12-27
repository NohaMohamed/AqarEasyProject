//
//  AssetsCell.m
//  MultipleImagePicker
//
//  Created by Eng. Eman Rezk on 12/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AssetsCell.h"

@implementation AssetsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.check.hidden = YES;
}


@end
