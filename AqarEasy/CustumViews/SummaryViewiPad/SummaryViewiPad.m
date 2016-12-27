//
//  SummaryViewiPad.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/20/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "SummaryViewiPad.h"

@implementation SummaryViewiPad

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"SummaryViewiPad" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
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
