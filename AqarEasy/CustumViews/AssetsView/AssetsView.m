//
//  AssetsView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/20/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AssetsView.h"

@implementation AssetsView
@synthesize bedroomCoutLabel,bathroomCountLabel,parkingCountLabel;
-(id)initWithFrame:(CGRect)frame
{
   
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
   
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"AssetsView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;

        [self addSubview:self.view];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
