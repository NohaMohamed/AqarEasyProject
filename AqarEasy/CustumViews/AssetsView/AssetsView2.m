//
//  AssetsView2.m
//  AqarEasy
//
//  Created by Atef on 6/6/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "AssetsView2.h"

@implementation AssetsView2
@synthesize bedroomCoutLabel,bathroomCountLabel,parkingCountLabel;
-(id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if(self){
        
        
        self= [[NSBundle mainBundle] loadNibNamed:@"AssetsView2" owner:self options:nil][0];
        self.frame=frame;
        
        
        
    }
    return self;
}
/*
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"AssetsView2" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        [self addSubview:self.view];
    }
    return self;
}*/


@end
